//
//  Rational.swift
//  Rationality
//
//  Created by Erik Strottmann on 6/9/18.
//  Copyright © 2018 Erik Strottmann. All rights reserved.
//

public struct RationalNumber<IntegerBase: BinaryInteger>: Hashable {
    public private(set) var numerator: IntegerBase
    public private(set) var denominator: IntegerBase

    public init(_ numerator: IntegerBase, _ denominator: IntegerBase) {
        precondition(denominator != 0, "Unable to initialize a RationalNumber with zero denominator.")

        let gcd = Rationality.gcd(numerator, denominator)
        let invertNumerator: IntegerBase = denominator < 0 ? -1 : 1

        self.numerator = invertNumerator * (numerator / gcd)
        self.denominator = abs(denominator / gcd)
    }
}

public typealias Rational = RationalNumber<Int>

extension RationalNumber: Comparable {
    public static func < (lhs: RationalNumber<IntegerBase>, rhs: RationalNumber<IntegerBase>) -> Bool {
        let (lhsNumerator, rhsNumerator, _) = lcd(lhs, rhs)
        return lhsNumerator < rhsNumerator
    }
}

extension RationalNumber: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: IntegerBase.IntegerLiteralType) {
        self.init(IntegerBase.init(integerLiteral: value), 1)
    }
}

extension RationalNumber: Numeric {
    public init?<T: BinaryInteger>(exactly source: T) {
        if let numerator = IntegerBase.init(exactly: source) {
            self.init(numerator, 1)
        } else {
            return nil
        }
    }

    public var magnitude: RationalNumber<IntegerBase.Magnitude> {
        return RationalNumber<IntegerBase.Magnitude>(numerator.magnitude, denominator.magnitude)
    }

    public static func + (lhs: RationalNumber<IntegerBase>, rhs: RationalNumber<IntegerBase>)
            -> RationalNumber<IntegerBase> {
        let (lhsNumerator, rhsNumerator, denominator) = lcd(lhs, rhs)
        return RationalNumber(lhsNumerator + rhsNumerator, denominator)
    }

    public static func += (lhs: inout RationalNumber<IntegerBase>, rhs: RationalNumber<IntegerBase>) {
        lhs = lhs + rhs
    }

    public static func - (lhs: RationalNumber<IntegerBase>, rhs: RationalNumber<IntegerBase>)
            -> RationalNumber<IntegerBase> {
        let (lhsNumerator, rhsNumerator, denominator) = lcd(lhs, rhs)
        return RationalNumber(lhsNumerator - rhsNumerator, denominator)
    }

    public static func -= (lhs: inout RationalNumber<IntegerBase>, rhs: RationalNumber<IntegerBase>) {
        lhs = lhs - rhs
    }

    public static func * (lhs: RationalNumber<IntegerBase>, rhs: RationalNumber<IntegerBase>)
            -> RationalNumber<IntegerBase> {
        let gcd1 = gcd(lhs.numerator, rhs.denominator)
        let gcd2 = gcd(lhs.denominator, rhs.numerator)

        let numerator = (lhs.numerator / gcd1) * (rhs.numerator / gcd2)
        let denominator = (lhs.denominator / gcd2) * (rhs.denominator / gcd1)
        return RationalNumber(numerator, denominator)
    }

    public static func *= (lhs: inout RationalNumber<IntegerBase>, rhs: RationalNumber<IntegerBase>) {
        lhs = lhs * rhs
    }
}

public extension RationalNumber {
    static func / (lhs: RationalNumber<IntegerBase>, rhs: RationalNumber<IntegerBase>) -> RationalNumber<IntegerBase> {
        precondition(rhs.numerator != 0, "Unable to divide a RationalNumber by zero.")

        let gcd1 = gcd(lhs.numerator, rhs.numerator)
        let gcd2 = gcd(lhs.denominator, rhs.denominator)

        let numerator = (lhs.numerator / gcd1) * (rhs.denominator / gcd2)
        let denominator = (lhs.denominator / gcd2) * (rhs.numerator / gcd1)
        return RationalNumber(numerator, denominator)
    }

    static func /= (lhs: inout RationalNumber<IntegerBase>, rhs: RationalNumber<IntegerBase>) {
        lhs = lhs * rhs
    }
}

extension RationalNumber: SignedNumeric where IntegerBase: SignedNumeric {
    public mutating func negate() {
        numerator.negate()
    }
}

extension RationalNumber: CustomStringConvertible {
    public var description: String {
        return numerator.description + "/" + denominator.description
    }
}
