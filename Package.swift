// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "ErrorHandlingKit",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "ErrorHandlingKit",
            targets: ["ErrorHandlingKit"]),
        .executable(
            name: "ErrorHandlingDemo",
            targets: ["ErrorHandlingDemo"])
    ],
    targets: [
        .target(
            name: "ErrorHandlingKit",
            dependencies: []),
        .executableTarget(
            name: "ErrorHandlingDemo",
            dependencies: ["ErrorHandlingKit"],
            path: "Examples/ErrorHandlingDemo")
    ]
)