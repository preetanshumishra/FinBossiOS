import Foundation

@MainActor
final class AnalyticsService: ObservableObject {
    @Published var categoryBreakdown: [CategoryBreakdown] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil

    private let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func loadCategoryBreakdown() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let response: ApiResponse<[CategoryBreakdown]> = try await networkService.get("/api/v1/transactions/analytics/category")
            if response.status == "success" {
                self.categoryBreakdown = response.data ?? []
            } else {
                self.errorMessage = response.message ?? "Failed to load analytics"
            }
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    func clearError() {
        errorMessage = nil
    }
}
