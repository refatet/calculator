import SwiftUI
import Charts

struct SummaryCard: View {
    let title: String
    let amount: Double
    let subtitle: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title).font(.headline)
            Text(amount, format: .number.precision(.fractionLength(2)))
                .font(.system(size: 28, weight: .bold))
            if let sub = subtitle {
                Text(sub).font(.subheadline).foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12))
    }
}

struct GrowthLineChart: View {
    let points: [YearPoint]
    var body: some View {
        Chart(points) { p in
            LineMark(x: .value("Year", p.year), y: .value("Value", p.value))
            PointMark(x: .value("Year", p.year), y: .value("Value", p.value))
        }
        .frame(height: 220)
    }
}
struct SplitDonutChart: View {
    struct Slice: Identifiable { let id = UUID(); let name: String; let value: Double }
    let totalContrib: Double
    let totalGrowth: Double

    var body: some View {
        let data = [
            Slice(name: NSLocalizedString("chart.contribution", comment: ""), value: totalContrib),
            Slice(name: NSLocalizedString("chart.growth", comment: ""), value: max(totalGrowth, 0))
        ]
        return Chart(data) { s in
            SectorMark(angle: .value("Value", s.value))
                .annotation(position: .overlay) {
                    Text(s.name).font(.caption)
                }
        }
        .frame(height: 220)
    }
}

struct ResultView: View {
    let summary: CalcSummary
    @State private var yearSeries: [YearPoint] = []

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Summary cards
                    SummaryCard(title: NSLocalizedString("results.final", comment: ""),
                                amount: summary.nominalFinal,
                                subtitle: nil)
                    HStack(spacing: 12) {
                        SummaryCard(title: NSLocalizedString("results.contrib", comment: ""),
                                    amount: summary.totalContrib,
                                    subtitle: NSLocalizedString("results.contrib.subtitle", comment: ""))
                        SummaryCard(title: NSLocalizedString("results.growth", comment: ""),
                                    amount: summary.totalGrowth,
                                    subtitle: NSLocalizedString("results.growth.subtitle", comment: ""))
                    }

                    // Line chart
                    VStack(alignment: .leading, spacing: 8) {
                        Text(NSLocalizedString("chart.growth_line.title", comment: "")).font(.headline)
                        GrowthLineChart(points: yearSeries)
                    }

                    // Donut chart
                    VStack(alignment: .leading, spacing: 8) {
                        Text(NSLocalizedString("chart.split_donut.title", comment: "")).font(.headline)
                        SplitDonutChart(totalContrib: summary.totalContrib, totalGrowth: summary.totalGrowth)
                    }
                }
                .padding(16)
            }
            .navigationTitle(NSLocalizedString("results.title", comment: ""))
            .onAppear {
                // Temporary linear series (Phase 3 will compute the real series)
                let years = 10
                var arr: [YearPoint] = []
                for y in 0...years {
                    let v = summary.nominalFinal * Double(y) / Double(years)
                    arr.append(YearPoint(year: y, value: v))
                }
                yearSeries = arr
            }
        }
    }
}
