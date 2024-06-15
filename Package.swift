// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let moduleName = "NetworkLayer"
let testModuleName = "NetworkLayerTests"

let package = Package(
    name: moduleName,
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: moduleName,
            targets: [moduleName]),
    ],
    targets: [
        .target(
            name: moduleName,
            dependencies: []),
        .testTarget(
            name: testModuleName,
            dependencies: [.byName(name: moduleName)]),
    ]
)
