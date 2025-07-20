//
//  TransactionRowView.swift
//  Expense Tracker
//
//  Created by Rasmus Antsi on 15.07.2025.
//

import SwiftUI

struct TransactionRowView: View {
    let transaction: Transaction
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.title)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(.black)
                
                Text(transaction.category)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(.gray)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(4)
            }
            
            Spacer()
            
            Text("\(transaction.isIncome ? "+" : "-")\(transaction.amount, specifier: "%.2f")€")
                .font(.system(size: 20, weight: .regular, design: .monospaced))
                .foregroundStyle(transaction.isIncome ? .green : .red)
        }
        .padding(24)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

#Preview {
    TransactionRowView(transaction: Transaction(title: "Work", amount: 120, isIncome: true))
}
