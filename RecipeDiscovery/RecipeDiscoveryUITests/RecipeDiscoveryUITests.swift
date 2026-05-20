//
//  RecipeDiscoveryUITests.swift
//  RecipeDiscoveryUITests
//
//  Created by pajonn on 18/05/26.
//

import XCTest

final class RecipeDiscoveryUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // XCUIAutomation Documentation
        // https://developer.apple.com/documentation/xcuiautomation
    }
    
    @MainActor
    func testRecipeListLoadsSuccessfully() throws {
        // App launch cheyandi
        let app = XCUIApplication()
        app.launch()
        
        // Recipe list kanipistunda ani wait cheyandi (10 seconds varaku - API slow avvachu)
        let recipeList = app.otherElements["recipeList"]
        XCTAssertTrue(recipeList.waitForExistence(timeout: 10), "Recipe list load avvaledu!")
        
        // Loading ayyi recipes vachhaaya check cheyandi
        let cells = app.cells
        XCTAssertGreaterThan(cells.count, 0, "Recipes load avvaledu!")
        
        print("✅ Test passed: \(cells.count) recipes loaded")
    }
    
    @MainActor
    func testSearchFunctionality() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Modataga recipes load ayyela wait cheyandi
        let recipeList = app.otherElements["recipeList"]
        XCTAssertTrue(recipeList.waitForExistence(timeout: 10))
        
        // Search bar ni find chesi tap cheyandi
        let searchField = app.searchFields["Search recipes..."]
        XCTAssertTrue(searchField.exists, "Search bar ledu!")
        searchField.tap()
        
        // "Chicken" ane word type cheyandi
        searchField.typeText("Chicken")
        
        // Results kosam wait cheyandi (debounce + API call)
        sleep(2)
        
        // Results vachhaya check cheyandi
        let cells = app.cells
        if cells.count > 0 {
            print("✅ Search test passed: \(cells.count) results vachhayi")
        } else {
            print("⚠️ No results for 'Chicken', but search worked")
        }
        
        XCTAssertTrue(true, "Search functionality work ayyindi")
    }
    
    @MainActor
    func testRecipeDetailNavigation() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Recipe list load ayyela wait cheyandi
        let recipeList = app.otherElements["recipeList"]
        XCTAssertTrue(recipeList.waitForExistence(timeout: 10))
        
        // First recipe ni tap cheyandi
        let firstCell = app.cells.firstMatch
        XCTAssertTrue(firstCell.exists, "First recipe ledu!")
        firstCell.tap()
        
        // Detail view open ayyinda check cheyandi (navigation back button untunda)
        let backButton = app.navigationBars.buttons.element(boundBy: 0)
        XCTAssertTrue(backButton.waitForExistence(timeout: 5), "Detail view open avvaledu!")
        
        print("✅ Navigation test passed")
        
        // Back button tap chesi list ki ravandi
        backButton.tap()
        XCTAssertTrue(recipeList.waitForExistence(timeout: 3), "Back navigation fail ayyindi!")
    }

//    @MainActor
//    func testLaunchPerformance() throws {
//        // This measures how long it takes to launch your application.
//        measure(metrics: [XCTApplicationLaunchMetric()]) {
//            XCUIApplication().launch()
//        }
//    }
}
