import Foundation

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date
    
    func compareGameResults(currentRecord: GameResult) -> Bool {
        guard currentRecord.total > 0 else { return true }
        guard self.total > 0 else { return false }
        
        let currentGamePercentage = Double(self.correct) / Double(self.total)
        let recordGamePercentage = Double(currentRecord.correct) / Double(currentRecord.total)
        return currentGamePercentage > recordGamePercentage
    }
}
