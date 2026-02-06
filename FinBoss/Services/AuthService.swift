import Foundation
import Combine

@MainActor
final class AuthService: ObservableObject {
    @Published var isLoggedIn = false
    @Published var user: User?

    private let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func login(email: String, password: String) async throws -> AuthResponse {
        let request = LoginRequest(email: email, password: password)
        return try await networkService.post("/api/v1/auth/login", body: request)
    }

    func register(email: String, password: String, firstName: String, lastName: String) async throws -> AuthResponse {
        let request = RegisterRequest(
            email: email,
            password: password,
            firstName: firstName,
            lastName: lastName
        )
        return try await networkService.post("/api/v1/auth/register", body: request)
    }

    func getProfile() async throws -> User {
        return try await networkService.get("/api/v1/auth/profile")
    }

    func setAuthenticatedUser(_ user: User, token: String) {
        self.user = user
        self.isLoggedIn = true
        KeychainManager.shared.save(token: token, key: "accessToken")
    }

    func clearAuthentication() {
        self.user = nil
        self.isLoggedIn = false
        KeychainManager.shared.delete(key: "accessToken")
    }

    func checkPersistedAuth() {
        if KeychainManager.shared.retrieve(key: "accessToken") != nil {
            isLoggedIn = true
        } else {
            isLoggedIn = false
        }
    }
}

// MARK: - Request/Response Models

struct LoginRequest: Codable {
    let email: String
    let password: String
}

struct RegisterRequest: Codable {
    let email: String
    let password: String
    let firstName: String
    let lastName: String
}

struct AuthResponse: Codable {
    let accessToken: String
    let refreshToken: String
    let user: User
}

struct User: Codable, Identifiable {
    let id: String
    let email: String
    let firstName: String
    let lastName: String
}
