// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

/**
 【请脑补Xcode项目构建的五大组成部分】
 
  一、 name（必需参数）：这是 Swift 包的名称，通常应该是一个唯一的标识符。这个名称用于在代码中引用这个包，并且也会用作包的目录名称。
 
  二、platforms（可选参数）：这是一个描述 Swift 包支持的目标平台的数组。每个平台都可以指定其最低部署版本。示例：
         platforms: [
             .macOS(.v10_14),
             .iOS(.v13),
             .watchOS(.v6),
             .tvOS(.v13)
         ]
 
  三、products（必需参数）：这是 Swift 包提供的产品的数组。产品可以是库或可执行文件。示例：
         products: [
             .library(name: "MyLibrary", targets: ["MyLibrary"]),
             .executable(name: "MyExecutable", targets: ["MyExecutable"])
         ]

  四、dependencies（可选参数）：这是一个数组，其中包含 Swift 包的依赖关系。你可以指定其他 Swift 包作为依赖，以便在构建时自动下载和包含它们。示例：
         dependencies: [
             .package(url: "https://github.com/Example/SomePackage", from: "1.0.0")
         ]

  五、targets（必需参数）：这是 Swift 包中的目标数组，每个目标都指定了要构建的源代码文件和其他设置。示例：
         targets: [
             .target(
                 name: "MyLibrary",
                 dependencies: []
             ),
             .testTarget(
                 name: "MyLibraryTests",
                 dependencies: ["MyLibrary"]
             )
         ]
 */

let package = Package(
    name: "MyLibrary",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "MyLibrary",
            targets: ["MyLibrary"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "MyLibrary",
            dependencies: []),
        .testTarget(
            name: "MyLibraryTests",
            dependencies: ["MyLibrary"]),
        .binaryTarget(
            name: "FCTestSDK",
            path: "Frameworks/FCTestSDK.xcframework")
    ]
)
