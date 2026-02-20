import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var user: User?

    private let authService: AuthService

    init(authService: AuthService) {
        self.authService = authService
        self.user = authService.user
    }

    func logout() {
        Task {
            await authService.logout()
        }
    }
}
