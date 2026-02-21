import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if let user = viewModel.user {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Welcome, \(user.firstName)!")
                            .font(.title2)
                            .fontWeight(.bold)

                        Text(user.email)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }

                VStack(spacing: 12) {
                    NavigationLink(destination: TransactionListView(viewModel: DependencyContainer.shared.makeTransactionViewModel())) {
                        HStack {
                            Image(systemName: "list.bullet")
                            Text("Transactions")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .foregroundColor(.primary)
                    }

                    NavigationLink(destination: Text("Budgets")) {
                        HStack {
                            Image(systemName: "creditcard")
                            Text("Budgets")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .foregroundColor(.primary)
                    }

                    NavigationLink(destination: AnalyticsView(viewModel: DependencyContainer.shared.makeAnalyticsViewModel())) {
                        HStack {
                            Image(systemName: "chart.pie")
                            Text("Analytics")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .foregroundColor(.primary)
                    }
                }

                Spacer()

                Button(action: {
                    viewModel.logout()
                }) {
                    Text("Logout")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()
            .navigationTitle("Home")
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

#Preview {
    let authService = DependencyContainer.shared.makeAuthService()
    let homeViewModel = DependencyContainer.shared.makeHomeViewModel(authService: authService)
    HomeView(viewModel: homeViewModel)
}
