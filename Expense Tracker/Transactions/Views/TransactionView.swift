//
//  ContentView.swift
//  Expense Tracker
//
//  Created by Rasmus Antsi on 15.07.2025.
//

import SwiftUI

enum ActiveSheet: Identifiable {
    case addTransaction(isIncome: Bool)
    
    var id: String {
        switch self {
        case .addTransaction(let isIncome):
            return "addTransaction_\(isIncome)"
        }
    }
}

struct TransactionView: View {
    @StateObject var viewModel: TransactionViewModel
    @State private var activeSheet: ActiveSheet? = nil
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    VStack {
                        Text("Current Balance")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(.gray.opacity(0.8))
                        
                        Text("\(viewModel.balance, specifier: "%.2f")€")
                            .font(.system(size: 50, weight: .bold, design: .monospaced))
                    }
                    .padding(.vertical, 40)
                    
                    HStack(spacing: 12) {
                        Button(action: {
                            activeSheet = .addTransaction(isIncome: false)
                        }) {
                            Label("Spend", systemImage: "minus")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical)
                                .background(Color.red)
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                .shadow(color: .red.opacity(0.2), radius: 3, x: 0, y: 2)
                        }
                        
                        Button(action: {
                            activeSheet = .addTransaction(isIncome: true)
                        }) {
                            Label("Earn", systemImage: "plus")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical)
                                .background(Color.green)
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                .shadow(color: .green.opacity(0.2), radius: 3, x: 0, y: 2)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                    
                    ScrollView {
                        ForEach(viewModel.transactions) { transaction in
                            NavigationLink(value: transaction) {
                                TransactionRowView(transaction: transaction)
                            }
                        }
                    }
                    .navigationDestination(for: Transaction.self) { transaction in
                        TransactionDetailsView(transaction: transaction) {
                            viewModel.deleteTransaction(transaction)
                        }
                    }
                    .padding()
                }
            }
        }
        .sheet(item: $activeSheet) { sheet in
            switch sheet {
            case .addTransaction(let isIncome):
                AddTransactionView(isIncome: isIncome) { newTransaction in
                    viewModel.addTransaction(newTransaction)
                    activeSheet = nil
                }
            }
        }
    }
}
