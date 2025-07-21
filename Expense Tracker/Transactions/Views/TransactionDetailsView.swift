//
//  TransactionDetails.swift
//  Expense Tracker
//
//  Created by Rasmus Antsi on 17.07.2025.
//

import SwiftUI

struct TransactionDetailsView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var transaction: Transaction
    var onDelete: (() -> Void)? = nil
    
    var body: some View {
        VStack(spacing: 20) {
            Picker("", selection: $transaction.isIncome) {
                Text("Income").tag(true)
                Text("Expense").tag(false)
            }
            .pickerStyle(.segmented)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            
            TextField("0", value: $transaction.amount, format: .number)
                .font(.system(size: 80, weight: .bold, design: .monospaced))
                .foregroundColor(transaction.isIncome ? .green : .red)
                .multilineTextAlignment(.center)
                .keyboardType(.decimalPad)
                .padding(.vertical, 60)
            
            TextField("Title", text: $transaction.title)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.words)
            
            HStack{
                Picker("Category", selection: $transaction.category) {
                    ForEach(["Food", "Transport", "Shopping", "Entertainment", "Bills", "Health", "Other"], id: \.self) { cat in
                        Text(cat).tag(cat)
                            .foregroundStyle(Color.black)
                    }
                }
                .pickerStyle(.menu)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                
                Spacer()
                
                DatePicker("", selection: $transaction.date, displayedComponents: .date)
                    .labelsHidden()
                    .datePickerStyle(.compact)
            }
            
            Spacer()
            
        }
        .padding()
        .onDisappear {
            try? transaction.modelContext?.save()
        }
        
        Button {
            onDelete?()
            dismiss()
        } label: {
            Text("Delete")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(12)
                .padding(.horizontal)
                .padding(.vertical, 24)
                .shadow(color: .red.opacity(0.2), radius: 3, x: 0, y: 2)
        }
    }
}

#Preview {
    TransactionDetailsView(transaction: Transaction(title: "Work", amount: 200, isIncome: true))
}
