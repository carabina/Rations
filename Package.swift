// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "Rationality",
    products: [
        .library(
            name: "Rationality",
            targets: ["Rationality"]),
    ],
    targets: [
        .target(
            name: "Rationality",
            dependencies: []),
        .testTarget(
            name: "RationalityTests",
            dependencies: ["Rationality"]),
    ]
)
