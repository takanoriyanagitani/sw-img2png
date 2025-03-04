// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "sw-img2png",
  products: [
    .library(name: "ImageToPng", targets: ["ImageToPng"]),
    .library(name: "FpUtil", targets: ["FpUtil"]),
  ],
  dependencies: [
    .package(url: "https://github.com/realm/SwiftLint", from: "0.58.2")
  ],
  targets: [
    .target(name: "FpUtil"),
    .target(
      name: "ImageToPng",
      dependencies: [
        "FpUtil"
      ]
    ),
    .testTarget(
      name: "ImageToPngTests",
      dependencies: ["ImageToPng"]
    ),
  ]
)
