//
//  RecipeAPIService.swift
//  RecipeDiscovery
//
//  Created by pajonn on 29/10/25.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case noData
    case decodingError
    case networkError(Error)
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .decodingError:
            return "Failed to decode response"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}

@MainActor
class RecipeAPIService {
    static let shared = RecipeAPIService()
    
    private let baseURL = "https://www.themealdb.com/api/json/v1/1"
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    // Fetch recipes by first letter
    func fetchRecipesByLetter(_ letter: String) async throws -> [Meal] {
        let urlString = "\(baseURL)/search.php?f=\(letter)"
        
        print("🌐 Making API call to: \(urlString)")
        
        guard let url = URL(string: urlString) else {
            print("❌ Invalid URL: \(urlString)")
            throw APIError.invalidURL
        }
        
        do {
            let (data, response) = try await session.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("📊 HTTP Status Code: \(httpResponse.statusCode)")
            }
            
            // Log the raw response for debugging
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📄 Raw API Response (first 500 chars): \(String(jsonString.prefix(500)))")
            }
            
            let decodedResponse = try JSONDecoder().decode(MealResponse.self, from: data)
            let meals = decodedResponse.meals ?? []
            print("✅ Successfully decoded \(meals.count) meals")
            return meals
        } catch let error as DecodingError {
            print("❌ Decoding error: \(error)")
            throw APIError.decodingError
        } catch {
            print("❌ Network error: \(error)")
            throw APIError.networkError(error)
        }
    }
    
    // Fetch recipe details by ID
    func fetchRecipeDetails(id: String) async throws -> Meal {
        let urlString = "\(baseURL)/lookup.php?i=\(id)"
        
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        
        do {
            let (data, _) = try await session.data(from: url)
            let response = try JSONDecoder().decode(MealDetailResponse.self, from: data)
            guard let meal = response.meals?.first else {
                throw APIError.noData
            }
            return meal
        } catch let error as DecodingError {
            print("Decoding error: \(error)")
            throw APIError.decodingError
        } catch {
            print("Network error: \(error)")
            throw APIError.networkError(error)
        }
    }
    
    // Search recipes by name
    func searchRecipes(query: String) async throws -> [Meal] {
        let urlString = "\(baseURL)/search.php?s=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query)"
        
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        
        do {
            let (data, _) = try await session.data(from: url)
            let response = try JSONDecoder().decode(MealResponse.self, from: data)
            return response.meals ?? []
        } catch let error as DecodingError {
            print("Decoding error: \(error)")
            throw APIError.decodingError
        } catch {
            print("Network error: \(error)")
            throw APIError.networkError(error)
        }
    }
}

