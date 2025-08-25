import Foundation

enum Calculator {
    /// 기본: 초기 원금만 복리
    static func computeBasic(_ input: BasicInput) -> CalcSummary {
        let m = Double(input.compounding.rawValue)
        let r = (input.annualRatePct / 100.0) / m
        let n = Double(input.years) * m

        let fv = input.principal * pow(1 + r, n)
        let contrib = 0.0
        let growth = fv - input.principal

        return CalcSummary(nominalFinal: fv, totalContrib: contrib, totalGrowth: growth, realFinal: nil)
    }

    /// 현실: 초기 원금 + 정기 납입(월/연), 말기/기 선택
    static func computeReal(_ input: RealInput) -> CalcSummary {
        let m_principal = Double(input.compounding.rawValue)              // 원금 복리 주기
        let r_principal = (input.annualRatePct / 100.0) / m_principal
        let n_principal = Double(input.years) * m_principal

        let m_c = Double(input.contribFreq.rawValue)                      // 납입 주기
        let r_c = (input.annualRatePct / 100.0) / m_c
        let n_c = Double(input.years) * m_c

        // 방어: 이율 0%일 때 분모 0 회피
        let fvPrincipal = input.principal * pow(1 + r_principal, n_principal)
        let fvContrib: Double = {
            guard r_c != 0 else {
                // 이율 0이면 단순 합
                let fv0 = input.contribution * n_c
                return input.timing == .start ? fv0 : fv0
            }
            var factor = (pow(1 + r_c, n_c) - 1) / r_c
            if input.timing == .start { factor *= (1 + r_c) }             // 선납(기)
            return input.contribution * factor
        }()

        let fv = fvPrincipal + fvContrib
        let contribTotal = input.contribution * n_c
        let growth = fv - (input.principal + contribTotal)

        return CalcSummary(nominalFinal: fv, totalContrib: contribTotal, totalGrowth: growth, realFinal: nil)
    }
}
private extension Calculator {
    static func makeYearSeries(start: Double, years: Int, annualRatePct: Double) -> [YearPoint] {
        var arr: [YearPoint] = []
        var v = start
        for y in 0...years {
            arr.append(YearPoint(year: y, value: v))
            v *= (1.0 + annualRatePct/100.0) // 단순 연복리 근사(Phase 3에서 교체)
        }
        return arr
    }
}
