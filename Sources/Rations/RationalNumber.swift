//
//  RationalNumber.swift
//  Rations
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
/// normalized: the denominator is always positive, and the sign of the
/// numerator is always equal to the sign of the rational number itself.
///
/// For example:
///
///     let x = RationalNumber<Int>(2, -4)
///     // x.numerator == -1
///     // x.denominator == 2
///
/// ## Generic type parameter Base
///
/// `RationalNumber` is a generic type with a type parameter `Base` that must
/// conform to `BinaryInteger`. The `numerator` and `denominator` of a
/// `RationalNumber<Base>` value are both of type `Base`.
///
/// If `Base` is an unsigned type, then `RationalNumber<Base>` is also an
/// unsigned type. If `Base` is a signed type, then `RationalNumber<Base>` is
/// also a signed type.
///
/// - Warning: If `Base` is a fixed-width integer type, then
///   `RationalNumber<Base>` cannot represent values with absolute value greater
///   than `Base.max` or less than `1 / Base.max`, even if those values would
///   otherwise be reduced.
///
/// For example, `Int8.max`, `127`, is a valid value for both the numerator and
/// the denominator of a `RationalNumber<Int8>` value, but `Int8.min`, `-128`,
/// will trigger a runtime error if used as either the numerator or the
/// denominator, even if it that value would otherwise be reduced:
///
///     let y = RationalNumber(Int8.max)
///     // y.numerator == 127
///     // y.denominator == 1
///
///     let z = RationalNumber(Int8.min, Int8.min)
///     // Fatal error: Not enough bits to represent a signed value
public struct RationalNumber<Base: BinaryInteger>: Hashable {
    /// The numerator of this rational number.
    ///
    /// The sign of this value is always equal to the sign of the rational
    /// number itself.
    public private(set) var numerator: Base
    /// The denominator of this rational number.
    ///
    /// This value is always positive.
    public private(set) var denominator: Base

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
    /// - Warning: If `Base` is a fixed-width integer type, then
    ///   `RationalNumber<Base>` cannot represent values with absolute value
    ///   greater than `Base.max` or less than `1 / Base.max`, even if those
    ///   values would otherwise be reduced.
    ///
    /// For example, `Int8.max`, `127`, is a valid value for both the numerator
    /// and the denominator of a `RationalNumber<Int8>` value, but `Int8.min`,
    /// `-128`, will trigger a runtime error if used as either the numerator or
    /// the denominator, even if that value would otherwise be reduced:
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
    public init(_ numerator: Base, _ denominator: Base = 1) {
        precondition(denominator != 0, "Unable to initialize a RationalNumber with zero denominator.")

        // Reduce the fraction by dividing by the GCD.
        // Normalize the sign by multiplying by the denominator’s signum.
        let gcd = Rations.gcd(numerator, denominator)
        let signum = denominator.signum()

        self.numerator = signum * (numerator / gcd)
        self.denominator = signum * (denominator / gcd)
    }
}

/// A rational number value type, with numerator and denominator of type `Int`.
public typealias Rational = RationalNumber<Int>

extension RationalNumber: Comparable {
    // MARK: Comparable conformance

    public static func < (lhs: RationalNumber<Base>, rhs: RationalNumber<Base>) -> Bool {
        let (lhsNumerator, rhsNumerator, _) = lcd(lhs, rhs)
        return lhsNumerator < rhsNumerator
    }
}

extension RationalNumber: ExpressibleByIntegerLiteral {
    // MARK: ExpressibleByIntegerLiteral conformance

    /// Creates an instance initialized to the specified integer value.
    ///
    /// Do not call this initializer directly. Instead, initialize a variable or
    /// constant using an integer literal. For example:
    ///
    ///     let x: RationalNumber<Int> = 23
    ///
    /// In this example, the assignment to the `x` constant calls this integer
    /// literal initializer behind the scenes.
    ///
    /// - Parameter value: The value to create.
    public init(integerLiteral value: Base.IntegerLiteralType) {
        self.init(Base.init(integerLiteral: value), 1)
    }
}

