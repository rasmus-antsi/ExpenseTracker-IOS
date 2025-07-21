import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        VStack(spacing: 24) {
            // Budget at top
            VStack(spacing: 8) {
                Text("Monthly Budget")
                    .font(.headline)
                    .foregroundColor(.gray)
                Text("\(viewModel.budget.amount, specifier: "%.2f")€")
                    .font(.system(size: 36, weight: .bold, design: .monospaced))
                ProgressView(value: min(viewModel.monthlySpent / max(viewModel.budget.amount, 1), 1)) {
                    Text("Spent: \(viewModel.monthlySpent, specifier: "%.2f")€")
                        .font(.subheadline)
                }
                .accentColor(viewModel.monthlySpent > viewModel.budget.amount ? .red : .green)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
            
            // Analytics
            HStack(spacing: 16) {
                StatBox(title: "Earned", value: viewModel.monthlyEarned, color: .green, systemImage: "arrow.down.circle")
                StatBox(title: "Spent", value: viewModel.monthlySpent, color: .red, systemImage: "arrow.up.circle")
                StatBox(title: "Saved", value: viewModel.savedThisMonth, color: .blue, systemImage: "banknote")
            }
            .frame(maxWidth: .infinity)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Home")
    }
}

struct StatBox: View {
    let title: String
    let value: Double
    let color: Color
    let systemImage: String
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: systemImage)
                .font(.title2)
                .foregroundColor(color)
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            Text("\(value, specifier: "%.2f")€")
                .font(.title3)
                .bold()
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .background(color.opacity(0.08))
        .cornerRadius(10)
    }
}

struct MoveToSavingsSheet: View {
    @ObservedObject var viewModel: HomeViewModel
    @Binding var isPresented: Bool
    @State private var amountText: String = ""
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            Text("Move to Savings")
                .font(.title2)
                .bold()
            TextField("0", text: $amountText)
                .font(.system(size: 60, weight: .bold, design: .monospaced))
                .multilineTextAlignment(.center)
                .keyboardType(.decimalPad)
                .padding(.horizontal)
            Spacer()
            Button {
                if let amount = Double(amountText.replacingOccurrences(of: ",", with: ".")), amount > 0 {
                    viewModel.moveToSavings(amount: amount)
                    isPresented = false
                }
            } label: {
                Text("Move to Savings")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .shadow(color: Color.blue.opacity(0.2), radius: 3, x: 0, y: 2)
            }
            .padding(.bottom)
        }
    }
} 
