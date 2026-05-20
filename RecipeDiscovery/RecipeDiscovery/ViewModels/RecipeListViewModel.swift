//
//  RecipeListViewModel.swift
//  RecipeDiscovery
//
//  Created by pajonn on 29/10/25.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class RecipeListViewModel: ObservableObject {
    @Published var recipes: [Meal] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText = ""
    
    private let apiService: RecipeAPIService
    private var currentLetterIndex = 0
    private let alphabet = "abcdefghijklmnopqrstuvwxyz".map { String($0) }
    private var hasMoreData = true
    
    init(apiService: RecipeAPIService = .shared) {
        self.apiService = apiService
    }
    
    func loadInitialRecipes() async {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        recipes = []
        currentLetterIndex = 0
        hasMoreData = true
        
        await loadMoreRecipes()
    }
    
    func loadMoreRecipes() async {
        guard hasMoreData, currentLetterIndex < alphabet.count else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let letter = alphabet[currentLetterIndex]
            print("📡 Loading recipes for letter: \(letter)")
            let newRecipes = try await apiService.fetchRecipesByLetter(letter)
            
            print("✅ Loaded \(newRecipes.count) recipes for letter: \(letter)")
            recipes.append(contentsOf: newRecipes)
            currentLetterIndex += 1
            
            if currentLetterIndex >= alphabet.count {
                hasMoreData = false
            }
            
            isLoading = false
        } catch {
            let errorDesc = (error as? APIError)?.localizedDescription ?? error.localizedDescription
            print("❌ Error loading recipes: \(errorDesc)")
            print("❌ Full error: \(error)")
            errorMessage = errorDesc
            isLoading = false
        }
    }
    
    func searchRecipes() async {
        guard !searchText.isEmpty else {
            await loadInitialRecipes()
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let results = try await apiService.searchRecipes(query: searchText)
            recipes = results
            isLoading = false
        } catch {
            errorMessage = (error as? APIError)?.localizedDescription ?? error.localizedDescription
            isLoading = false
        }
    }
}

