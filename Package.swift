// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Lilac",
    products: [
        .executable(name: "Compiler", targets: ["Compiler"]),
        .library(name: "Ast", targets: ["Ast"]),
        .library(name: "Semantic", targets: ["Semantic"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/johnsundell/files.git",
            from: "4.2.0"),
        .package(url: "https://github.com/apple/swift-argument-parser.git",
                 from: "1.2.2"),
    ],
    targets: [
        .target(name: "Ast"),
        .target(name: "Semantic"),
        .executableTarget(
            name: "Compiler",
            dependencies: [
                .product(
                    name: "Files",
                    package: "files"),
                .product(
                    name: "ArgumentParser",
                    package: "swift-argument-parser"),
            ]),
        .testTarget(
            name: "CompilerTests",
            dependencies: ["Compiler"]),
    ])
