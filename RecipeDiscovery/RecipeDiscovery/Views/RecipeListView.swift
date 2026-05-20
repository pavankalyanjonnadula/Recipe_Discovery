//
//  RecipeListView.swift
//  RecipeDiscovery
//
//  Created by pajonn on 29/10/25.
//

import SwiftUI
import SwiftData

struct RecipeListView: View {
    @StateObject private var viewModel = RecipeListViewModel()
    @Environment(\.modelContext) private var modelContext
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.recipes.isEmpty && !viewModel.isLoading {
                    VStack(spacing: 16) {
                        Image(systemName: "fork.knife.circle")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("No recipes found")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text("Pull down to refresh")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .accessibilityIdentifier("emptyStateView")
                } else {
                    List {
                        ForEach(viewModel.recipes) { recipe in
                            NavigationLink {
                                RecipeDetailView(recipeId: recipe.idMeal, recipe: recipe)
                            } label: {
                                RecipeRowView(recipe: recipe)
                            }
//                            .buttonStyle(PlainButtonStyle())
                            .onAppear {
                                // Lazy loading: load more when reaching near the end
                                if recipe.id == viewModel.recipes.last?.id {
                                    Task {
                                        await viewModel.loadMoreRecipes()
                                    }
                                }
                            }
                        }
                        
                        // Loading indicator at bottom
                        if viewModel.isLoading {
                            HStack {
                                Spacer()
                                ProgressView()
                                    .padding()
                                Spacer()
                            }
                            .listRowSeparator(.hidden)
                        }
                    }
                    .accessibilityIdentifier("recipeList")
                    .listStyle(.plain)
                    .refreshable {
                        await viewModel.loadInitialRecipes()
                    }
                }
                
                // Error overlay
                if let errorMessage = viewModel.errorMessage {
                    VStack {
                        Spacer()
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.white)
                            Text(errorMessage)
                                .foregroundColor(.white)
                                .font(.subheadline)
                        }
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                        .padding()
                        Spacer()
                            .frame(height: 100)
                    }
                    .transition(.move(edge: .bottom))
                    .animation(.easeInOut, value: viewModel.errorMessage)
                }
            }
            .navigationTitle("Recipes")
            .searchable(text: $searchText, prompt: "Search recipes...")
            .onChange(of: searchText) { _, newValue in
                viewModel.searchText = newValue
                Task {
                    try? await Task.sleep(nanoseconds: 500_000_000) // Debounce
                    if viewModel.searchText == newValue {
                        await viewModel.searchRecipes()
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if viewModel.isLoading && viewModel.recipes.isEmpty {
                        ProgressView()
                    }
                }
            }
        }
        .task {
            if viewModel.recipes.isEmpty {
                await viewModel.loadInitialRecipes()
            }
        }
    }
}

#Preview {
    RecipeListView()
        .modelContainer(for: FavoriteRecipe.self, inMemory: true)
}


#Preview {
    NavigationStack {
        RecipeListView()
            .modelContainer(for: FavoriteRecipe.self, inMemory: true)
    }
}

