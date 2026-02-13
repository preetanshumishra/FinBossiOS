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

#Preview {
    TransactionListView(viewModel: DependencyContainer.shared.makeTransactionViewModel())
}
