//
//  Utilities.swift
//  Rationality
//
//  Created by Erik Strottmann on 6/9/18.
//  Copyright © 2018 Erik Strottmann. All rights reserved.
//

/// Returns the absolute value of the given number.
///
/// - Warning: The absolute value of `x` must be representable in the same type.
///   If this precondition is violated, this function will fail at runtime.
///
/// - Parameter x: An integer.
func abs<T: BinaryInteger>(_ x: T) -> T {
    return T(x.magnitude)
}

/// Returns the absolute value of the given rational number.
///
/// - Parameter x: A rational number.
public func abs<IntegerBase: BinaryInteger>(_ x: RationalNumber<IntegerBase>) -> RationalNumber<IntegerBase> {
    return RationalNumber(abs(x.numerator), x.denominator)
}

/// Returns the greatest common divisor of the two given number.
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
///   of these preconditions is violated, this function will fail at runtime.
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
