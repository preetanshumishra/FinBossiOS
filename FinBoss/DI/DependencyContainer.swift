import Foundation

/// Simple dependency container for manual dependency injection
/// Replaces Swinject for a cleaner, enterprise-standard approach
@MainActor
final class DependencyContainer {
    static let shared = DependencyContainer()

    private lazy var networkService = NetworkService()

    nonisolated private init() {}

    // MARK: - Services

    func makeNetworkService() -> NetworkService {
        networkService
    }

    func makeAuthService() -> AuthService {
        AuthService(networkService: networkService)
    }

    func makeTransactionService() -> TransactionService {
        TransactionService(networkService: networkService)
    }

    // MARK: - ViewModels

    func makeLoginViewModel() -> LoginViewModel {
        LoginViewModel(authService: makeAuthService())
    }

    func makeRegisterViewModel() -> RegisterViewModel {
        RegisterViewModel(authService: makeAuthService())
    }

    func makeHomeViewModel(authService: AuthService) -> HomeViewModel {
        HomeViewModel(authService: authService)
    }

    func makeTransactionViewModel() -> TransactionViewModel {
        TransactionViewModel(transactionService: makeTransactionService())
    }
}
