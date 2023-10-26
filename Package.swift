// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import Foundation

#if os(Linux)
import Glibc
#else
import Darwin.C
#endif

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


enum BinarySource {
    case local, remote

    init() {
        if getenv("USE_LOCAL_THIRD_BINARIES") != nil {
            self = .local
        } else {
            self = .remote
        }
    }
}

// 一、命名空间
extension String {
    static let MySDK = "MyLibrary"
    static let MySDKTests = "\(MySDK)Tests"
    static let ThirdSDK = "FCTestSDK"
}

// 二、输出Product
 extension Product {
    static let MySDK = library(name: .MySDK, targets: [.MySDK])
    static let ThirdSDK = library(name: .ThirdSDK, targets: [.ThirdSDK])
}

// 三、依赖库
extension Target.Dependency {
    static let MySDK = byName(name: .MySDK)
    static let ThirdSDK = byName(name: .ThirdSDK)
}

// 四、关联关系
extension LinkerSetting {
    static let ThirdSDK = linkedFramework(.ThirdSDK)

}

// 五、Target编译配置
extension Target {
    static let MySDK = target(name: .MySDK, dependencies: [.ThirdSDK], linkerSettings: [.ThirdSDK])
    static let MySDKTests = testTarget(name: .MySDKTests, dependencies: [.MySDK])
    static let ThirdSDK = binaryTarget(name: .ThirdSDK, path: "Frameworks/\(String.ThirdSDK).xcframework")
}

// 工程配置文件
let package = Package(
    // 1.Package名
    name: .MySDK,
    
    // 2.生成对外可见的Product【即：需要制成的framework】
    products: [
        .MySDK,
        //.ThirdSDK,
    ],
    
    // 3.三方Package的依赖引用【例：.package(url: /* package url */, from: "1.0.0"),】
    dependencies: [],
    
    // 4.配置编译条件的Targets【参考Xcode编译多target配置】
    targets: [
        .MySDK,
        .MySDKTests,
        .ThirdSDK,
    ]
)
