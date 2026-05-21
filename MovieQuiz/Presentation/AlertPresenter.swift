import UIKit

final class AlertPresenter {
    func show(on viewController: UIViewController, model: AlertModel)
    {
        let alert = UIAlertController(title: model.title,
                                      message: model.message,
                                      preferredStyle: .alert)
        
        alert.view.accessibilityIdentifier = "Quiz Alert"
        if model.title == "Ошибка" {
            alert.view.accessibilityIdentifier = "Error Alert"
        } else if model.title == "Этот раунд окончен!" {
            alert.view.accessibilityIdentifier = "Result Alert"
        }

        let action = UIAlertAction(title: model.buttonText,
                                   style: .default) { _ in
            model.completion()
        }
        alert.addAction(action)
        viewController.present(alert, animated: true, completion: nil)
    }
}
