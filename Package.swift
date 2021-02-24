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
        .package(url: "https://github.com/kylef/PathKit.git", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.3.2"),
        .package(url: "https://github.com/jpsim/Yams.git", from: "4.0.4"),
        .package(url: "https://github.com/onevcat/Rainbow.git", from: "3.2.0"),
        .package(url: "https://github.com/stencilproject/Stencil.git", from: "0.14.0"),
        .package(url: "https://github.com/scinfu/SwiftSoup.git", from: "2.3.2"),
        .package(url: "https://github.com/SwiftGen/StencilSwiftKit.git", from: "2.8.0"),
        .package(url: "https://github.com/weichsel/ZIPFoundation.git", from: "0.9.12"),
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
