# Recipe Discovery App - Quick Start Guide

## 🎯 Project Overview

A modern iOS app that fetches recipes from TheMealDB API with lazy loading, search, and local favorites storage.

## ✨ Key Features

### 1. **Lazy Loading** 📜
- Automatically loads recipes as you scroll
- Fetches alphabetically (a→z) from the API
- Smooth, efficient pagination

### 2. **Two Tabs** 📱
- **Recipes Tab**: Browse all recipes with search
- **Favourites Tab**: Your saved recipes

### 3. **SwiftData Storage** 💾
- Persistent local storage for favorites
- Survives app restarts
- Fast retrieval

### 4. **Search & Filter** 🔍
- Search by recipe name or ingredients
- Real-time results

## 🏗 Architecture

```
MVVM Pattern
├── Models       (Data structures)
├── Services     (API calls)
├── ViewModels   (Business logic)
└── Views        (UI)
```

## 📡 API Details

**Base URL**: `www.themealdb.com/api/json/v1/1`

**Endpoints**:
- `search.php?f=a` - Get recipes starting with 'a'
- `lookup.php?i=52772` - Get recipe details
- `search.php?s=chicken` - Search recipes

## 🚀 Running the App

1. Open `RecipeDiscovery.xcodeproj`
2. Select iOS Simulator (iPhone 17+)
3. Press ⌘R to run
4. Scroll to see lazy loading in action!

## 📂 File Structure

```
RecipeDiscovery/
├── Models/
│   ├── Recipe.swift          (API models)
│   └── FavoriteRecipe.swift  (SwiftData model)
│
├── Services/
│   └── RecipeAPIService.swift
│
├── ViewModels/
│   ├── RecipeListViewModel.swift
│   └── RecipeDetailViewModel.swift
│
└── Views/
    ├── MainTabView.swift          (Tab container)
    ├── RecipeListView.swift       (Recipes list)
    ├── RecipeDetailView.swift     (Recipe details)
    ├── FavoritesView.swift        (Favorites list)
    └── Components/
        ├── CachedAsyncImage.swift
        └── RecipeRowView.swift
```

## 💡 How It Works

### Lazy Loading Implementation

1. App starts loading recipes with letter 'a'
2. When user scrolls to last item, triggers next letter load
3. Continues through alphabet until 'z'
4. Shows loading indicator during fetch

```swift
.onAppear {
    if recipe.id == viewModel.recipes.last?.id {
        Task {
            await viewModel.loadMoreRecipes()
        }
    }
}
```

### Favorites Implementation

1. Tap heart icon on recipe detail
2. Recipe saved to SwiftData
3. Appears in Favourites tab
4. Persists across app launches

```swift
@Model
final class FavoriteRecipe {
    @Attribute(.unique) var recipeId: String
    var title: String
    // ... other properties
}
```

## 🎨 UI Components

- **RecipeRowView**: Beautiful recipe cards with image, name, tags
- **RecipeDetailView**: Full recipe with ingredients, instructions
- **CachedAsyncImage**: Efficient image loading
- **Pull-to-Refresh**: Manual refresh capability
- **Empty States**: User-friendly messages

## 🔧 Technologies Used

- **SwiftUI**: Declarative UI
- **SwiftData**: Local persistence
- **Async/Await**: Modern concurrency
- **Combine**: Reactive programming
- **URLSession**: Network calls

## ✅ Build Status

```
✅ Compiles without errors
✅ All features implemented
✅ Clean architecture
✅ Ready for production
```

## 📊 Performance

- Lazy loading reduces initial load time
- Image caching improves scrolling
- SwiftData provides fast local storage
- Async/await prevents UI blocking

## 🎯 User Flows

### Browse Recipes
1. Launch app → Recipes tab
2. Scroll to trigger lazy loading
3. Tap recipe → See details
4. Tap heart → Add to favorites

### Search Recipes
1. Tap search bar
2. Type query
3. Results appear in real-time
4. Tap any result

### Manage Favorites
1. Switch to Favourites tab
2. See all saved recipes
3. Swipe left to delete
4. Tap to view details

## 🚨 Error Handling

- Network errors: Shows error message
- No results: Shows empty state
- API failures: Graceful degradation

## 📱 Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+
- Active internet connection

## 🎉 Success!

Your Recipe Discovery app is ready to use! Enjoy exploring thousands of recipes with smooth lazy loading and persistent favorites.

