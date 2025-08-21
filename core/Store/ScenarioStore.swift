import Foundation
import Combine

struct Scenario: Identifiable, Codable {
    var id = UUID()
    var name: String
    var createdAt: Date
}

final class ScenarioStore: ObservableObject {
    @Published var items: [Scenario] = []
}
