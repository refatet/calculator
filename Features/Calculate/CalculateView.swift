import SwiftUI

// Temporary local mode enum to avoid conflicts with any existing CalcMode
private enum _CalcMode: String, CaseIterable, Identifiable {
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
    @State private var mode: _CalcMode = .basic
    var body: some View {
        NavigationStack {
            VStack {
                Picker("", selection: $mode) {
                    ForEach(_CalcMode.allCases) { m in Text(m.title).tag(m) }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

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

struct DeepForm: View {
    var body: some View {
        Form {
            Section {
                Text("Deep (PRO) inputs…")
            } header: {
                Text(NSLocalizedString("inputs.title", comment: ""))
            }
        }
    }
}

// ... CalcMode 등은 기존 그대로 사용

struct BasicForm: View {
    @State private var principal = "10000"
    @State private var years = "10"
    @State private var rate = "5"
    @State private var compIndex = 0

    @State private var showResult = false
    @State private var summary: CalcSummary?

    let compOptions: [Compounding] = [.yearly, .quarterly, .monthly]

    var body: some View {
        Form {
            Section {
                TextField("Start Amount", text: $principal).keyboardType(.decimalPad)
                TextField("Years", text: $years).keyboardType(.numberPad)
                TextField("Annual Rate (%)", text: $rate).keyboardType(.decimalPad)
                Picker("Compounding", selection: $compIndex) {
                    ForEach(compOptions.indices, id: \.self) { i in
                        Text("\(compOptions[i].rawValue)x/year").tag(i)
                    }
                }
            } header: {
                Text(NSLocalizedString("inputs.title", comment: ""))
            }
            Button(NSLocalizedString("view.results", comment: "")) {
                let input = BasicInput(
                    principal: Double(principal) ?? 0,
                    years: Int(years) ?? 0,
                    annualRatePct: Double(rate) ?? 0,
                    compounding: compOptions[compIndex]
                )
                summary = Calculator.computeBasic(input)
                showResult = true
            }
        }
        .sheet(isPresented: $showResult) {
            if let s = summary { ResultView(summary: s) }
        }
    }
}

struct RealForm: View {
    @State private var principal = "0"
    @State private var contribution = "100"
    @State private var years = "10"
    @State private var rate = "5"
    @State private var compIndex = 2 // monthly
    @State private var freqIndex = 0 // yearly first
    @State private var timingIndex = 1 // end

    @State private var showResult = false
    @State private var summary: CalcSummary?

    let compOptions: [Compounding] = [.yearly, .quarterly, .monthly]
    let freqOptions: [ContributionFreq] = [.yearly, .monthly]
    let timingOptions: [ContributionTiming] = [.start, .end]

    var body: some View {
        Form {
            Section {
                TextField("Start Amount", text: $principal).keyboardType(.decimalPad)
                TextField("Contribution", text: $contribution).keyboardType(.decimalPad)
                Picker("Contribution Freq", selection: $freqIndex) {
                    ForEach(freqOptions.indices, id: \.self) { i in
                        Text(freqOptions[i] == .monthly ? "Monthly" : "Yearly").tag(i)
                    }
                }
                Picker("Timing", selection: $timingIndex) {
                    ForEach(timingOptions.indices, id: \.self) { i in
                        Text(timingOptions[i] == .start ? "Start (Due)" : "End (Ordinary)").tag(i)
                    }
                }
                TextField("Years", text: $years).keyboardType(.numberPad)
                TextField("Annual Rate (%)", text: $rate).keyboardType(.decimalPad)
                Picker("Compounding", selection: $compIndex) {
                    ForEach(compOptions.indices, id: \.self) { i in
                        Text("\(compOptions[i].rawValue)x/year").tag(i)
                    }
                }
            } header: {
                Text(NSLocalizedString("inputs.title", comment: ""))
            }
            Button(NSLocalizedString("view.results", comment: "")) {
                let input = RealInput(
                    principal: Double(principal) ?? 0,
                    contribution: Double(contribution) ?? 0,
                    contribFreq: freqOptions[freqIndex],
                    timing: timingOptions[timingIndex],
                    years: Int(years) ?? 0,
                    annualRatePct: Double(rate) ?? 0,
                    compounding: compOptions[compIndex]
                )
                summary = Calculator.computeReal(input)
                showResult = true
            }
        }
        .sheet(isPresented: $showResult) {
            if let s = summary { ResultView(summary: s) }
        }
    }
}

