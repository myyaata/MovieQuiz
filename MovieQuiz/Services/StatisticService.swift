import Foundation

final class StatisticService {
    
    private enum Keys: String {
        case gamesCount
        case bestGame_correctAnswers
        case bestGame_totalQuestions
        case bestGame_date
        case totalCorrectAnswers
        case totalQuestionsAsked
    }
    
    private let storage: UserDefaults = .standard
    
    private var totalCorrectAnswers: Int {
        get {
            storage.integer(forKey: Keys.totalCorrectAnswers.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.totalCorrectAnswers.rawValue)
        }
    }
    
    private var totalQuestionsAsked: Int {
        get {
            storage.integer(forKey: Keys.totalQuestionsAsked.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.totalQuestionsAsked.rawValue)
        }
    }
    
}

extension StatisticService: StatisticServiceProtocol {
    var gamesCount: Int {
        get {
            storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameResult {
        get {
            let correct = storage.integer(forKey: Keys.bestGame_correctAnswers.rawValue)
            let total = storage.integer(forKey: Keys.bestGame_totalQuestions.rawValue)
            let date = storage.object(forKey: Keys.bestGame_date.rawValue) as? Date ?? Date()
            return GameResult(correct: correct, total: total, date: date)
        }
        set {
            storage.set(newValue.correct, forKey: Keys.bestGame_correctAnswers.rawValue)
            storage.set(newValue.total, forKey: Keys.bestGame_totalQuestions.rawValue)
            storage.set(newValue.date, forKey: Keys.bestGame_date.rawValue)
        }
    }
    
    var averageScore: Double {
        guard totalQuestionsAsked > 0 else { return 0.0 }
        return (Double(totalCorrectAnswers) / Double(totalQuestionsAsked)) * 100.0
    }
    
    func store(correct count: Int, total amount: Int) {
        let updatedCorrectAnswers = totalCorrectAnswers + count
        let updatedTotalQuestionsAsked = totalQuestionsAsked + amount
        
        totalCorrectAnswers = updatedCorrectAnswers
        totalQuestionsAsked = updatedTotalQuestionsAsked
        gamesCount += 1
        
        let newGame = GameResult(correct: count, total: amount, date: Date())
        if newGame.compareGameResults(currentRecord: bestGame) {
            bestGame = newGame
        }
    }
    
    
}
