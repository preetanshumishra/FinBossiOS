import Foundation

struct CategoryBreakdown: Identifiable, Codable {
    var id: String { category }
    let category: String
    let amount: Double
    let percentage: Double
    let transactionCount: Int
}
