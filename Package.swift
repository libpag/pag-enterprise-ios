// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.
// 模板文件：由 submit_cocoapods.sh 根据实际版本号生成 Package.swift
// 请勿直接修改生成的 Package.swift

import PackageDescription

let package = Package(
    name: "libpag-enterprise",
    platforms: [.iOS(.v9)],
    products: [
        .library(
            name: "libpag-enterprise",
            targets: ["libpag-enterprise"]),
    ],
    targets: [
        .binaryTarget(
            name: "libpag-enterprise",
            url: "https://github.com/libpag/pag-enterprise-ios/releases/download/4.5.92/libpag_enterprise_4.5.92_ios_arm64_x86_64.zip",
            checksum: "91fd114bcd0c55a2a92155b372f5c232caa7ba2e6bbd32238913b973054dd67f")
    ]
)
