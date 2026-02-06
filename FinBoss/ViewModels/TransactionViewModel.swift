import Foundation
import Combine

@MainActor
final class TransactionViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil

    private let transactionService: TransactionService
    private var cancellables = Set<AnyCancellable>()

    init(transactionService: TransactionService) {
        self.transactionService = transactionService
        observeTransactionService()
    }

    private func observeTransactionService() {
        transactionService.$transactions
            .receive(on: DispatchQueue.main)
            .assign(to: &$transactions)

        transactionService.$isLoading
            .receive(on: DispatchQueue.main)
            .assign(to: &$isLoading)

        transactionService.$errorMessage
            .receive(on: DispatchQueue.main)
            .assign(to: &$errorMessage)
    }

    func loadTransactions() async {
        await transactionService.loadTransactions()
        updateFromService()
    }

    func createTransaction(
        type: String,
        amount: Double,
        category: String,
        description: String?,
        date: Date
    ) async {
        await transactionService.createTransaction(
            type: type,
            amount: amount,
            category: category,
            description: description,
            date: date
        )
        updateFromService()
    }

    func deleteTransaction(_ id: String) async {
        await transactionService.deleteTransaction(id)
        updateFromService()
    }

    func clearError() {
        transactionService.clearError()
    }

    private func updateFromService() {
        transactions = transactionService.transactions
        isLoading = transactionService.isLoading
        errorMessage = transactionService.errorMessage
    }
}
