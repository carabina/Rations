//
//  UtilityTests.swift
//  RationalityTests
//
//  Created by Erik Strottmann on 6/9/18.
//  Copyright © 2018 Erik Strottmann. All rights reserved.
//

import XCTest
@testable import Rationality

final class UtilityTests: XCTestCase {
    func testBinaryIntegerAbsoluteValue() {
        XCTAssertEqual(abs(8 as Int8), 8)
        XCTAssertEqual(abs(-16 as Int16), 16)
        XCTAssertEqual(abs(32 as UInt32), 32)
        XCTAssertEqual(abs(0 as UInt64), 0)
        XCTAssertEqual(abs(Int.max), Int.max)
    }

    func testGCDIsAlwaysPositive() {
        XCTAssertEqual(gcd(6, 9), 3)
        XCTAssertEqual(gcd(4, -12), 4)
        XCTAssertEqual(gcd(-4, 12), 4)
        XCTAssertEqual(gcd(-2, -2), 2)
    }

    func testGCDWithNoCommonDivisors() {
        XCTAssertEqual(gcd(5, 7), 1)
        XCTAssertEqual(gcd(8, 9), 1)
    }

    func testGCDOfZero() {
        XCTAssertEqual(gcd(2, 0), 2)
        XCTAssertEqual(gcd(0, 3), 3)
    }

    func testGCDOfSignedAndUnsignedNumbers() {
        XCTAssertEqual(gcd(9 as Int64, 18 as Int64), 9)
        XCTAssertEqual(gcd(20 as UInt64, 10 as UInt64), 10)
    }

    static var allTests = [
        ("testBinaryIntegerAbsoluteValue", testBinaryIntegerAbsoluteValue),
        ("testGCDIsAlwaysPositive", testGCDIsAlwaysPositive),
        ("testGCDWithNoCommonDivisors", testGCDWithNoCommonDivisors),
        ("testGCDOfZero", testGCDOfZero),
        ("testGCDOfSignedAndUnsignedNumbers", testGCDOfSignedAndUnsignedNumbers),
    ]
}
