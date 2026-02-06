import Foundation

struct ApiResponse<T: Codable>: Codable {
    let status: String
    let message: String?
    let data: T?
}

struct Transaction: Identifiable, Codable {
    let id: String
    let userId: String
    let type: TransactionType
    let amount: Double
    let category: String
    let description: String?
    let date: Date
    let createdAt: Date
    let updatedAt: Date

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case userId
        case type
        case amount
        case category
        case description
        case date
        case createdAt
        case updatedAt
    }

    enum TransactionType: String, Codable {
        case income
        case expense
    }
}

struct CreateTransactionRequest: Codable {
    let type: String
    let amount: Double
    let category: String
    let description: String?
    let date: Date
}

struct UpdateTransactionRequest: Codable {
    let type: String?
    let amount: Double?
    let category: String?
    let description: String?
    let date: Date?
}
