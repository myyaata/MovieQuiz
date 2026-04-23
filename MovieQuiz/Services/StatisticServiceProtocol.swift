protocol StatisticServiceProtocol {
    var gamesCount: Int { get }
    var bestGame: GameResult { get }
    var averageScore: Double { get }
    
    func store(correct count: Int, total amount: Int)
}

