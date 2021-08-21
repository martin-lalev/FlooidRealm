// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "FlooidRealm",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "FlooidRealm",
            targets: ["FlooidRealm"]),
    ],
    dependencies: [
        .package(name: "Realm", url: "https://github.com/realm/realm-cocoa", from: "10.7.0")
    ],
    targets: [
        .target(
            name: "FlooidRealm",
            dependencies: [
                .product(name: "RealmSwift", package: "Realm"),
            ],
            path: "FlooidRealm",
            exclude: ["Info.plist"]
        ),
    ]
)
