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
    init() {
        // Force light mode
        UIView.appearance().overrideUserInterfaceStyle = .light
    }
    var body: some Scene {
        WindowGroup {
            ContentViewWrapper()
        }
        .modelContainer(for: Transaction.self)
        .defaultAppStorage(UserDefaults.standard)
    }
}

// Add a launch screen for iOS 15+ using the new API
#if canImport(UIKit)
import UIKit

@available(iOS 15.0, *)
struct ExpenseTrackerLaunchScreen: View {
    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()
            VStack {
                Spacer()
                Text("Expense Tracker")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(Color.accentColor)
                Spacer()
            }
        }
    }
}
#endif

struct ContentViewWrapper: View {
    @Environment(\.modelContext) private var context
    
    var body: some View {
        let transactionViewModel = TransactionViewModel(context: context)
        let homeViewModel = HomeViewModel(transactionViewModel: transactionViewModel)
        MainTabView(transactionViewModel: transactionViewModel, homeViewModel: homeViewModel)
    }
}

struct MainTabView: View {
    @StateObject var transactionViewModel: TransactionViewModel
    @StateObject var homeViewModel: HomeViewModel
    @State private var showMoveSheet = false
    
    var body: some View {
        TabView {
            NavigationStack {
                HomeView(viewModel: homeViewModel)
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            
            NavigationStack {
                TransactionView(viewModel: transactionViewModel)
            }
            .tabItem {
                Image(systemName: "list.bullet")
                Text("Transactions")
            }
            
            NavigationStack {
                SavingsView(viewModel: homeViewModel, showMoveSheet: $showMoveSheet)
            }
            .tabItem {
                Image(systemName: "banknote")
                Text("Savings")
            }
            
            NavigationStack {
                SettingsView(viewModel: transactionViewModel)
            }
            .tabItem {
                Image(systemName: "gearshape")
                Text("Settings")
            }
        }
    }
}

struct SettingsView: View {
    @ObservedObject var viewModel: TransactionViewModel
    @State private var budgetText: String = ""
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
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            VStack(spacing: 16) {
                Text("Monthly Budget")
                    .font(.headline)
                    .foregroundColor(.gray)
                TextField("0", text: $budgetText)
                    .font(.system(size: 40, weight: .bold, design: .monospaced))
                    .multilineTextAlignment(.center)
                    .keyboardType(.decimalPad)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                    .shadow(radius: 1)
            }
            .padding()
            .background(Color.gray.opacity(0.08))
            .cornerRadius(16)
            .padding(.horizontal)
            
            Button {
                guard let newBudget = Double(budgetText.replacingOccurrences(of: ",", with: ".")), newBudget >= 0 else {
                    errorMessage = "Please enter a valid budget."
                    showError = true
                    triggerErrorHaptic()
                    return
                }
                viewModel.updateBudget(newBudget)
                triggerSuccessHaptic()
            } label: {
                Text("Save Budget")
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
            .disabled(Double(budgetText.replacingOccurrences(of: ",", with: ".")) == nil || Double(budgetText.replacingOccurrences(of: ",", with: "."))! < 0)
            .alert(isPresented: $showError) {
                Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK"), action: { triggerErrorHaptic() }))
            }
            Spacer()
        }
        .navigationTitle("Settings")
        .onAppear {
            budgetText = String(format: "%.2f", viewModel.budget)
        }
    }
}
