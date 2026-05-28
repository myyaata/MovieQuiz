import UIKit

final class AlertPresenter {
    func show(on viewController: UIViewController, model: AlertModel)
    {
        let alert = UIAlertController(title: model.title,
                                      message: model.message,
                                      preferredStyle: .alert)
        
        switch model.type {
        case .result: alert.view.accessibilityIdentifier = "Result Alert"
        case .error: alert.view.accessibilityIdentifier = "Error Alert"
        }

        let action = UIAlertAction(title: model.buttonText,
                                   style: .default) { _ in
            model.completion()
        }
        alert.addAction(action)
        viewController.present(alert, animated: true, completion: nil)
    }
}
