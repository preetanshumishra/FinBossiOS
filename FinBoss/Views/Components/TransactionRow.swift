import SwiftUI

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
