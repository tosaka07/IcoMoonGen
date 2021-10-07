// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IcoMoonGen",
    platforms: [.macOS(.v10_13)],
    products: [
        .executable(name: "icomoongen", targets: ["IcoMoonGen"])
    ],
    dependencies: [
        .package(url: "https://github.com/kylef/PathKit", from: "1.0.1"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.1"),
        .package(url: "https://github.com/jpsim/Yams", from: "4.0.6"),
        .package(url: "https://github.com/onevcat/Rainbow", from: "4.0.1"),
        .package(url: "https://github.com/stencilproject/Stencil", from: "0.14.1"),
        .package(url: "https://github.com/scinfu/SwiftSoup", from: "2.3.3"),
        .package(url: "https://github.com/SwiftGen/StencilSwiftKit", from: "2.8.0"),
        .package(url: "https://github.com/weichsel/ZIPFoundation", from: "0.9.12"),
    ],
    targets: [
        .target(
            name: "IcoMoonGen",
            dependencies: [
                "IcoMoonGenCLI"
            ]),
        .target(
            name: "IcoMoonGenCLI",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "PathKit",
                "Yams",
                "Rainbow",
                "Stencil",
                "StencilSwiftKit",
                "SwiftSoup",
                "ZIPFoundation",
            ]
        ),
        .testTarget(
            name: "IcoMoonGenTests",
            dependencies: ["IcoMoonGen"]),
    ]
)
