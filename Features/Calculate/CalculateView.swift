import SwiftUI

enum CalcMode: String, CaseIterable, Identifiable {
    case basic, real, deep
    var id: String { rawValue }
    var title: String {
        switch self {
        case .basic: return NSLocalizedString("calc.basic", comment: "")
        case .real:  return NSLocalizedString("calc.real", comment: "")
        case .deep:  return NSLocalizedString("calc.deep", comment: "")
        }
    }
}

struct CalculateView: View {
    @State private var mode: CalcMode = .basic
    var body: some View {
        NavigationStack {
            VStack {
                Picker("", selection: $mode) {
                    ForEach(CalcMode.allCases) { Text($0.title).tag($0) }
                }
                .pickerStyle(.segmented)
                .padding()

                switch mode {
                case .basic: BasicForm()
                case .real:  RealForm()
                case .deep:  DeepForm()
                }
            }
            .navigationTitle(NSLocalizedString("tab.calculate", comment: ""))
        }
    }
}

struct BasicForm: View { var body: some View { Form { Text("Basic inputs…") } } }
struct RealForm:  View { var body: some View { Form { Text("Real-world inputs…") } } }
struct DeepForm:  View { var body: some View { Form { Text("Deep (PRO) inputs…") } } }
