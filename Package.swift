// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "BeatsPassKeyIOS",
    platforms: [
        .iOS(.v17),
        .macOS(.v10_15)
    ],

    products: [
        .library(
            name: "BeatsPassKeyIOS",
            type: .dynamic,
            targets: ["BeatsPassKeyIOS"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/migueldeicaza/SwiftGodot.git", branch: "main")
    ],
    targets: [
        .target(
            name: "BeatsPassKeyIOS",
            dependencies: [
                "SwiftGodot", // Use the declared library product from SwiftGodot
                .product(name: "SwiftGodotMacroLibrary", package: "SwiftGodot") // Refer to the product declared in SwiftGodot's Package.swift
            ],
            swiftSettings: [
                .unsafeFlags(["-suppress-warnings"])
            ],
            plugins: [
                .plugin(name: "CodeGeneratorPlugin", package: "SwiftGodot"),
                .plugin(name: "EntryPointGeneratorPlugin", package: "SwiftGodot")
            ]
        ),
        .testTarget(
            name: "BeatsPassKeyIOSTests",
            dependencies: ["BeatsPassKeyIOS"]
        ),
    ]
)
