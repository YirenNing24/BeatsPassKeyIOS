// swift-tools-version: 5.9.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "BeatsPassKeyIOS",
	platforms: [
		.iOS(.v15) // Specify the minimum iOS version
	],
	products: [
		.library(
			name: "BeatsPassKeyIOS",
			type: .dynamic,
			targets: ["BeatsPassKeyIOS"]
		),
	],
	dependencies: [
		.package(url: "https://github.com/migueldeicaza/SwiftGodotKit.git", branch: "main")
	],
	targets: [
		.target(
			name: "BeatsPassKeyIOS",
			dependencies: [
				"SwiftGodot"
			],
			swiftSettings: [
				.unsafeFlags(["-suppress-warnings"])
			]
		),
		.testTarget(
			name: "BeatsPassKeyIOSTests",
			dependencies: ["BeatsPassKeyIOS"]
		),
	]
)
