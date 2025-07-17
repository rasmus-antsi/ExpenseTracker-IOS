//
//  Expense_TrackerApp.swift
//  Expense Tracker
//
//  Created by Rasmus Antsi on 15.07.2025.
//

import SwiftUI
import SwiftData

@main
struct Expense_TrackerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentViewWrapper()
        }
        .modelContainer(for: Transaction.self)
    }
}

struct ContentViewWrapper: View {
    @Environment(\.modelContext) private var context

    var body: some View {
        let viewModel = TransactionViewModel(context: context)
        TransactionView(viewModel: viewModel)
    }
}
