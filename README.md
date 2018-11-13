# Rations

> A rational number type for Swift.

## Install

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
