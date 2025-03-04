// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "ImageFileToPngFile",
  dependencies: [
    .package(url: "https://github.com/realm/SwiftLint", from: "0.58.2"),
    .package(path: "../.."),
  ],
  targets: [
    .executableTarget(
      name: "ImageFileToPngFile",
      dependencies: [
        .product(name: "FpUtil", package: "sw-img2png"),
        .product(name: "ImageToPng", package: "sw-img2png"),
      ]
    )
  ]
)
