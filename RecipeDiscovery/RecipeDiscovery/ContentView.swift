//
//  ContentView.swift
//  RecipeDiscovery
//
//  Created by pajonn on 29/10/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        MainTabView()
    }
}

#Preview {
    ContentView()
        .modelContainer(for: FavoriteRecipe.self, inMemory: true)
}
