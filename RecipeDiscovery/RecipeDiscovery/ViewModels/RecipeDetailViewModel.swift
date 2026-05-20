//
//  RecipeDetailViewModel.swift
//  RecipeDiscovery
//
//  Created by pajonn on 29/10/25.
//

import Foundation
import SwiftData
import Combine

@MainActor
class RecipeDetailViewModel: ObservableObject {
    @Published var recipe: Meal?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isFavorite = false
    
    private let apiService: RecipeAPIService
    private var modelContext: ModelContext?
    
    init(apiService: RecipeAPIService = .shared) {
        self.apiService = apiService
    }
    
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }
    
    func loadRecipeDetails(id: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let details = try await apiService.fetchRecipeDetails(id: id)
            recipe = details
            checkIfFavorite(id: id)
            isLoading = false
        } catch {
            errorMessage = (error as? APIError)?.localizedDescription ?? error.localizedDescription
            isLoading = false
        }
    }
    
    func checkIfFavorite(id: String) {
        guard let context = modelContext else { return }
        
        let descriptor = FetchDescriptor<FavoriteRecipe>(
            predicate: #Predicate { $0.recipeId == id }
        )
        
        do {
            let results = try context.fetch(descriptor)
            isFavorite = !results.isEmpty
        } catch {
            print("Error checking favorite status: \(error)")
        }
    }
    
    func toggleFavorite() {
        guard let recipe = recipe, let context = modelContext else { return }
        
        let descriptor = FetchDescriptor<FavoriteRecipe>(
            predicate: #Predicate { $0.recipeId == recipe.idMeal }
        )
        
        do {
            let results = try context.fetch(descriptor)
            
            if let existing = results.first {
                // Remove from favorites
                context.delete(existing)
                isFavorite = false
            } else {
                // Add to favorites
                let favorite = FavoriteRecipe(from: recipe)
                context.insert(favorite)
                isFavorite = true
            }
            
            try context.save()
        } catch {
            print("Error toggling favorite: \(error)")
            errorMessage = "Failed to update favorites"
        }
    }
}

