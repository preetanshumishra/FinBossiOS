import SwiftUI

struct TransactionListView: View {
    @ObservedObject var viewModel: TransactionViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.isLoading {
                    ProgressView()
                } else if viewModel.transactions.isEmpty {
                    VStack {
                        Image(systemName: "list.dash")
                            .font(.system(size: 48))
                            .foregroundColor(.gray)
                        Text("No transactions yet")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .padding(.top, 12)
                    }
                } else {
                    List {
                        ForEach(viewModel.transactions) { transaction in
                            TransactionRow(transaction: transaction)
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        Task {
                                            await viewModel.deleteTransaction(transaction.id)
                                        }
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                        }
                    }
                    .listStyle(.plain)
                }

                if let errorMessage = viewModel.errorMessage {
                    VStack {
                        HStack {
                            Image(systemName: "exclamationmark.circle.fill")
                                .foregroundColor(.red)
                            Text(errorMessage)
                                .font(.caption)
                            Spacer()
                            Button(action: { viewModel.clearError() }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.red)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(Color(.systemRed).opacity(0.1))
                        .cornerRadius(8)
                        .padding()

                        Spacer()
                    }
                }
            }
            .navigationTitle("Transactions")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        Task {
                            await viewModel.loadTransactions()
                        }
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
            .task {
                await viewModel.loadTransactions()
            }
        }
    }
}

struct TransactionRow: View {
    let transaction: Transaction
    @State private var showAlert = false

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(transaction.category)
                        .font(.headline)
                        .fontWeight(.semibold)

                    if let description = transaction.description, !description.isEmpty {
                        Text(description)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }

                    Text(dateFormatter.string(from: transaction.date))
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                VStack(alignment: .trailing, spacing: 4) {
                    let amount = String(format: "$%.2f", transaction.amount)
                    let displayAmount = transaction.type == .income ? "+\(amount)" : "-\(amount)"

                    Text(displayAmount)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(transaction.type == .income ? .green : .red)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    TransactionListView(viewModel: DependencyContainer.shared.makeTransactionViewModel())
}
