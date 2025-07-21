# Expense Tracker

A modern, user-friendly iOS app for tracking expenses, income, and savings. Built with SwiftUI and SwiftData.

## Features

- **Home Dashboard:**
  - Monthly budget and progress bar
  - Analytics: earned, spent, and saved this month
  - Total savings

- **Transactions:**
  - Add, edit, and delete income and expenses
  - Categorize transactions
  - View transaction history with clean, card-style UI

- **Savings:**
  - Move money to and from savings
  - View savings history and current balance

- **Settings:**
  - Set and update your monthly budget
  - Light mode only for a clean, bright look

- **Polished UI:**
  - Haptic feedback for actions and errors
  - Native iOS look and feel
  - Launch screen with app name

## Setup & Running on Device

1. **Clone the repository** and open the project in Xcode.
2. **Connect your iPhone** and select it as the run target.
3. **Set a unique Bundle Identifier** in the project settings (e.g., `com.yourname.expensetracker`).
4. **Set your Team** (Apple ID) under Signing & Capabilities.
5. **Build and run** (Cmd+R). Approve any prompts on your Mac and iPhone.
6. **Trust the developer profile** on your iPhone (Settings > General > VPN & Device Management > Trust).

> **Note:** With a free Apple ID, the app will work for 7 days before needing to be re-signed from Xcode. With a paid developer account, it will work for 1 year.

## Customization
- **App Icon:** Add your own icon in `Assets.xcassets > AppIcon`.
- **Launch Screen:** The app displays "Expense Tracker" on launch. You can customize this in code.

## Tech Stack
- SwiftUI
- SwiftData
- MVVM architecture

## License
MIT 