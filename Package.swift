// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "BeatsPassKeyIOS",
    platforms: [
        .iOS(.v15)
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
                "SwiftGodot"
            ],
            swiftSettings: [
                .unsafeFlags(["-suppress-warnings"])
            ],
			linkerSettings: [
                .linkedFramework("AuthenticationServices") // Add AuthorizationServices framework
            ]
        ),	
        .testTarget(
            name: "BeatsPassKeyIOSTests",
            dependencies: ["BeatsPassKeyIOS"]
        ),
    ]
)
