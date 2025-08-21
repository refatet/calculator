import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label(NSLocalizedString("tab.home", comment: ""), systemImage: "house") }
            CalculateView()
                .tabItem { Label(NSLocalizedString("tab.calculate", comment: ""), systemImage: "function") }
            ScenariosView()
                .tabItem { Label(NSLocalizedString("tab.scenarios", comment: ""), systemImage: "tray.full") }
            SettingsView()
                .tabItem { Label(NSLocalizedString("tab.settings", comment: ""), systemImage: "gearshape") }
        }
    }
}
