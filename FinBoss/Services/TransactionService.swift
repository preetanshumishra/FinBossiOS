import Foundation

@MainActor
final class TransactionService: ObservableObject {
    @Published var transactions: [Transaction] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil

    private let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    @MainActor
    func loadTransactions() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let response: ApiResponse<[Transaction]> = try await networkService.getTransactions()
            if response.status == "success" {
                self.transactions = response.data ?? []
                self.errorMessage = nil
            } else {
                self.errorMessage = response.message ?? "Failed to load transactions"
            }
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    @MainActor
    func createTransaction(
        type: String,
        amount: Double,
        category: String,
        description: String?,
        date: Date
    ) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        let request = CreateTransactionRequest(
            type: type,
            amount: amount,
            category: category,
            description: description?.isEmpty == true ? nil : description,
            date: date
        )

        do {
            let response: ApiResponse<Transaction> = try await networkService.createTransaction(request)
            if response.status == "success", let transaction = response.data {
                self.transactions.append(transaction)
                self.errorMessage = nil
            } else {
                self.errorMessage = response.message ?? "Failed to create transaction"
            }
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    @MainActor
    func updateTransaction(
        id: String,
        type: String?,
        amount: Double?,
        category: String?,
        description: String?,
        date: Date?
    ) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        let request = UpdateTransactionRequest(
            type: type,
            amount: amount,
            category: category,
            description: description?.isEmpty == true ? nil : description,
            date: date
        )

        do {
            let response: ApiResponse<Transaction> = try await networkService.updateTransaction(id, request)
            if response.status == "success", let updatedTransaction = response.data {
                if let index = self.transactions.firstIndex(where: { $0.id == id }) {
                    self.transactions[index] = updatedTransaction
                }
                self.errorMessage = nil
            } else {
                self.errorMessage = response.message ?? "Failed to update transaction"
            }
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    @MainActor
    func deleteTransaction(_ id: String) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let response: ApiResponse<[String: String]> = try await networkService.deleteTransaction(id)
            if response.status == "success" {
                self.transactions.removeAll { $0.id == id }
                self.errorMessage = nil
            } else {
                self.errorMessage = response.message ?? "Failed to delete transaction"
            }
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    @MainActor
    func clearError() {
        errorMessage = nil
    }
}
