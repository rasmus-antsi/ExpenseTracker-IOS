import Foundation
import SwiftUI
import Combine

@MainActor
class HomeViewModel: ObservableObject {
    @Published var budget: Budget
    @Published var savings: Savings
    @Published var monthlySpent: Double = 0
    @Published var monthlyEarned: Double = 0
    @Published var savedThisMonth: Double = 0
    var transactionViewModel: TransactionViewModel
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(transactionViewModel: TransactionViewModel) {
        self.transactionViewModel = transactionViewModel
        self.budget = Budget(amount: transactionViewModel.budget)
        let saved = UserDefaults.standard.double(forKey: "savings")
        self.savings = Savings(amount: saved)
        computeMonthlyStats()
        // Listen for changes
        transactionViewModel.$transactions
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.computeMonthlyStats()
            }.store(in: &cancellables)
        transactionViewModel.$budget
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newBudget in
                self?.budget.amount = newBudget
            }.store(in: &cancellables)
    }
    
    func computeMonthlyStats() {
        let calendar = Calendar.current
        let now = Date()
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now)) ?? now
        let transactions = transactionViewModel.transactions.filter { $0.date >= startOfMonth }
        // Exclude 'Moved to Savings' from spent
        monthlySpent = transactions.filter { !$0.isIncome && $0.category != "Savings" }.reduce(0) { $0 + $1.amount }
        monthlyEarned = transactions.filter { $0.isIncome }.reduce(0) { $0 + $1.amount }
        savedThisMonth = transactions.filter { $0.category == "Savings" }.reduce(0) { $0 + $1.amount }
    }
    
    func moveToSavings(amount: Double) {
        guard amount > 0, amount <= transactionViewModel.balance else { return }
        savings.amount += amount
        UserDefaults.standard.set(savings.amount, forKey: "savings")
        // Add a transaction to reflect the transfer out
        let transfer = Transaction(title: "Moved to Savings", amount: amount, date: Date(), isIncome: false, category: "Savings")
        transactionViewModel.addTransaction(transfer)
    }
    
    var savingsTransactions: [Transaction] {
        transactionViewModel.transactions.filter { $0.category == "Savings" }
    }
    
    func removeFromSavings(amount: Double) {
        guard amount > 0, amount <= savings.amount else { return }
        savings.amount -= amount
        UserDefaults.standard.set(savings.amount, forKey: "savings")
        // Add a transaction to reflect the transfer in
        let transfer = Transaction(title: "Removed from Savings", amount: amount, date: Date(), isIncome: true, category: "Savings")
        transactionViewModel.addTransaction(transfer)
    }
} 