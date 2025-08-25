import Foundation

public enum Compounding: Int, CaseIterable { case yearly = 1, quarterly = 4, monthly = 12 }
public enum ContributionFreq: Int, CaseIterable { case yearly = 1, monthly = 12 }
public enum ContributionTiming: String, CaseIterable { case start, end } // 기/말

public struct BasicInput {
    public var principal: Double
    public var years: Int
    public var annualRatePct: Double
    public var compounding: Compounding
    public var applyInflation: Bool
    public var inflationPct: Double
    public var applyTax: Bool
    public var taxPct: Double

    public init(principal: Double, years: Int, annualRatePct: Double,
                compounding: Compounding,
                applyInflation: Bool = false, inflationPct: Double = 2,
                applyTax: Bool = false, taxPct: Double = 15) {
        self.principal = principal
        self.years = years
        self.annualRatePct = annualRatePct
        self.compounding = compounding
        self.applyInflation = applyInflation
        self.inflationPct = inflationPct
        self.applyTax = applyTax
        self.taxPct = taxPct
    }
}

public struct RealInput {
    public var principal: Double
    public var contribution: Double
    public var contribFreq: ContributionFreq
    public var timing: ContributionTiming
    public var years: Int
    public var annualRatePct: Double
    public var compounding: Compounding
    public var applyInflation: Bool
    public var inflationPct: Double
    public var applyTax: Bool
    public var taxPct: Double

    public init(principal: Double, contribution: Double,
                contribFreq: ContributionFreq, timing: ContributionTiming,
                years: Int, annualRatePct: Double, compounding: Compounding,
                applyInflation: Bool = false, inflationPct: Double = 2,
                applyTax: Bool = false, taxPct: Double = 15) {
        self.principal = principal
        self.contribution = contribution
        self.contribFreq = contribFreq
        self.timing = timing
        self.years = years
        self.annualRatePct = annualRatePct
        self.compounding = compounding
        self.applyInflation = applyInflation
        self.inflationPct = inflationPct
        self.applyTax = applyTax
        self.taxPct = taxPct
    }
}

public struct CalcSummary {
    public var nominalFinal: Double      // 명목 최종금액
    public var totalContrib: Double      // 총 납입액
    public var totalGrowth: Double       // 수익(이자)
    public var realFinal: Double?        // (옵션) 실질가 — Phase 4
}
public struct YearPoint: Identifiable {
    public let id = UUID()
    public let year: Int
    public let value: Double
}
