// swift-tools-version:4.2

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
    ],
    swiftLanguageVersions: [.v4_2]
)
