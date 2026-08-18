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
            url: "https://github.com/libpag/pag-enterprise-ios/releases/download/4.4.68/libpag_enterprise_4.4.68_ios_arm64_x86_64.zip",
            checksum: "12b6787e59bdc2f53a33a20344cfd7aa37b8ebf0550886fd8dba0bc21b597401")
    ]
)
