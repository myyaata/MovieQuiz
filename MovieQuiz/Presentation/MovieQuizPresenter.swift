
final class MovieQuizPresenter {
    
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    
    private var currentQuestionIndex = 0
    let questionsAmount: Int = 10
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        let quizStepViewModel = QuizStepViewModel(
            image: model.image,
            question: model.text,
            questionNumber: "\(currentQuestionIndex+1)/\(questionsAmount)")
        return quizStepViewModel
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func yesButtonClicked() {
        guard let currentQuestion = currentQuestion else { return }
        if currentQuestion.correctAnswer == true {
            viewController?.showAnswerResult(isCorrect: true)
        } else {
            viewController?.showAnswerResult(isCorrect: false)
        }
    }
    
    func noButtonClicked() {
        guard let currentQuestion = currentQuestion else { return }
        if currentQuestion.correctAnswer == false {
            viewController?.showAnswerResult(isCorrect: true)
        } else {
            viewController?.showAnswerResult(isCorrect: false)
        }
    }
}
