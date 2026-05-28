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
    
    func waitForElement(_ element: XCUIElement, timeout: TimeInterval = 3) {
        XCTAssertTrue(element.waitForExistence(timeout: timeout))
   }

    func testYesButton() {
        let firstPoster = app.images["Poster"]
        waitForElement(firstPoster)
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        app.buttons["Yes"].tap()
        let secondPoster = app.images["Poster"]
        waitForElement(secondPoster)
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        let indexLabel = app.staticTexts["Index"]
        XCTAssertEqual(indexLabel.label, "2/10")
        XCTAssertFalse(firstPosterData == secondPosterData)
    }
    
    func testNoButton() {
        let firstPoster = app.images["Poster"]
        waitForElement(firstPoster)
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        app.buttons["No"].tap()
        let secondPoster = app.images["Poster"]
        waitForElement(secondPoster)
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        let indexLabel = app.staticTexts["Index"]
        XCTAssertEqual(indexLabel.label, "2/10")
        XCTAssertFalse(firstPosterData == secondPosterData)
    }
    
    func testResultAlert() {
        let yesButton = app.buttons["Yes"]
        waitForElement(yesButton)
        for _ in 1...10 {
            yesButton.tap()
            sleep(1)
        }
        let alert = app.alerts["Result Alert"]
        
        XCTAssertTrue(alert.waitForExistence(timeout: 5))
        XCTAssertTrue(alert.label == "Этот раунд окончен!")
        XCTAssertTrue(alert.buttons.firstMatch.label == "Сыграть еще раз")
    }
    
    func testAlertButton() {
        let noButton = app.buttons["No"]
        waitForElement(noButton)
        let indexLabel = app.staticTexts["Index"]
        for _ in 1...10 {
            noButton.tap()
            sleep(1)
        }
        let alert = app.alerts["Result Alert"]
        XCTAssertTrue(alert.waitForExistence(timeout: 5))

        alert.buttons.firstMatch.tap()
        XCTAssertFalse(alert.exists)
        XCTAssertTrue(indexLabel.waitForExistence(timeout: 3))
        XCTAssertTrue(indexLabel.label == "1/10")
    }
}
