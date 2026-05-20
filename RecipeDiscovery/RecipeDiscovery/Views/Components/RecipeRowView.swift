//
//  RecipeRowView.swift
//  RecipeDiscovery
//
//  Created by pajonn on 29/10/25.
//

import SwiftUI

struct RecipeRowView: View {
    let recipe: Meal
    
    var body: some View {
        HStack(spacing: 12) {
            // Recipe Image
            CachedAsyncImage(url: recipe.imageURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay {
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    }
            }
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            // Recipe Info
            VStack(alignment: .leading, spacing: 6) {
                Text(recipe.strMeal)
                    .font(.headline)
                    .lineLimit(2)
                
                if let category = recipe.strCategory {
                    HStack(spacing: 4) {
                        Image(systemName: "tag.fill")
                            .font(.caption)
                        Text(category)
                            .font(.subheadline)
                    }
                    .foregroundColor(.secondary)
                }
                
                if let area = recipe.strArea {
                    HStack(spacing: 4) {
                        Image(systemName: "globe")
                            .font(.caption)
                        Text(area)
                            .font(.subheadline)
                    }
                    .foregroundColor(.secondary)
                }
                
                // Tags
                if true {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 4) {
                            ForEach(recipe.tags.prefix(3), id: \.self) { tag in
                                Text(tag)
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.blue.opacity(0.1))
                                    .foregroundColor(.blue)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                }
            }
            
//            Spacer()
//            
//            Image(systemName: "chevron.right")
//                .foregroundColor(.gray)
//                .font(.caption)
        }
        .padding(.vertical, 8)
    }
}

