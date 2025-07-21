import SwiftUI

struct SavingsView: View {
    @ObservedObject var viewModel: HomeViewModel
    @Binding var showMoveSheet: Bool
    @State private var showRemoveSheet = false
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    Text("Current Savings")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.blue.opacity(0.8))
                    Text("\(viewModel.savings.amount, specifier: "%.2f")€")
                        .font(.system(size: 50, weight: .bold, design: .monospaced))
                }
                .padding(.vertical, 40)
                
                HStack(spacing: 12) {
                    Button(action: { showMoveSheet = true }) {
                        Label("Add", systemImage: "plus")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical)
                            .background(Color.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                            .shadow(color: Color.blue.opacity(0.2), radius: 3, x: 0, y: 2)
                    }
                    .buttonStyle(PlainButtonStyle())
                    Button(action: { showRemoveSheet = true }) {
                        Label("Remove", systemImage: "minus")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical)
                            .background(Color.red)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                            .shadow(color: Color.red.opacity(0.2), radius: 3, x: 0, y: 2)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                
                SavingsListView(viewModel: viewModel)
            }
            .sheet(isPresented: $showMoveSheet) {
                AddToSavingsSheet(viewModel: viewModel, isPresented: $showMoveSheet)
            }
            .sheet(isPresented: $showRemoveSheet) {
                RemoveFromSavingsSheet(viewModel: viewModel, isPresented: $showRemoveSheet)
            }
        }
    }
}

struct SavingsListView: View {
    @ObservedObject var viewModel: HomeViewModel
    var body: some View {
        ScrollView {
            ForEach(viewModel.savingsTransactions) { transaction in
                SavingsRowView(transaction: transaction)
            }
        }
        .padding()
    }
}

struct SavingsRowView: View {
    let transaction: Transaction
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.title)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(.black)
                Text(transaction.date, style: .date)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(.gray)
            }
            Spacer()
            Text("\(transaction.isIncome ? "-" : "+")\(transaction.amount, specifier: "%.2f")€")
                .font(.system(size: 20, weight: .regular, design: .monospaced))
                .foregroundStyle(transaction.isIncome ? .red : .green)
        }
        .padding(24)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

struct AddToSavingsSheet: View {
    @ObservedObject var viewModel: HomeViewModel
    @Binding var isPresented: Bool
    @State private var amountText: String = ""
    @State private var errorMessage: String = ""
    @State private var showError: Bool = false
    
    private func triggerSuccessHaptic() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    private func triggerErrorHaptic() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            Text("Add to Savings")
                .font(.title2)
                .bold()
            TextField("0", text: $amountText)
                .font(.system(size: 60, weight: .bold, design: .monospaced))
                .multilineTextAlignment(.center)
                .keyboardType(.decimalPad)
                .padding(.horizontal)
            Spacer()
            Button {
                guard let amount = Double(amountText.replacingOccurrences(of: ",", with: ".")), amount > 0 else {
                    errorMessage = "Please enter a valid amount."
                    showError = true
                    triggerErrorHaptic()
                    return
                }
                if amount > viewModel.transactionViewModel.balance {
                    errorMessage = "Not enough balance to move to savings."
                    showError = true
                    triggerErrorHaptic()
                    return
                }
                viewModel.moveToSavings(amount: amount)
                triggerSuccessHaptic()
                isPresented = false
            } label: {
                Text("Add to Savings")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .shadow(color: Color.blue.opacity(0.2), radius: 3, x: 0, y: 2)
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(Double(amountText.replacingOccurrences(of: ",", with: ".")) == nil || Double(amountText.replacingOccurrences(of: ",", with: "."))! <= 0)
            .alert(isPresented: $showError) {
                Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK"), action: { triggerErrorHaptic() }))
            }
            .padding(.bottom)
        }
    }
}

struct RemoveFromSavingsSheet: View {
    @ObservedObject var viewModel: HomeViewModel
    @Binding var isPresented: Bool
    @State private var amountText: String = ""
    @State private var errorMessage: String = ""
    @State private var showError: Bool = false
    
    private func triggerSuccessHaptic() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    private func triggerErrorHaptic() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            Text("Remove from Savings")
                .font(.title2)
                .bold()
            TextField("0", text: $amountText)
                .font(.system(size: 60, weight: .bold, design: .monospaced))
                .multilineTextAlignment(.center)
                .keyboardType(.decimalPad)
                .padding(.horizontal)
            Spacer()
            Button {
                guard let amount = Double(amountText.replacingOccurrences(of: ",", with: ".")), amount > 0 else {
                    errorMessage = "Please enter a valid amount."
                    showError = true
                    triggerErrorHaptic()
                    return
                }
                if amount > viewModel.savings.amount {
                    errorMessage = "Not enough savings to remove."
                    showError = true
                    triggerErrorHaptic()
                    return
                }
                viewModel.removeFromSavings(amount: amount)
                triggerSuccessHaptic()
                isPresented = false
            } label: {
                Text("Remove from Savings")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .shadow(color: Color.red.opacity(0.2), radius: 3, x: 0, y: 2)
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(Double(amountText.replacingOccurrences(of: ",", with: ".")) == nil || Double(amountText.replacingOccurrences(of: ",", with: "."))! <= 0)
            .alert(isPresented: $showError) {
                Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK"), action: { triggerErrorHaptic() }))
            }
            .padding(.bottom)
        }
    }
} 
