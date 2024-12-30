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
                "SwiftGodot", 
                .target(name: "SwiftGodotMacroLibrary", condition: .when(platforms: [.iOS, .macOS])) // Add this dependency
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
