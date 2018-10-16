import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(RationalNumberTests.allTests),
        testCase(UtilityTests.allTests),
    ]
}
#endif
