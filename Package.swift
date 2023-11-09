// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

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


// 工程配置文件
let package = Package(
    // 1.Package名
    name: .MySDK,
    
    // 2.平台
    platforms: [.iOS(.v13)],
    
    // 3.生成对外可见的Product【即：需要制成的framework】
    products: [
        .MySDK,
    ],
    
    // 4.三方Package的依赖引用【例：.package(url: /* package url */, from: "1.0.0"),】
    dependencies: [],
    
    // 5.配置编译条件的Targets【参考Xcode编译多target配置】
    targets: [
        .MySDK,
        .MySDKTests,
        .ThirdSDK,
        .MyCommandPlugin,
        .MyBuildToolPlugin,
        .ExecutableBinary,
    ]
)

// 一、设置文件源
enum BinarySource {
    case local, remote

    init() {
        self = (getenv("USE_LOCAL_THIRD_BINARIES") != nil) ? .local : .remote
    }
}

// 二、命名空间
extension String {
    static let MySDK = "MyLibrary"
    static let MySDKTests = "\(MySDK)Tests"
    static let ThirdSDK = "VerifyCode"
    static let MyCommandPlugin = "GenerateCodeStats"
    static let MyBuildToolPlugin = "GenUserDefaults"
    static let ExecutableBinary = "GenUserDefaultsExec"
}

// 三、输出Product
 extension Product {
     // 1.SDKs
     static let MySDK = library(name: .MySDK, targets: [.MySDK])
     static let ThirdSDK = library(name: .ThirdSDK, targets: [.ThirdSDK])
     // 2.Plugins
     static let MyCommandPlugin = plugin(name: .MyCommandPlugin, targets: [.MyCommandPlugin])
     static let MyBuildToolPlugin = plugin(name: .MyBuildToolPlugin, targets: [.MyBuildToolPlugin])
     // 3.Executable Binary
     static let ExecutableBinary = executable(name: .ExecutableBinary, targets: [.ExecutableBinary])
}

// 四、依赖库
extension Target.Dependency {
    static let MySDK = byName(name: .MySDK)
    static let ThirdSDK = byName(name: .ThirdSDK)
    static let MyCommandPlugin = byName(name: .MyCommandPlugin)
    static let MyBuildToolPlugin = byName(name: .MyBuildToolPlugin)
    static let ExecutableBinary = byName(name: .ExecutableBinary)
}

// 五、关联关系
extension LinkerSetting {
    // 1.三方
    static let ThirdSDK = linkedFramework(.ThirdSDK)
    
    // 2.系统
    static let SystemConfiguration = linkedFramework("SystemConfiguration")
    static let JavaScriptCore = linkedFramework("JavaScriptCore")
    static let WebKit = linkedFramework("WebKit")
    
    // 3.动态库
    //static let zLibrary = linkedLibrary("z")
    //static let cPlusPlusLibrary = linkedLibrary("c++")
    
    // 4.标识符
    static let ObjC = unsafeFlags(["-ObjC"])
}

// 六、资源文件
extension Resource {
    // 1.自己SDK用process性能高，copy性能低【近似于 @import与#import的关系】
    static let Funtoy = process("../../Resources/Funtoy.bundle")
    
    // 2.三方SDK用copy，保持资源路径不被改变
    static let NTESVerifyCodeResources = copy("../../Resources/NTESVerifyCodeResources.bundle")
}

// 七、Target编译配置
extension Target {
    // 1.MySDK
    static let MySDK = target(
        name: .MySDK,
        dependencies: [
            .ThirdSDK,
        ],
        resources: [
            .NTESVerifyCodeResources
        ],
        linkerSettings: [
            .ThirdSDK,
            .SystemConfiguration,
            .JavaScriptCore,
            .WebKit,
            .ObjC
        ],
        plugins: [
            .plugin(name: .MyCommandPlugin),
            .plugin(name: .MyBuildToolPlugin)
        ]
    )
    
    // 2.MySDKTests
    static let MySDKTests = testTarget(name: .MySDKTests, dependencies: [.MySDK])
    
    // 3.ThirdSDK
    static let ThirdSDK = binaryTarget(name: .ThirdSDK, remoteChecksum: "be0c8b7d464e4170190e659b81970de3d8458ab2dece84323aa662e6d76c8efd")

    static let binarySource = BinarySource()
    
    static func binaryTarget(name: String, remoteChecksum: String) -> Target {
        switch binarySource {
        case .local:
            return .binaryTarget(name: name, path: localBinaryPath(for: name))
        case .remote:
            return .binaryTarget(name: name, path: localBinaryPath(for: name))
            //return .binaryTarget(name: name, url: remoteBinaryURLString(for: name), checksum: remoteChecksum)
        }
    }
    
    static func localBinaryPath(for name: String) -> String {
        "Frameworks/\(name).xcframework"
    }

    static func remoteBinaryURLString(for name: String) -> String {
        "https://github.com/00FC00/passport/releases/download/1.0.0/\(name).zip"
    }
    
    // 4.Plugins
    // 4.1 Command
    static let MyCommandPlugin = plugin(
        name: .MyCommandPlugin,
        capability: .command(
            intent: .custom(
                verb: "code-stats",
                description: "Generates code statistics"
            ),
            permissions: [
                .writeToPackageDirectory(reason: "Generate code statistics file at root level")
            ]
        )
    )
    
    // 4.2 BuildTool
    static let MyBuildToolPlugin = plugin(
        name: .MyBuildToolPlugin,
        capability: .buildTool(),
        dependencies: [.ExecutableBinary]
    )

    // 5.可执行的二进制程序
    static let ExecutableBinary = executableTarget(name: .ExecutableBinary, dependencies: [])
}
