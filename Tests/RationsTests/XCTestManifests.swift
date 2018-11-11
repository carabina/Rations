import XCTest

#if !os(iOS) && !os(macOS) && !os(tvOS) && !os(watchOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(RationalNumberTests.allTests),
        testCase(UtilityTests.allTests),
    ]
}
#endif
