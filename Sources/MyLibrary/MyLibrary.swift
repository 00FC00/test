import FCTestSDK
import VerifyCode

public struct MyLibrary {
    let FCVerifyCodeDelegate = FCClass()
    let VerifyCodeManager = NTESVerifyCodeManager.getInstance()
    
    public private(set) var text = "Hello, World!"

    public init() {
    }
    
    public static func log() {
        print("FC的日志打印")
        
        FCTestSDK.test()
        NTESVerifyCodeManager.getInstance()
    }
    
    public func openVerifyCodwView(on view: UIView) {
        VerifyCodeManager.delegate = FCVerifyCodeDelegate
        VerifyCodeManager.alpha = 0.7
        VerifyCodeManager.frame = .null
        VerifyCodeManager.configureVerifyCode("4276ff0628c64033861d3e9136459974", timeout: 10)
        VerifyCodeManager.openVerifyCodeView(view)
    }
}

class FCClass {}

extension FCClass: NTESVerifyCodeManagerDelegate {
    
    func verifyCodeInitFinish() {
        
    }
    
    func verifyCodeInitFailed(_ error: [Any]?) {
        
    }
    
    func verifyCodeCloseWindow(_ close: NTESVerifyCodeClose) {
        
    }
    
    func verifyCodeValidateFinish(_ result: Bool, validate: String?, message: String) {
        if result {
            print( "验证码成功：\(validate ?? "")")
        } else {
            print( "验证码失败：\(validate ?? "")")
        }
       
    }
}
