import FCTestSDK
import VerifyCode

public struct MyLibrary {
    public private(set) var text = "Hello, World!"

    public init() {
    }
    
    public static func log() {
        print("FC的日志打印")
        
        FCTestSDK.test()
        NTESVerifyCodeManager.getInstance()
    }
}
