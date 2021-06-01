// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "POSInfiniteScroll",
    platforms: [.iOS(.v10)],
    products: [
        .library(
            name: "POSInfiniteScroll",
            targets: ["POSInfiniteScroll"])
    ],
    targets: [
        .target(name: "POSInfiniteScroll",
                path: "POSInfiniteScroll",
                exclude: ["Info.plist",
                          "POSInfiniteScroll.h",
                          "SwizzleLoader.h",
                          "SwizzleLoader.m"])
    ],
    swiftLanguageVersions: [.v5]
)
