import Foundation

struct CreateTransactionRequest: Codable {
    let type: String
    let amount: Double
    let category: String
    let description: String?
    let date: Date
}
