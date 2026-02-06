import Foundation

@MainActor
final class NetworkService {
    private let baseURL = "https://finbossapi-production.up.railway.app"
    private var accessToken: String? {
        KeychainManager.shared.retrieve(key: "accessToken")
    }

    func post<T: Codable, R: Codable>(
        _ endpoint: String,
        body: T
    ) async throws -> R {
        guard let url = URL(string: baseURL + endpoint) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let token = accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              200...299 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(R.self, from: data)
    }

    func get<R: Codable>(_ endpoint: String) async throws -> R {
        guard let url = URL(string: baseURL + endpoint) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let token = accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              200...299 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(R.self, from: data)
    }

    func put<T: Codable, R: Codable>(
        _ endpoint: String,
        body: T
    ) async throws -> R {
        guard let url = URL(string: baseURL + endpoint) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let token = accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              200...299 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(R.self, from: data)
    }

    func delete<R: Codable>(_ endpoint: String) async throws -> R {
        guard let url = URL(string: baseURL + endpoint) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let token = accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              200...299 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(R.self, from: data)
    }

    // MARK: - Transaction Endpoints

    func getTransactions() async throws -> ApiResponse<[Transaction]> {
        try await get("/api/v1/transactions")
    }

    func createTransaction(_ request: CreateTransactionRequest) async throws -> ApiResponse<Transaction> {
        try await post("/api/v1/transactions", body: request)
    }

    func getTransaction(_ id: String) async throws -> ApiResponse<Transaction> {
        try await get("/api/v1/transactions/\(id)")
    }

    func updateTransaction(_ id: String, _ request: UpdateTransactionRequest) async throws -> ApiResponse<Transaction> {
        try await put("/api/v1/transactions/\(id)", body: request)
    }

    func deleteTransaction(_ id: String) async throws -> ApiResponse<[String: String]> {
        try await delete("/api/v1/transactions/\(id)")
    }
}
