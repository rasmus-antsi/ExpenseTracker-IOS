import SwiftUI

struct AddTransactionView: View {
    @Environment(\.dismiss) var dismiss

    @State private var title: String = ""
    @State private var amountText: String = ""
    @State private var date: Date = Date()
    @State private var category: String = "Other"
    private let categories = ["Food", "Transport", "Shopping", "Entertainment", "Bills", "Health", "Other"]
    let isIncome: Bool
    
    @State private var showError = false
    @State private var errorMessage = ""
    
    private func triggerSuccessHaptic() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    private func triggerErrorHaptic() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
    
    var onAdd: (Transaction) -> Void
    
    private let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.maximumFractionDigits = 2
        return nf
    }()
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            // Big amount input
            TextField("0", text: $amountText)
                .font(.system(size: 80, weight: .bold, design: .monospaced))
                .foregroundStyle(isIncome ? .green : .red)
                .multilineTextAlignment(.center)
                .keyboardType(.decimalPad)
                .padding()
                .background(.white)
                .cornerRadius(10)
            
            // Title input
            TextField("Description", text: $title)
                .padding()
                .background(Color.gray.opacity(0.15))
                .cornerRadius(10)
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.words)
            
            // Category picker
            HStack {
                Spacer()
                
                Picker("Category", selection: $category) {
                    ForEach(categories, id: \.self) { cat in
                        Text(cat).tag(cat)
                            .foregroundStyle(Color.black)
                    }
                }
                .pickerStyle(.menu)
                .padding(10)
                .background(Color.gray.opacity(0.15))
                .cornerRadius(10)
            }
            
            Spacer()
            
            Button {
                guard let amount = Double(amountText.replacingOccurrences(of: ",", with: ".")),
                      !title.isEmpty, amount > 0 else {
                    errorMessage = "Please enter a valid amount and title."
                    showError = true
                    triggerErrorHaptic()
                    return
                }
                // If spending, check balance
                if !isIncome, let parent = UIApplication.shared.windows.first?.rootViewController as? UIHostingController<AnyView>, let transactionVM = parent.rootView as? TransactionViewModel, amount > transactionVM.balance {
                    errorMessage = "Not enough balance to spend."
                    showError = true
                    triggerErrorHaptic()
                    return
                }
                let newTransaction = Transaction(title: title, amount: amount, date: date, isIncome: isIncome, category: category)
                onAdd(newTransaction)
                triggerSuccessHaptic()
                dismiss()
            } label: {
                Text("\(isIncome ? "Add Income" : "Add Expense")")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isIncome ? Color.green : Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .shadow(color: isIncome ? Color.green.opacity(0.2) : Color.red.opacity(0.2), radius: 3, x: 0, y: 2)
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(title.isEmpty || Double(amountText.replacingOccurrences(of: ",", with: ".")) == nil || Double(amountText.replacingOccurrences(of: ",", with: "."))! <= 0)
            .alert(isPresented: $showError) {
                Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK"), action: { triggerErrorHaptic() }))
            }
        }
        .padding()
    }
}


#Preview {
    AddTransactionView(isIncome: true, onAdd: {transaaction in print("")})
}
