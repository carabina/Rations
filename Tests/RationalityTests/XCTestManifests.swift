import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(RationalTests.allTests),
        testCase(UtilityTests.allTests),
    ]
}
#endif
