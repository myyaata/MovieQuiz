import Foundation

final class MovieQuizPresenter: QuestionFactoryDelegate{
    
    private var currentQuestion: QuizQuestion?
    private var correctAnswers: Int = 0
    private var isWaitingForNextQuestion = false
    private var currentQuestionIndex = 0
    private let questionsAmount: Int = 10
    
    private let statisticService: StatisticServiceProtocol!
    private var questionFactory: QuestionFactoryProtocol?
    private weak var viewController: MovieQuizViewControllerProtocol?

    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        statisticService = StatisticService()
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(networkClient: NetworkClient()), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
    
    // MARK: - QuestionFactoryDelegate
    func didLoadDataFromServer() {
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        viewController?.showNetworkError(message: error.localizedDescription)
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else { return }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.hideLoadingIndicator()
            self?.viewController?.show(quiz: viewModel)
            self?.viewController?.enableButtons(true)
        }
    }
    
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
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
    func showNextQuestionOrResults() {
        if self.isLastQuestion() {
            //результат квиза
            statisticService.store(correct: correctAnswers, total: self.questionsAmount)
            let gamesCount = statisticService.gamesCount
            let bestGame = statisticService.bestGame
            let averageScore = statisticService.averageScore
            
            let text = "Ваш результат: \(correctAnswers)/\(self.questionsAmount)\nКоличество сыгранных квизов: \(gamesCount)\nРекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))\nСредняя точность: \(String(format: "%.2f", averageScore))%"
            let viewModel = QuizResultViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть еще раз")
            viewController?.show(quiz: viewModel)
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
    func showAnswerResult(isCorrect: Bool) {
        guard isWaitingForNextQuestion != true else { return }
        isWaitingForNextQuestion = true
        viewController?.enableButtons(false)
        didAnswer(isCorrectAnswer: isCorrect)
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            self.isWaitingForNextQuestion = false
            self.showNextQuestionOrResults()
        }
    }
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    func didAnswer(isCorrectAnswer: Bool) {
        if isCorrectAnswer {
            correctAnswers += 1
        } else {
            return
        }
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else { return }
        let givenAnswer = isYes
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
}
