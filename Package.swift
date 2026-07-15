// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "RiyazWidget",
    platforms: [.macOS(.v14)],
    products: [
        .executable(name: "DailyHadith", targets: ["RiyazWidget"])
    ],
    targets: [
        .executableTarget(
            name: "RiyazWidget",
            exclude: ["Resources"]
        )
    ]
)
