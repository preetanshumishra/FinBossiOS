import SwiftUI

struct AnalyticsView: View {
    @ObservedObject var viewModel: AnalyticsViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.isLoading {
                    ProgressView()
                } else if viewModel.categoryBreakdown.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "chart.bar.xaxis")
                            .font(.system(size: 48))
                            .foregroundColor(.gray)
                        Text("No analytics data")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Text("Add transactions to see category breakdown")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(viewModel.categoryBreakdown) { item in
                                CategoryBreakdownRow(item: item)
                            }
                        }
                        .padding()
                    }
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
            .navigationTitle("Analytics")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        Task {
                            await viewModel.loadCategoryBreakdown()
                        }
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
            .task {
                await viewModel.loadCategoryBreakdown()
            }
        }
    }
}

private struct CategoryBreakdownRow: View {
    let item: CategoryBreakdown

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(item.category)
                    .font(.headline)
                Spacer()
                Text(String(format: "$%.2f", item.amount))
                    .font(.headline)
                    .fontWeight(.semibold)
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(.systemGray5))
                        .frame(height: 8)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.accentColor)
                        .frame(width: geometry.size.width * item.percentage / 100, height: 8)
                }
            }
            .frame(height: 8)

            HStack {
                Text(String(format: "%.1f%%", item.percentage))
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Text("\(item.transactionCount) transaction\(item.transactionCount == 1 ? "" : "s")")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

#Preview {
    AnalyticsView(viewModel: DependencyContainer.shared.makeAnalyticsViewModel())
}
