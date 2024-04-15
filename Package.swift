// swift-tools-version:5.3
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
            targets: ["InsuranceCardScan"]),
    ],
    targets: [
        .binaryTarget(
          name: "InsuranceCardScan",
          path: "./Sources/InsuranceCardScan.xcframework")
    ]
)
