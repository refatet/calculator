import XCTest
@testable import calculator

final class CalculatorTests: XCTestCase {

    func test_basic_zeroRate() {
        let input = BasicInput(principal: 1000, years: 10, annualRatePct: 0, compounding: .monthly)
        let s = Calculator.computeBasic(input)
        XCTAssertEqual(s.nominalFinal, 1000, accuracy: 1e-6)
    }

    func test_real_zeroRate_monthly_end() {
        let i = RealInput(principal: 0, contribution: 100, contribFreq: .monthly, timing: .end,
                          years: 1, annualRatePct: 0, compounding: .monthly)
        let s = Calculator.computeReal(i)
        XCTAssertEqual(s.nominalFinal, 1200, accuracy: 1e-6) // 100 * 12
    }

    func test_real_start_is_greater_than_end_when_rate_positive() {
        let end = RealInput(principal: 0, contribution: 100, contribFreq: .monthly, timing: .end,
                            years: 1, annualRatePct: 12, compounding: .monthly)
        let start = RealInput(principal: 0, contribution: 100, contribFreq: .monthly, timing: .start,
                              years: 1, annualRatePct: 12, compounding: .monthly)
        let s1 = Calculator.computeReal(end)
        let s2 = Calculator.computeReal(start)
        XCTAssertTrue(s2.nominalFinal > s1.nominalFinal)
    }
}
