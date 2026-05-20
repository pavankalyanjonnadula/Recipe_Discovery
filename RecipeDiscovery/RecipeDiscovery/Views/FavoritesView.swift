//
//  FavoritesView.swift
//  RecipeDiscovery
//
//  Created by pajonn on 29/10/25.
//

import SwiftUI
import SwiftData

struct FavoritesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \FavoriteRecipe.dateAdded, order: .reverse) private var favorites: [FavoriteRecipe]
    
    var body: some View {
        NavigationStack {
            ZStack {
                if favorites.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "heart.slash")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("No favorite recipes yet")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text("Add recipes to favorites by tapping the heart icon")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                } else {
                    List {
                        ForEach(favorites) { favorite in
                            NavigationLink {
                                RecipeDetailView(recipeId: favorite.recipeId, recipe: favorite.toMeal())
                            } label: {
                                FavoriteRowView(favorite: favorite)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .onDelete(perform: deleteFavorites)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Favourites")
            .toolbar {
                if !favorites.isEmpty {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                }
            }
        }
    }
    
    private func deleteFavorites(at offsets: IndexSet) {
        for index in offsets {
            let favorite = favorites[index]
            modelContext.delete(favorite)
        }
        
        do {
            try modelContext.save()
        } catch {
            print("Error deleting favorites: \(error)")
        }
    }
}

struct FavoriteRowView: View {
    let favorite: FavoriteRecipe
    
    var body: some View {
        HStack(spacing: 12) {
            // Recipe Image
            if let thumbnailURL = favorite.thumbnailURL, let url = URL(string: thumbnailURL) {
                CachedAsyncImage(url: url) { image in
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
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay {
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    }
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            // Recipe Info
            VStack(alignment: .leading, spacing: 6) {
                Text(favorite.title)
                    .font(.headline)
                    .lineLimit(2)
                
                if let category = favorite.category {
                    HStack(spacing: 4) {
                        Image(systemName: "tag.fill")
                            .font(.caption)
                        Text(category)
                            .font(.subheadline)
                    }
                    .foregroundColor(.secondary)
                }
                
                if let area = favorite.area {
                    HStack(spacing: 4) {
                        Image(systemName: "globe")
                            .font(.caption)
                        Text(area)
                            .font(.subheadline)
                    }
                    .foregroundColor(.secondary)
                }
                
                Text("Added \(favorite.dateAdded.formatted(.relative(presentation: .named)))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "heart.fill")
                .foregroundColor(.red)
                .font(.title3)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    FavoritesView()
        .modelContainer(for: FavoriteRecipe.self, inMemory: true)
}

