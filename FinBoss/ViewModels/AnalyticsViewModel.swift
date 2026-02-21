import Foundation
import Combine

@MainActor
final class AnalyticsViewModel: ObservableObject {
    @Published var categoryBreakdown: [CategoryBreakdown] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil

    private let analyticsService: AnalyticsService
    private var cancellables = Set<AnyCancellable>()

    init(analyticsService: AnalyticsService) {
        self.analyticsService = analyticsService
        observeAnalyticsService()
    }

    private func observeAnalyticsService() {
        analyticsService.$categoryBreakdown
            .receive(on: DispatchQueue.main)
            .assign(to: &$categoryBreakdown)

        analyticsService.$isLoading
            .receive(on: DispatchQueue.main)
            .assign(to: &$isLoading)

        analyticsService.$errorMessage
            .receive(on: DispatchQueue.main)
            .assign(to: &$errorMessage)
    }

    func loadCategoryBreakdown() async {
        await analyticsService.loadCategoryBreakdown()
    }

    func clearError() {
        analyticsService.clearError()
    }
}
