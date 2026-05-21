import UIKit
import Foundation

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {

    // MARK: - Properties
    private var alertPresenter = AlertPresenter()
    
    private var presenter: MovieQuizPresenter!
        
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MovieQuizPresenter(viewController: self)
    }

    
    // MARK: - Show Funcs
    func show(quiz step: QuizStepViewModel) {
        imageView.layer.borderWidth = 0
        imageView.image = UIImage(data: step.image) ?? UIImage()
        counterLabel.text = step.questionNumber
        textLabel.text = step.question
    }
    
    func show(quiz result: QuizResultViewModel) {
        let model = AlertModel(title: result.title, message: result.text, buttonText: result.buttonText) { [weak self] in
            guard let self else { return }
            self.presenter.restartGame()
        }
        alertPresenter.show(on: self, model: model)
    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        let model = AlertModel(title: "Ошибка", message: message, buttonText: "Попробовать еще раз") { [weak self] in
            guard let self else { return }
            self.presenter.restartGame()
        }
        alertPresenter.show(on: self, model: model)
    }
    
    func enableButtons(_ enabled: Bool) {
        yesButton.isEnabled = enabled
        noButton.isEnabled = enabled
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    // MARK: - Outlets
    @IBOutlet private weak var imageView: UIImageView!
        
    @IBOutlet private weak var counterLabel: UILabel!
        
    @IBOutlet private weak var textLabel: UILabel!

    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet private weak var noButton: UIButton!
    
    @IBOutlet private weak var yesButton: UIButton!
    
    // MARK: - Actions
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
}
