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

extension RationalNumber: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: IntegerBase.IntegerLiteralType) {
        self.init(IntegerBase.init(integerLiteral: value), 1)
    }
}

public extension RationalNumber {
    var magnitude: RationalNumber<IntegerBase.Magnitude> {
        return RationalNumber<IntegerBase.Magnitude>(numerator.magnitude, denominator.magnitude)
    }

    static func + (lhs: RationalNumber<IntegerBase>, rhs: RationalNumber<IntegerBase>) -> RationalNumber<IntegerBase> {
        let (lhsNumerator, rhsNumerator, denominator) = lcd(lhs, rhs)
        return RationalNumber(lhsNumerator + rhsNumerator, denominator)
    }

    static func += (lhs: inout RationalNumber<IntegerBase>, rhs: RationalNumber<IntegerBase>) {
        lhs = lhs + rhs
    }

    static func - (lhs: RationalNumber<IntegerBase>, rhs: RationalNumber<IntegerBase>) -> RationalNumber<IntegerBase> {
        let (lhsNumerator, rhsNumerator, denominator) = lcd(lhs, rhs)
        return RationalNumber(lhsNumerator - rhsNumerator, denominator)
    }

    static func -= (lhs: inout RationalNumber<IntegerBase>, rhs: RationalNumber<IntegerBase>) {
        lhs = lhs - rhs
    }
}
