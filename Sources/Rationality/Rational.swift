//
//  Rational.swift
//  Rationality
//
//  Created by Erik Strottmann on 6/9/18.
//  Copyright © 2018 Erik Strottmann. All rights reserved.
//

/// A rational number value type.
///
/// A rational number is any number representable as a fraction of the form
/// `p / q`, where the numerator `p` and the denominator `q` are both integers,
/// and the denominator `q` is nonzero.
///
/// Note that integers are themselves rational numbers with denominators of `1`.
/// Irrational numbers like the mathematical constants pi and _e_ cannot be
/// exactly represented by `RationalNumber`.
///
/// ## Reduced fraction and normalized sign
///
/// A `RationalNumber` value is always stored in reduced fraction form: the
/// greatest integer that evenly divides its numerator and denominator is always
/// `1`. Additionally, the sign of a `RationalNumber` value is always
/// normalized: the denominator is never negative, and the sign of the rational
/// number is determined by the sign of the numerator.
///
/// For example:
///
///     let x = RationalNumber<Int>(2, -4)
///     // x.numerator == -1
///     // x.denominator == 2
///
/// ## IntegerBase
///
/// `RationalNumber` is a generic type with a type parameter `IntegerBase`
/// that must conform to `BinaryInteger`. The `numerator` and `denominator` of
/// a `RationalNumber<IntegerBase>` value are both of type `IntegerBase`.
///
/// If `IntegerBase` is an unsigned type, then `RationalNumber<IntegerBase>` is
/// also an unsigned type. If `IntegerBase` is a signed type, then
/// `RationalNumber<IntegerBase>` is also a signed type.
///
/// - Warning: If `IntegerBase` is a fixed-width integer type, then
///   `RationalNumber<IntegerBase>` cannot represent values with absolute value
///   greater than `IntegerBase.max` or less than `1 / IntegerBase.max`, even
///   if those values are later reduced.
///
/// For example, `Int8.max`, `127`, is a valid value for both the numerator and
/// the denominator of a `RationalNumber<Int8>` value,
/// but `Int8.min`, `-128`, will trigger a runtime error if used as either the
/// numerator or the denominator, even if it is later reduced:
///
///     let y = RationalNumber(Int8.max)
///     // y.numerator == 127
///     // y.denominator == 1
///
///     let z = RationalNumber(Int8.min, Int8.min)
///     // Fatal error: Not enough bits to represent a signed value
public struct RationalNumber<IntegerBase: BinaryInteger>: Hashable {
    public private(set) var numerator: IntegerBase
    public private(set) var denominator: IntegerBase

    /// Creates a new instance with the given numerator and denominator, in
    /// reduced fraction form and with the sign normalized.
    ///
    /// The denominator defaults to `1`, and can be omitted.
    ///
    /// A `RationalNumber` value is always stored in reduced fraction form: the
    /// greatest integer that evenly divides its numerator and denominator is
    /// always `1`. Additionally, the sign of a `RationalNumber` value is always
    /// normalized: the denominator is never negative, and the sign of the
    /// rational number is determined by the sign of the numerator.
    ///
    /// For example:
    ///
    ///     let x = RationalNumber<Int>(2, -4)
    ///     // x.numerator == -1
    ///     // x.denominator == 2
    ///
    /// - Warning: If `IntegerBase` is a fixed-width integer type, then
    ///   `RationalNumber<IntegerBase>` cannot represent values with absolute value
    ///   greater than `IntegerBase.max` or less than `1 / IntegerBase.max`, even
    ///   if those values are later reduced.
    ///
    /// For example, `Int8.max`, `127`, is a valid value for both the numerator and
    /// the denominator of a `RationalNumber<Int8>` value,
    /// but `Int8.min`, `-128`, will trigger a runtime error if used as either the
    /// numerator or the denominator, even if it is later reduced:
    ///
    ///     let y = RationalNumber(Int8.max)
    ///     // y.numerator == 127
    ///     // y.denominator == 1
    ///
    ///     let z = RationalNumber(Int8.min, Int8.min)
    ///     // Fatal error: Not enough bits to represent a signed value
    ///
    /// - Parameters:
    ///   - numerator: The integer to use as the numerator.
    ///   - denominator: The integer to use as the denominator.
    public init(_ numerator: IntegerBase, _ denominator: IntegerBase = 1) {
        precondition(denominator != 0, "Unable to initialize a RationalNumber with zero denominator.")

        // Reduce the fraction by dividing by the GCD.
        // Normalize the sign by multiplying by the denominator’s signum.
        let gcd = Rationality.gcd(numerator, denominator)
        let signum = denominator.signum()

        self.numerator = signum * (numerator / gcd)
        self.denominator = signum * (denominator / gcd)
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
        if let numerator = IntegerBase.init(exactly: source), RationalNumber<IntegerBase>.canRepresent(numerator) {
            self.init(numerator, 1)
        } else {
            return nil
        }
    }

