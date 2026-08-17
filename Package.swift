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
            url: "https://github.com/libpag/pag-enterprise-ios/releases/download/4.5.91/libpag_enterprise_4.5.91_ios_arm64_x86_64.zip",
            checksum: "390f04c7be39f8b25d9bd192ce51ef4e263aa79fac766fd31c540429b4c020c6")
    ]
)
