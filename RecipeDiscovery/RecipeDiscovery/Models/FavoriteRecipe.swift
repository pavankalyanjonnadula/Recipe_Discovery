//
//  FavoriteRecipe.swift
//  RecipeDiscovery
//
//  Created by pajonn on 29/10/25.
//

import Foundation
import SwiftData

@Model
final class FavoriteRecipe {
    @Attribute(.unique) var recipeId: String
    var title: String
    var category: String?
    var area: String?
    var instructions: String?
    var thumbnailURL: String?
    var tags: String?
    var dateAdded: Date
    
    init(recipeId: String, title: String, category: String? = nil, area: String? = nil, instructions: String? = nil, thumbnailURL: String? = nil, tags: String? = nil, dateAdded: Date = Date()) {
        self.recipeId = recipeId
        self.title = title
        self.category = category
        self.area = area
        self.instructions = instructions
        self.thumbnailURL = thumbnailURL
        self.tags = tags
        self.dateAdded = dateAdded
    }
    
    // Convert from Meal model
    convenience init(from meal: Meal) {
        self.init(
            recipeId: meal.idMeal,
            title: meal.strMeal,
            category: meal.strCategory,
            area: meal.strArea,
            instructions: meal.strInstructions,
            thumbnailURL: meal.strMealThumb,
            tags: meal.strTags,
            dateAdded: Date()
        )
    }
    
    // Convert to Meal model for display
    func toMeal() -> Meal {
        return Meal(
            idMeal: recipeId,
            strMeal: title,
            strCategory: category,
            strArea: area,
            strInstructions: instructions,
            strMealThumb: thumbnailURL,
            strTags: tags,
            strYoutube: nil,
            strIngredient1: nil, strIngredient2: nil, strIngredient3: nil, strIngredient4: nil, strIngredient5: nil,
            strIngredient6: nil, strIngredient7: nil, strIngredient8: nil, strIngredient9: nil, strIngredient10: nil,
            strIngredient11: nil, strIngredient12: nil, strIngredient13: nil, strIngredient14: nil, strIngredient15: nil,
            strIngredient16: nil, strIngredient17: nil, strIngredient18: nil, strIngredient19: nil, strIngredient20: nil,
            strMeasure1: nil, strMeasure2: nil, strMeasure3: nil, strMeasure4: nil, strMeasure5: nil,
            strMeasure6: nil, strMeasure7: nil, strMeasure8: nil, strMeasure9: nil, strMeasure10: nil,
            strMeasure11: nil, strMeasure12: nil, strMeasure13: nil, strMeasure14: nil, strMeasure15: nil,
            strMeasure16: nil, strMeasure17: nil, strMeasure18: nil, strMeasure19: nil, strMeasure20: nil
        )
    }
}