extension RationalNumber: Numeric {
    // MARK: Numeric conformance

    /// Creates a new instance from the given integer, if it can be represented
    /// exactly.
    ///
    /// If the value passed as `source` is not representable exactly, the result
    /// is `nil`. In the following example, the constant `x` is successfully
    /// created from a value of `100`, while the attempt to initialize the
    /// constant `y` from `1_000` fails because the `RationalNumber<Int8>` type
    /// can represent `127` at maximum:
    ///
    ///     let x = RationalNumber<Int8>(exactly: 100)
    ///     // x == Optional(RationalNumber<Int8>(100))
    ///     let y = RationalNumber<Int8>(exactly: 1_000)
    ///     // y == nil
    ///
    /// - Parameter source: A value to convert to this type.
    public init?<T: BinaryInteger>(exactly source: T) {
        if let numerator = Base.init(exactly: source), RationalNumber<Base>.canRepresent(numerator) {
            self.init(numerator, 1)
        } else {
            return nil
        }
    }

    private static func canRepresent(_ value: Base) -> Bool {
        return Base(exactly: value.magnitude) != nil
    }

    /// The magnitude of this value.
    ///
    /// For any numeric value `x`, `x.magnitude` is the absolute value of `x`.
    /// You can use the `magnitude` property in operations that are simpler to
    /// implement in terms of unsigned values, such as printing the value of an
    /// integer, which is just printing a '-' character in front of an absolute
    /// value.
    ///
    ///     let x = -200
    ///     // x.magnitude == 200
    ///
    /// The global `abs(_:)` function provides more familiar syntax when you need
    /// to find an absolute value. In addition, because `abs(_:)` always returns
    /// a value of the same type, even in a generic context, using the function
    /// instead of the `magnitude` property is encouraged.
    public var magnitude: RationalNumber<Base.Magnitude> {
        return RationalNumber<Base.Magnitude>(numerator.magnitude, denominator.magnitude)
    }

    public static func + (lhs: RationalNumber<Base>, rhs: RationalNumber<Base>)
        -> RationalNumber<Base> {
            let (lhsNumerator, rhsNumerator, denominator) = lcd(lhs, rhs)
            return RationalNumber(lhsNumerator + rhsNumerator, denominator)
    }

    public static func += (lhs: inout RationalNumber<Base>, rhs: RationalNumber<Base>) {
        lhs = lhs + rhs
    }

    public static func - (lhs: RationalNumber<Base>, rhs: RationalNumber<Base>)
        -> RationalNumber<Base> {
            let (lhsNumerator, rhsNumerator, denominator) = lcd(lhs, rhs)
            return RationalNumber(lhsNumerator - rhsNumerator, denominator)
    }

    public static func -= (lhs: inout RationalNumber<Base>, rhs: RationalNumber<Base>) {
        lhs = lhs - rhs
    }

    public static func * (lhs: RationalNumber<Base>, rhs: RationalNumber<Base>)
        -> RationalNumber<Base> {
            let gcd1 = gcd(lhs.numerator, rhs.denominator)
            let gcd2 = gcd(lhs.denominator, rhs.numerator)

            let numerator = (lhs.numerator / gcd1) * (rhs.numerator / gcd2)
            let denominator = (lhs.denominator / gcd2) * (rhs.denominator / gcd1)
            return RationalNumber(numerator, denominator)
    }

    public static func *= (lhs: inout RationalNumber<Base>, rhs: RationalNumber<Base>) {
        lhs = lhs * rhs
    }
}

public extension RationalNumber {
    // MARK: Division

