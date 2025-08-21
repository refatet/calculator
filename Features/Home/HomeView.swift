import SwiftUI
struct HomeView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Calculators") {
                    Text(NSLocalizedString("calc.basic", comment: ""))
                    Text(NSLocalizedString("calc.real", comment: ""))
                    Text(NSLocalizedString("calc.deep", comment: ""))
                }
            }
            .navigationTitle(NSLocalizedString("tab.home", comment: ""))
        }
    }
}