    private static func canRepresent(_ value: IntegerBase) -> Bool {
        return IntegerBase(exactly: value.magnitude) != nil
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

public extension RationalNumber where IntegerBase: FixedWidthInteger {
    /// The maximum value representable by this type.
    ///
    /// This value is always `IntegerBase.max / 1`.
    static var max: RationalNumber<IntegerBase> {
        return RationalNumber(IntegerBase.max, 1)
    }

    /// The minimum value representable by this type.
    ///
    /// For unsigned rational number types, this value is `IntegerBase.min / 1`.
    /// For signed rational number types, this value is `-IntegerBase.max / 1`.
    static var min: RationalNumber<IntegerBase> {
        if IntegerBase.min.magnitude > IntegerBase.max.magnitude {
            return RationalNumber(0 - IntegerBase.max, 1)
        } else {
            return RationalNumber(IntegerBase.min, 1)
        }
    }

    /// The minimum positive value representable by this type.
    ///
    /// This value compares less than or equal to all positive numbers, but
    /// greater than zero. This value is always `1 / IntegerBase.max`.
    static var leastNonzeroMagnitude: RationalNumber<IntegerBase> {
        return RationalNumber(1, IntegerBase.max)
    }
}

public extension RationalNumber {
    /// A Boolean value indicating whether this type is a signed rational number
    /// type.
    ///
    /// *Signed* rational number types can represent both positive and negative
    /// values. *Unsigned* rational number types can represent only nonnegative
    /// values.
    static var isSigned: Bool {
        return IntegerBase.isSigned
    }

    /// Returns `-1` if this value is negative and `1` if it's positive;
    /// otherwise, `0`.
    ///
    /// - Returns: The sign of this number, expressed as an integer of the same
    ///   type.
    func signum() -> IntegerBase {
        return numerator.signum()
    }
}

public extension RationalNumber {
    /// The integer value of this rational number, if it can be represented
    /// without rounding.
    ///
    /// If the rational number does not exactly represent an integer, this
    /// value will be `nil`.
    ///
    /// For example:
    ///
    ///     let x = Rational(5, 1).exactIntegerValue
    ///     // x == 5
    ///
    ///     let y = Rational(-3, 2).exactIntegerValue
    ///     // y == nil
    var integerValue: IntegerBase? {
        guard denominator == 1 else { return nil }
        return numerator
    }

    /// The approximate integer value of this rational number, rounding toward
    /// zero.
    ///
    /// Any fractional part of the rational number is omitted.
    ///
    /// For example:
    ///
    ///     let x = Rational(5, 1).integerValue
    ///     // x == 5
    ///
    ///     let y = Rational(-3, 2).integerValue
    ///     // y == -1
    var integerApproximation: IntegerBase {
        return numerator / denominator
    }

    /// The closest approximate `Double` value to this rational number.
    var doubleApproximation: Double {
        return Double(Int64(numerator)) / Double(Int64(denominator))
    }
}

/// Returns the absolute value of the given rational number.
///
/// - Parameter x: A rational number.
public func abs<IntegerBase: BinaryInteger>(_ x: RationalNumber<IntegerBase>) -> RationalNumber<IntegerBase> {
    return RationalNumber(abs(x.numerator), x.denominator)
}
