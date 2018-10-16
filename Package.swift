// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "Rations",
    products: [
        .library(
            name: "Rations",
            targets: ["Rations"]),
    ],
    targets: [
        .target(
            name: "Rations",
            dependencies: []),
        .testTarget(
            name: "RationsTests",
            dependencies: ["Rations"]),
    ]
)
