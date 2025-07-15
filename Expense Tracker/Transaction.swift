//
//  Transaction.swift
//  Expense Tracker
//
//  Created by Rasmus Antsi on 15.07.2025.
//

import Foundation

struct Transaction: Identifiable {
    var id: UUID
    var title: String
    var amount: Double
    let date: Date
    var isIncome: Bool
    
    init(id: UUID = UUID(), title: String, amount: Double, date: Date = Date(), isIncome: Bool) {
        self.id = id
        self.title = title
        self.amount = amount
        self.date = date
        self.isIncome = isIncome
    }
}
