// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "BeatsPassKeyIOS",
    platforms: [
        .iOS(.v15),
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
                "SwiftGodotMacroLibrary" // Add the macro library here
            ],
            swiftSettings: [
                .unsafeFlags(["-suppress-warnings"])
            ],
            linkerSettings: [
                .linkedFramework("AuthenticationServices") // Add AuthorizationServices framework
            ],
            plugins: [
                .plugin(name: "CodeGeneratorPlugin", package: "SwiftGodot"),
                .plugin(name: "EntryPointGeneratorPlugin", package: "SwiftGodot")
            ] // Include the required plugins
        ),  
        .testTarget(
            name: "BeatsPassKeyIOSTests",
            dependencies: ["BeatsPassKeyIOS"]
        ),
    ]
)
