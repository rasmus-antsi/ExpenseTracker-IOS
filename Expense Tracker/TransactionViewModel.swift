//
//  TransactionViewModel.swift
//  Expense Tracker
//
//  Created by Rasmus Antsi on 15.07.2025.
//

import Foundation

class TransactionViewModel: ObservableObject {
    @Published var transactions: [Transaction] = [
        Transaction(title: "Work", amount: 60, isIncome: true),
        Transaction(title: "New Monitor Light", amount: 42.99, isIncome: false),
        Transaction(title: "Work", amount: 10, isIncome: true),
    ]
    
    var balance: Double {
        transactions.reduce(0) { $0 + ($1.isIncome ? $1.amount : -$1.amount) }
    }

    func addTransaction(_ transaction: Transaction) {
        transactions.append(transaction)
    }

    func deleteTransaction(_ transaction: Transaction) {
        transactions.removeAll { $0.id == transaction.id }
    }

    func updateTransaction(_ transaction: Transaction) {
        if let index = transactions.firstIndex(where: { $0.id == transaction.id }) {
            transactions[index] = transaction
        }
    }
}
