//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by арина сильченко on 13.05.26.
//

import XCTest

final class MovieQuizUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        app = XCUIApplication()
        app.launch()
        continueAfterFailure = false

    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        app.terminate()
        app = nil
    }

    func testYesButton() throws {
        let firstPoster = app.images["Poster"]
        app.buttons["Yes"].tap()
        let secondPoster = app.images["Poster"]
        XCTAssertFalse(firstPoster == secondPoster)
    }
}