    static func / (lhs: RationalNumber<Base>, rhs: RationalNumber<Base>) -> RationalNumber<Base> {
        precondition(rhs.numerator != 0, "Unable to divide a RationalNumber by zero.")

        let gcd1 = gcd(lhs.numerator, rhs.numerator)
        let gcd2 = gcd(lhs.denominator, rhs.denominator)

        let numerator = (lhs.numerator / gcd1) * (rhs.denominator / gcd2)
        let denominator = (lhs.denominator / gcd2) * (rhs.numerator / gcd1)
        return RationalNumber(numerator, denominator)
    }

    static func /= (lhs: inout RationalNumber<Base>, rhs: RationalNumber<Base>) {
        lhs = lhs * rhs
    }
}

extension RationalNumber: SignedNumeric where Base: SignedNumeric {
    // MARK: SignedNumeric conditional conformance

    /// Replaces this value with its additive inverse.
    ///
    /// The following example uses the `negate()` method to negate the value of
    /// a rational number `x`:
    ///
    ///     var x: RationalNumber<Int> = 21
    ///     x.negate()
    ///     // x == -21
    public mutating func negate() {
        numerator.negate()
    }
}

extension RationalNumber: CustomStringConvertible {
    // MARK: CustomStringConvertible conformance

    /// A textual representation of this instance.
    ///
    /// Calling this property directly is discouraged. Instead, convert an
    /// instance of any type to a string by using the `String(describing:)`
    /// initializer. This initializer works with any type, and uses the custom
    /// `description` property for types that conform to
    /// `CustomStringConvertible`:
    ///
    ///     let r = RationalNumber<Int>(3, 4)
    ///     let s = String(describing: r)
    ///     print(s)
    ///     // Prints "3/4"
    ///
    /// The conversion of `r` to a string in the assignment to `s` uses the
    /// `RationalNumber` type’s `description` property.
    public var description: String {
        return numerator.description + "/" + denominator.description
    }
}

public extension RationalNumber where Base: FixedWidthInteger {
    // MARK: Maximum and minimum values

    /// The maximum value representable by this type.
    ///
    /// This value is always `Base.max / 1`.
    static var max: RationalNumber<Base> {
        return RationalNumber(Base.max, 1)
    }

    /// The minimum value representable by this type.
    ///
    /// For unsigned rational number types, this value is `Base.min / 1`.
    ///
    /// For signed rational number types, this value is `-Base.max / 1`.
    static var min: RationalNumber<Base> {
        if Base.min.magnitude > Base.max.magnitude {
            return RationalNumber(0 - Base.max, 1)
        } else {
            return RationalNumber(Base.min, 1)
        }
    }

    /// The minimum positive value representable by this type.
    ///
    /// This value compares less than or equal to all positive numbers, but
    /// greater than zero. This value is always `1 / Base.max`.
    static var leastNonzeroMagnitude: RationalNumber<Base> {
        return RationalNumber(1, Base.max)
    }
}

public extension RationalNumber {
    // MARK: Sign

    /// A Boolean value indicating whether this type is a signed rational number
    /// type.
    ///
    /// *Signed* rational number types can represent both positive and negative
    /// values. *Unsigned* rational number types can represent only nonnegative
    /// values.
    static var isSigned: Bool {
        return Base.isSigned
    }

    /// Returns `-1` if this value is negative and `1` if it's positive;
    /// otherwise, `0`.
    ///
    /// - Returns: The sign of this number, expressed as an integer of type
    ///   `Base`.
    func signum() -> Base {
        return numerator.signum()
    }
}

public extension RationalNumber {
    // MARK: Integer and double conversions

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
    var integerValue: Base? {
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
    var integerApproximation: Base {
        return numerator / denominator
    }

    /// The closest approximate `Double` value to this rational number.
    var doubleApproximation: Double {
        return Double(Int64(numerator)) / Double(Int64(denominator))
    }
}

// MARK: Free functions

/// Returns the absolute value of the given rational number.
///
/// - Parameter x: A rational number.
public func abs<Base: BinaryInteger>(_ x: RationalNumber<Base>) -> RationalNumber<Base> {
    return RationalNumber(abs(x.numerator), x.denominator)
}
