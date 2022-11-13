// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "POSInfiniteScroll",
    platforms: [.iOS(.v11)],
    products: [
        .library(
            name: "POSInfiniteScroll",
            targets: ["POSInfiniteScroll"])
    ],
    targets: [
        .target(name: "POSInfiniteScroll",
                path: "POSInfiniteScroll",
                exclude: ["Info.plist",
                          "POSInfiniteScroll.h"])
    ],
    swiftLanguageVersions: [.v5]
)
