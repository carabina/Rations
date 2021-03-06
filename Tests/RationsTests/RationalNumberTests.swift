//
//  RationalNumberTests.swift
//  RationsTests
//
//  Created by Erik Strottmann on 6/9/18.
//  Copyright © 2018 Erik Strottmann. All rights reserved.
//

import XCTest
import Rations

final class RationalNumberTests: XCTestCase {
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

        let integer = Rational(8)
        XCTAssertEqual(integer.numerator, 8)
        XCTAssertEqual(integer.denominator, 1)
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

    func testLessThan() {
        // Same denominator
        XCTAssertLessThan(Rational(1, 3), Rational(2, 3))

        // Different denominator
        XCTAssertLessThan(Rational(3, 4), Rational(4, 5))

        // Different sign
        XCTAssertLessThan(Rational(-9, 10), Rational(1, 10))

        // Zero
        XCTAssertLessThan(Rational(0, 1), Rational(1, 100))
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

    func testInitExactlyBinaryInteger() {
        let smallerSourceSuccess = RationalNumber<Int64>(exactly: 2 as Int8)
        XCTAssertNotNil(smallerSourceSuccess)
        XCTAssertEqual(smallerSourceSuccess?.numerator, 2 as Int64)
        XCTAssertEqual(smallerSourceSuccess?.denominator, 1)

        let largerSourceSuccess = RationalNumber<Int8>(exactly: 4 as Int64)
        XCTAssertNotNil(largerSourceSuccess)
        XCTAssertEqual(largerSourceSuccess?.numerator, 4)
        XCTAssertEqual(largerSourceSuccess?.denominator, 1)

        let largerSourceFailure = RationalNumber<Int8>(exactly: 128 as Int64)
        XCTAssertNil(largerSourceFailure)

        let signedSourceSuccess = RationalNumber<UInt8>(exactly: 6 as Int8)
        XCTAssertNotNil(signedSourceSuccess)
        XCTAssertEqual(signedSourceSuccess?.numerator, 6 as UInt8)
        XCTAssertEqual(signedSourceSuccess?.denominator, 1)

        let signedSourceFailure = RationalNumber<UInt8>(exactly: -8 as Int8)
        XCTAssertNil(signedSourceFailure)

        let signedMaximumSuccess = RationalNumber<Int8>(exactly: Int8.max)
        XCTAssertNotNil(signedMaximumSuccess)
        XCTAssertEqual(signedMaximumSuccess?.numerator, 127)
        XCTAssertEqual(signedMaximumSuccess?.denominator, 1)

        let signedMinimumFailure = RationalNumber<Int8>(exactly: Int8.min)
        XCTAssertNil(signedMinimumFailure)

        let unsignedMaximumSuccess = RationalNumber<UInt8>(exactly: UInt8.max)
        XCTAssertNotNil(unsignedMaximumSuccess)
        XCTAssertEqual(unsignedMaximumSuccess?.numerator, 255)
        XCTAssertEqual(unsignedMaximumSuccess?.denominator, 1)

        let unsignedMinimumSuccess = RationalNumber<Int8>(exactly: UInt8.min)
        XCTAssertNotNil(unsignedMinimumSuccess)
        XCTAssertEqual(unsignedMinimumSuccess?.numerator, 0)
        XCTAssertEqual(unsignedMinimumSuccess?.denominator, 1)
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

    func testMultiplication() {
        let irreducible = Rational(1, 4) * Rational(5, 3)
        XCTAssertEqual(irreducible.numerator, 5)
        XCTAssertEqual(irreducible.denominator, 12)

        let reducible = Rational(-5, 8) * Rational(8, 1)
        XCTAssertEqual(reducible.numerator, -5)
        XCTAssertEqual(reducible.denominator, 1)

        let zero = Rational(1, 3) * Rational(0, 1)
        XCTAssertEqual(zero.numerator, 0)
        XCTAssertEqual(zero.denominator, 1)
    }

    func testMultiplicationDoesNotOverflowEarly() {
        let result = Rational(1, Int.max) * Rational(Int.max, 2)
        XCTAssertEqual(result.numerator, 1)
        XCTAssertEqual(result.denominator, 2)
    }

    func testDivision() {
        let irreducible = Rational(1, 4) / Rational(2, 3)
        XCTAssertEqual(irreducible.numerator, 3)
        XCTAssertEqual(irreducible.denominator, 8)

        let reducible = Rational(-5, 8) / Rational(1, 8)
        XCTAssertEqual(reducible.numerator, -5)
        XCTAssertEqual(reducible.denominator, 1)

        let zero = Rational(0, 3) / Rational(1, 3)
        XCTAssertEqual(zero.numerator, 0)
        XCTAssertEqual(zero.denominator, 1)
    }

    func testDivisionDoesNotOverflowEarly() {
        let result = Rational(1, Int.max) / Rational(2, Int.max)
        XCTAssertEqual(result.numerator, 1)
        XCTAssertEqual(result.denominator, 2)
    }

    func testNegation() {
        let positive = -Rational(13, 7)
        XCTAssertEqual(positive.numerator, -13)
        XCTAssertEqual(positive.denominator, 7)

        let negative = -Rational(-4, 9)
        XCTAssertEqual(negative.numerator, 4)
        XCTAssertEqual(negative.denominator, 9)

        let zero = -Rational(0, 11)
        XCTAssertEqual(zero.numerator, 0)
        XCTAssertEqual(zero.denominator, 1)
    }

    func testDescription() {
        let positive = Rational(303, 33)
        XCTAssertEqual(positive.description, "101/11")

        let negative = Rational(-1009, 10_007)
        XCTAssertEqual(negative.description, "-1009/10007")

        let zero = Rational(0, 2)
        XCTAssertEqual(zero.description, "0/1")
    }

    func testMax() {
        let signed = RationalNumber<Int8>.max
        XCTAssertEqual(signed.numerator, Int8.max)
        XCTAssertEqual(signed.denominator, 1)

        let unsigned = RationalNumber<UInt16>.max
        XCTAssertEqual(unsigned.numerator, UInt16.max)
        XCTAssertEqual(unsigned.denominator, 1)
    }

    func testMin() {
        let signed = RationalNumber<Int8>.min
        XCTAssertEqual(signed.numerator, -Int8.max)
        XCTAssertEqual(signed.denominator, 1)

        let unsigned = RationalNumber<UInt16>.min
        XCTAssertEqual(unsigned.numerator, 0)
        XCTAssertEqual(unsigned.denominator, 1)
    }

    func testLeastNonzeroMagnitude() {
        let signed = RationalNumber<Int8>.leastNonzeroMagnitude
        XCTAssertEqual(signed.numerator, 1)
        XCTAssertEqual(signed.denominator, Int8.max)

        let unsigned = RationalNumber<UInt16>.leastNonzeroMagnitude
        XCTAssertEqual(unsigned.numerator, 1)
        XCTAssertEqual(unsigned.denominator, UInt16.max)
    }

    func testIsSigned() {
        XCTAssertTrue(RationalNumber<Int8>.isSigned)
        XCTAssertFalse(RationalNumber<UInt16>.isSigned)
    }

    func testSignum() {
        let signedPositive = RationalNumber<Int8>(4, 2)
        XCTAssertEqual(signedPositive.signum(), 1)

        let signedNegative = RationalNumber<Int16>(-1, 6)
        XCTAssertEqual(signedNegative.signum(), -1)

        let signedZero = RationalNumber<Int32>(0, 5)
        XCTAssertEqual(signedZero.signum(), 0)

        let unsignedPositive = RationalNumber<UInt64>(3, 7)
        XCTAssertEqual(unsignedPositive.signum(), 1)

        let unsignedZero = RationalNumber<UInt8>(0, 255)
        XCTAssertEqual(unsignedZero.signum(), 0)
    }

    func testIntegerValue() {
        let integer: Rational = 5
        XCTAssertEqual(integer.integerValue, 5)

        let fraction: Rational = -3 / 2
        XCTAssertNil(fraction.integerValue)
    }

    func testIntegerApproximation() {
        let integer: Rational = 5
        XCTAssertEqual(integer.integerApproximation, 5)

        let fraction: Rational = -3 / 2
        XCTAssertEqual(fraction.integerApproximation, -1)
    }

    func testDoubleApproximation() {
        let integer: Rational = 5
        XCTAssertEqual(integer.doubleApproximation, 5)

        let fraction: Rational = -3 / 2
        XCTAssertEqual(fraction.doubleApproximation, -1.5)
    }

    static var allTests = [
        ("testInitReducesFractions", testInitReducesFractions),
        ("testInitNormalizesNegatives", testInitNormalizesNegatives),
        ("testInitOfSignedAndUnsignedNumbers", testInitOfSignedAndUnsignedNumbers),
        ("testLessThan", testLessThan),
        ("testInitWithIntegerLiteral", testInitWithIntegerLiteral),
        ("testInitExactlyBinaryInteger", testInitExactlyBinaryInteger),
        ("testMagnitude", testMagnitude),
        ("testRationalNumberAbsoluteValue", testRationalNumberAbsoluteValue),
        ("testAddition", testAddition),
        ("testSubtraction", testSubtraction),
        ("testMultiplication", testMultiplication),
        ("testMultiplicationDoesNotOverflowEarly", testMultiplicationDoesNotOverflowEarly),
        ("testDivision", testDivision),
        ("testDivisionDoesNotOverflowEarly", testDivisionDoesNotOverflowEarly),
        ("testNegation", testNegation),
        ("testDescription", testDescription),
        ("testMax", testMax),
        ("testMin", testMin),
        ("testLeastNonzeroMagnitude", testLeastNonzeroMagnitude),
        ("testIsSigned", testIsSigned),
        ("testSignum", testSignum),
        ("testIntegerValue", testIntegerValue),
        ("testIntegerApproximation", testIntegerApproximation),
        ("testDoubleApproximation", testDoubleApproximation),
    ]
}
