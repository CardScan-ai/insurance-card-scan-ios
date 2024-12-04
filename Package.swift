// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "InsuranceCardScan",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "InsuranceCardScan",
            targets: ["InsuranceCardScan"]
        ),
    ],
    dependencies: [
        // Adding a new dependency
        .package(url: "https://github.com/CardScan-ai/api-clients", from: "0.9.3"),
    ],
    targets: [
        .binaryTarget(
            name: "InsuranceCardScan",
            path: "./Sources/InsuranceCardScan.xcframework"
        )
    ]
)
