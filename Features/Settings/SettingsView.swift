import SwiftUI
struct SettingsView: View {
    var body: some View {
        NavigationStack {
            Form { Text("Settings placeholder") }
                .navigationTitle(NSLocalizedString("tab.settings", comment: ""))
        }
    }
}
