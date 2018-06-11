//
//  RationalTests.swift
//  RationalityTests
//
//  Created by Erik Strottmann on 6/9/18.
//  Copyright © 2018 Erik Strottmann. All rights reserved.
//

import XCTest
import Rationality

final class RationalTests: XCTestCase {
    func testInitReducesFractions() {
        let irreducible = Rational(1, 2)
        XCTAssertEqual(irreducible.numerator, 1)
        XCTAssertEqual(irreducible.denominator, 2)

        let reducible = Rational(4, 6)
        XCTAssertEqual(reducible.numerator, 2)
        XCTAssertEqual(reducible.denominator, 3)

        let improper = Rational(9, 6)
        XCTAssertEqual(improper.numerator, 3)
        XCTAssertEqual(improper.denominator, 2)

        let zero = Rational(0, 100)
        XCTAssertEqual(zero.numerator, 0)
        XCTAssertEqual(zero.denominator, 1)
    }

    func testInitNormalizesNegatives() {
        let negativeNumerator = Rational(-4, 5)
        XCTAssertEqual(negativeNumerator.numerator, -4)
        XCTAssertEqual(negativeNumerator.denominator, 5)

        let negativeDenominator = Rational(100, -1)
        XCTAssertEqual(negativeDenominator.numerator, -100)
        XCTAssertEqual(negativeDenominator.denominator, 1)

        let doubleNegative = Rational(-2, -10)
        XCTAssertEqual(doubleNegative.numerator, 1)
        XCTAssertEqual(doubleNegative.denominator, 5)
    }

    func testInitOfSignedAndUnsignedNumbers() {
        let signed = RationalNumber<Int64>(9, 18)
        XCTAssertEqual(signed.numerator, 1)
        XCTAssertEqual(signed.denominator, 2)

        let unsigned = RationalNumber<UInt64>(20, 10)
        XCTAssertEqual(unsigned.numerator, 2)
        XCTAssertEqual(unsigned.denominator, 1)
    }

    func testInitWithIntegerLiteral() {
        let positive: Rational = 440
        XCTAssertEqual(positive.numerator, 440)
        XCTAssertEqual(positive.denominator, 1)

        let negative: Rational = -20
        XCTAssertEqual(negative.numerator, -20)
        XCTAssertEqual(negative.denominator, 1)

        let zero: Rational = 0
        XCTAssertEqual(zero.numerator, 0)
        XCTAssertEqual(zero.denominator, 1)

        let unsigned: RationalNumber<UInt> = 180
        XCTAssertEqual(unsigned.numerator, 180)
        XCTAssertEqual(unsigned.denominator, 1)
    }

    func testMagnitude() {
        let signed = RationalNumber<Int>(-1, 2)
        let signedMagnitude: RationalNumber<UInt> = signed.magnitude
        XCTAssertEqual(signedMagnitude.numerator, 1)
        XCTAssertEqual(signedMagnitude.denominator, 2)

        let unsigned = RationalNumber<UInt>(3, 4)
        let unsignedMagnitude: RationalNumber<UInt> = unsigned.magnitude
        XCTAssertEqual(unsignedMagnitude.numerator, 3)
        XCTAssertEqual(unsignedMagnitude.denominator, 4)
        XCTAssertEqual(unsigned, unsignedMagnitude)
    }

    func testRationalNumberAbsoluteValue() {
        let signed = RationalNumber<Int>(-1, 2)
        let signedAbsoluteValue: RationalNumber<Int> = abs(signed)
        XCTAssertEqual(signedAbsoluteValue.numerator, 1)
        XCTAssertEqual(signedAbsoluteValue.denominator, 2)
        XCTAssertNotEqual(signed, signedAbsoluteValue)

        let unsigned = RationalNumber<UInt>(3, 4)
        let unsignedAbsoluteValue: RationalNumber<UInt> = abs(unsigned)
        XCTAssertEqual(unsignedAbsoluteValue.numerator, 3)
        XCTAssertEqual(unsignedAbsoluteValue.denominator, 4)
        XCTAssertEqual(unsigned, unsignedAbsoluteValue)
    }

    func testAddition() {
        let irreducible = Rational(1, 4) + Rational(2, 3)
        XCTAssertEqual(irreducible.numerator, 11)
        XCTAssertEqual(irreducible.denominator, 12)

        let reducible = Rational(-5, 8) + Rational(1, 8)
        XCTAssertEqual(reducible.numerator, -1)
        XCTAssertEqual(reducible.denominator, 2)

        let zero = Rational(1, 3) + Rational(-1, 3)
        XCTAssertEqual(zero.numerator, 0)
        XCTAssertEqual(zero.denominator, 1)
    }

    func testSubtraction() {
        let irreducible = Rational(1, 4) - Rational(2, 3)
        XCTAssertEqual(irreducible.numerator, -5)
        XCTAssertEqual(irreducible.denominator, 12)

        let reducible = Rational(-5, 8) - Rational(1, 8)
        XCTAssertEqual(reducible.numerator, -3)
        XCTAssertEqual(reducible.denominator, 4)

        let zero = Rational(1, 3) - Rational(1, 3)
        XCTAssertEqual(zero.numerator, 0)
        XCTAssertEqual(zero.denominator, 1)
    }

    static var allTests = [
        ("testInitReducesFractions", testInitReducesFractions),
        ("testInitNormalizesNegatives", testInitNormalizesNegatives),
        ("testInitWithIntegerLiteral", testInitWithIntegerLiteral),
        ("testMagnitude", testMagnitude),
        ("testRationalNumberAbsoluteValue", testRationalNumberAbsoluteValue),
        ("testAddition", testAddition),
        ("testSubtraction", testSubtraction),
    ]
}
