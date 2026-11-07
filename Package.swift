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
            url: "https://github.com/libpag/pag-enterprise-ios/releases/download/4.4.76/libpag_enterprise_4.4.76_ios_arm64_x86_64.zip",
            checksum: "f3d14e8ea71307b39db3fb1d23f764169cb05297af6989aacc804b14b3cafa02")
    ]
)
