# Rations

> A rational number type for Swift.

Rations is a rational number value type for Swift. It allows you to perform calculations on fractional numbers without the loss of precision caused by floating-point arithmetic. Rational numbers are useful for representing currency and for other applications where exact results, not approximations, are desired.

For example, the fraction `1/3` can be exactly represented as a rational number, but not as a floating point number:

```swift
let x: Rational = 1 / 3
// x == 1/3
let y: Double = 1 / 3
// y == 0.3333333333333333
```

Rations does have a performance penalty compared to Swift’s native floating point types. You might not want to use Rations in performance-sensitive areas. Each operation that returns a rational number involves calculating the greatest common divisor of the numerator and denominator using the Euclidean algorithm.

## Install

Rations requires Swift 4.2 or higher. It supports iOS, macOS, tvOS, watchOS, and Linux.

### Swift Package Manager

Add the following line to your `Package.swift`:
```swift
.package(url: "https://github.com/erikstrottmann/Rations.git", from: "0.1.0"),
```

### CocoaPods

Add the following line to your `Podfile`:
```ruby
pod 'Rations', '~> 0.1.0'
```

### Carthage

Add the following line to your `Cartfile`:
```
github "erikstrottmann/Rations" ~> 0.1.0
```

## Usage

```swift
let x: Rational = 1 / 4
let y: Rational = 2 / 3
let z = x + y
// z == 11/12
```

## Contributing

Open an [issue](https://github.com/erikstrottmann/Rations/issues) or a [pull request](https://github.com/erikstrottmann/Rations/pulls)!

## License

[MIT licensed](LICENSE.md), © 2018 Erik Strottmann.
