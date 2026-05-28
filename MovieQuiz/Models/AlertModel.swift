enum AlertType {
    case error
    case result
}

struct AlertModel {
    let type: AlertType
    let title: String
    let message: String
    let buttonText: String
    let completion: () -> Void
}
