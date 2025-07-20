//
//  Transaction.swift
//  Expense Tracker
//
//  Created by Rasmus Antsi on 15.07.2025.
//

import Foundation
import SwiftData

@Model
class Transaction: Identifiable {
    var id: UUID
    var title: String
    var amount: Double
    var date: Date
    var isIncome: Bool
    var category: String
    
    init(id: UUID = UUID(), title: String, amount: Double, date: Date = Date(), isIncome: Bool, category: String = "Other") {
        self.id = id
        self.title = title
        self.amount = amount
        self.date = date
        self.isIncome = isIncome
        self.category = category
    }
}
