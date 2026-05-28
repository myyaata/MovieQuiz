import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func show(quiz step: QuizStepViewModel) {
        
    }
    func show(quiz result: QuizResultViewModel) {
        
    }
    func showNetworkError(message: String) {
        
    }
    func highlightImageBorder(isCorrectAnswer: Bool) {
        
    }
    func showLoadingIndicator() {
        
    }
    func hideLoadingIndicator() {
        
    }
    func enableButtons(_ enabled: Bool) {
        
    }
}

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let testPresenter = MovieQuizPresenter(viewController: viewControllerMock)
        
        let question = QuizQuestion(image: Data(), text: "question text", correctAnswer: true)
        let viewModel = testPresenter.convert(model: question)
        
        XCTAssertEqual(viewModel.image, Data())
        XCTAssertEqual(viewModel.question, "question text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}
