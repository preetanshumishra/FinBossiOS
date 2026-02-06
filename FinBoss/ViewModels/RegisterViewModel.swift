import Foundation

@MainActor
final class RegisterViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let authService: AuthService

    init(authService: AuthService) {
        self.authService = authService
    }

    func register() async {
        guard validateInputs() else { return }

        isLoading = true
        defer { isLoading = false }

        do {
            let response = try await authService.register(
                email: email,
                password: password,
                firstName: firstName,
                lastName: lastName
            )
            authService.setAuthenticatedUser(response.user, token: response.accessToken)
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func validateInputs() -> Bool {
        guard !firstName.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "First name is required"
            return false
        }

        guard !lastName.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Last name is required"
            return false
        }

        guard !email.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Email is required"
            return false
        }

        guard !password.isEmpty else {
            errorMessage = "Password is required"
            return false
        }

        return true
    }
}
