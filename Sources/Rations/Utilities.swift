//
//  Utilities.swift
//  Rations
//
//  Created by Erik Strottmann on 6/9/18.
//  Copyright © 2018 Erik Strottmann. All rights reserved.
//

/// Returns the absolute value of the given number.
///
/// - Warning: The absolute value of `x` must be representable in the same type.
///   If this precondition is violated, this function will trigger a runtime
///   error.
///
/// - Parameter x: An integer.
func abs<T: BinaryInteger>(_ x: T) -> T {
    return T(x.magnitude)
}

/// Returns the greatest common divisor of the two given numbers.
///
/// The greatest common divisor of two integers is the largest nonnegative
/// integer that evenly divides the two integers. For example:
///
///     gcd(6, 9)               // 3
///     gcd(4, -12)             // 4
///     gcd(7, 5)               // 1
///     gcd(2, 0)               // 2
///
/// - Warning: The two given numbers must not both be zero, and the absolute
///   value of both numbers must be representable in the given type. If either
///   of these preconditions is violated, this function will trigger a runtime
///   error.
///
/// - Parameters:
///   - lhs: An integer.
///   - rhs: Another integer.
func gcd<T: BinaryInteger>(_ lhs: T, _ rhs: T) -> T {
    precondition(lhs != 0 || rhs != 0, "Unable to calculate the GCD of two zero arguments.")
    guard lhs >= rhs else { return gcd(rhs, lhs) }

    // The Euclidean algorithm:
    var (a, b) = (abs(lhs), abs(rhs))
    while b != 0 {
        (a, b) = (b, a % b)
    }

    return a
}

/// Returns the lowest common denominator between the two given rational
/// numbers, and the numerators for the given numbers to be expressed with the
/// lowest common denominator.
///
/// For example:
///
///    let x = Rational(1, 4)
///    let y = Rational(2, 3)
///    let z = lcd(x, y)
///    // z = (lhsNumerator: 3, rhsNumerator: 8, denominator: 12)
///
/// - Parameters:
///   - lhs: A rational number.
///   - rhs: Another rational number.
///
/// - Returns: A tuple containing three values: the numerators for the two given
///   numbers to be expressed with the lowest common denominator, and the lowest
///   common denominator itself.
func lcd<IntegerBase: BinaryInteger>(_ lhs: RationalNumber<IntegerBase>, _ rhs: RationalNumber<IntegerBase>)
    -> (lhsNumerator: IntegerBase, rhsNumerator: IntegerBase, denominator: IntegerBase) {
        let gcd = Rations.gcd(lhs.denominator, rhs.denominator)

        let lhsNumerator = lhs.numerator * (rhs.denominator / gcd)
        let rhsNumerator = rhs.numerator * (lhs.denominator / gcd)
        let denominator = lhs.denominator / gcd * rhs.denominator

        return (lhsNumerator: lhsNumerator, rhsNumerator: rhsNumerator, denominator: denominator)
}
