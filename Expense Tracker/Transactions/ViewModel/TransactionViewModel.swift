//
//  TransactionViewModel.swift
//  Expense Tracker
//
//  Created by Rasmus Antsi on 15.07.2025.
//

import Foundation
import SwiftData

@MainActor
class TransactionViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []
    
    private var context: ModelContext
    
    @Published var budget: Double {
        didSet {
            UserDefaults.standard.set(budget, forKey: "monthlyBudget")
        }
    }
    
    init(context: ModelContext) {
        self.context = context
        self.budget = UserDefaults.standard.double(forKey: "monthlyBudget")
        fetchTransactions()
    }
    
    var balance: Double {
        transactions.reduce(0) { $0 + ($1.isIncome ? $1.amount : -$1.amount) }
    }
    
    func fetchTransactions() {
            let descriptor = FetchDescriptor<Transaction>(sortBy: [SortDescriptor(\.date, order: .reverse)])
            do {
                transactions = try context.fetch(descriptor)
            } catch {
                print("❌ Fetch failed: \(error)")
            }
        }

    func addTransaction(_ transaction: Transaction) {
        context.insert(transaction)
        try? context.save()
        fetchTransactions()
    }

    func deleteTransaction(_ transaction: Transaction) {
        context.delete(transaction)
        try? context.save()
        fetchTransactions()
    }

    func updateBudget(_ newBudget: Double) {
        budget = newBudget
    }
}
