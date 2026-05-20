//
//  RecipeDetailView.swift
//  RecipeDiscovery
//
//  Created by pajonn on 29/10/25.
//

import SwiftUI
import SwiftData

struct RecipeDetailView: View {
    let recipeId: String
    let recipe: Meal?
    
    @StateObject private var viewModel = RecipeDetailViewModel()
    @Environment(\.modelContext) private var modelContext
    
    var displayRecipe: Meal? {
        viewModel.recipe ?? recipe
    }
    
    var body: some View {
        ScrollView {
            if let recipe = displayRecipe {
                VStack(alignment: .leading, spacing: 20) {
                    // Hero Image
                    CachedAsyncImage(url: recipe.imageURL) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .overlay {
                                ProgressView()
                            }
                    }
                    .frame(height: 300)
                    .clipped()
                    
                    VStack(alignment: .leading, spacing: 16) {
                        // Title
                        Text(recipe.strMeal)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        // Category and Area
                        HStack(spacing: 16) {
                            if let category = recipe.strCategory {
                                Label(category, systemImage: "tag.fill")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            if let area = recipe.strArea {
                                Label(area, systemImage: "globe")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        // Tags
                        if !recipe.tags.isEmpty {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(recipe.tags, id: \.self) { tag in
                                        Text(tag)
                                            .font(.caption)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(Color.blue.opacity(0.1))
                                            .foregroundColor(.blue)
                                            .clipShape(Capsule())
                                    }
                                }
                            }
                        }
                        
                        Divider()
                        
                        // Ingredients
                        if !recipe.ingredients.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Ingredients")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                
                                ForEach(recipe.ingredients, id: \.ingredient) { item in
                                    HStack(alignment: .top, spacing: 12) {
                                        Image(systemName: "circle.fill")
                                            .font(.system(size: 6))
                                            .foregroundColor(.blue)
                                            .padding(.top, 8)
                                        
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(item.ingredient)
                                                .font(.body)
                                            if !item.measure.isEmpty {
                                                Text(item.measure)
                                                    .font(.subheadline)
                                                    .foregroundColor(.secondary)
                                            }
                                        }
                                    }
                                }
                            }
                            
                            Divider()
                        }
                        
                        // Instructions
                        if let instructions = recipe.strInstructions, !instructions.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Instructions")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                
                                Text(instructions)
                                    .font(.body)
                                    .lineSpacing(4)
                            }
                        }
                        
                        // YouTube Link
                        if let youtubeURL = recipe.strYoutube, !youtubeURL.isEmpty, let url = URL(string: youtubeURL) {
                            Divider()
                            
                            Link(destination: url) {
                                HStack {
                                    Image(systemName: "play.rectangle.fill")
                                    Text("Watch on YouTube")
                                        .fontWeight(.medium)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                            }
                        }
                    }
                    .padding()
                }
            } else if viewModel.isLoading {
                ProgressView("Loading recipe...")
                    .padding()
            } else if let errorMessage = viewModel.errorMessage {
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 50))
                        .foregroundColor(.red)
                    Text(errorMessage)
                        .foregroundColor(.secondary)
                    Button("Retry") {
                        Task {
                            await viewModel.loadRecipeDetails(id: recipeId)
                        }
                    }
                    .buttonStyle(.bordered)
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.toggleFavorite()
                } label: {
                    Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(viewModel.isFavorite ? .red : .gray)
                        .font(.title3)
                }
            }
        }
        .task {
            viewModel.setModelContext(modelContext)
            if recipe == nil {
                await viewModel.loadRecipeDetails(id: recipeId)
            } else {
                viewModel.recipe = recipe
                viewModel.checkIfFavorite(id: recipeId)
            }
        }
    }
}

#Preview {
    NavigationStack {
        RecipeDetailView(
            recipeId: "52772",
            recipe: Meal(
                idMeal: "52772",
                strMeal: "Teriyaki Chicken Casserole",
                strCategory: "Chicken",
                strArea: "Japanese",
                strInstructions: "Preheat oven to 350° F. Spray a 9x13-inch baking pan with non-stick spray.\nCombine soy sauce, ½ cup water, brown sugar, ginger and garlic in a small saucepan and cover. Bring to a boil over medium heat. Remove lid and cook for one minute once boiling.\nMeanwhile, stir together the corn starch and 2 tablespoons of water in a separate dish until smooth. Once sauce is boiling, add mixture to the saucepan and stir to combine. Cook until the sauce starts to thicken then remove from heat.\nPlace the chicken breasts in the prepared pan. Pour one cup of the sauce over top of chicken. Place chicken in oven and bake 35 minutes or until cooked through. Remove from oven and shred chicken in the pan using two forks.\n*Meanwhile, steam or cook the vegetables according to package directions.\nAdd the cooked vegetables and rice to the casserole dish with the chicken. Add most of the remaining sauce, reserving a bit to drizzle over the top when serving. Gently toss everything together in the pan until combined. Return to oven and cook 15 minutes. Remove from oven and let stand 5 minutes before serving. Drizzle each serving with remaining sauce. Enjoy!",
                strMealThumb: "https://www.themealdb.com/images/media/meals/wvpsxx1468256321.jpg",
                strTags: "Meat,Casserole",
                strYoutube: "https://www.youtube.com/watch?v=4aZr5hZXP_s",
                strIngredient1: "soy sauce", strIngredient2: "water", strIngredient3: "brown sugar", strIngredient4: "ground ginger", strIngredient5: "minced garlic", strIngredient6: nil, strIngredient7: nil, strIngredient8: nil, strIngredient9: nil, strIngredient10: nil, strIngredient11: nil, strIngredient12: nil, strIngredient13: nil, strIngredient14: nil, strIngredient15: nil, strIngredient16: nil, strIngredient17: nil, strIngredient18: nil, strIngredient19: nil, strIngredient20: nil,
                strMeasure1: "3/4 cup", strMeasure2: "1/2 cup", strMeasure3: "1/4 cup", strMeasure4: "1/2 teaspoon", strMeasure5: "1/2 teaspoon", strMeasure6: nil, strMeasure7: nil, strMeasure8: nil, strMeasure9: nil, strMeasure10: nil, strMeasure11: nil, strMeasure12: nil, strMeasure13: nil, strMeasure14: nil, strMeasure15: nil, strMeasure16: nil, strMeasure17: nil, strMeasure18: nil, strMeasure19: nil, strMeasure20: nil
            )
        )
    }
    .modelContainer(for: FavoriteRecipe.self, inMemory: true)
}

