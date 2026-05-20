//
//  MainTabView.swift
//  RecipeDiscovery
//
//  Created by pajonn on 29/10/25.
//

import SwiftUI
import SwiftData

struct MainTabView: View {
    var body: some View {
        TabView {
            RecipeListView()
                .tabItem {
                    Label("Recipes", systemImage: "fork.knife")
                }
            
            FavoritesView()
                .tabItem {
                    Label("Favourites", systemImage: "heart.fill")
                }
        }
    }
}

#Preview {
    MainTabView()
        .modelContainer(for: FavoriteRecipe.self, inMemory: true)
}

