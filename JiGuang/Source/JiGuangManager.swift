//
//  JiGuangManager.swift
//  MeMeCustomPods
//
//  Created by xfb on 2023/6/14.
//

import Foundation
import JverificationSDK
import MeMeKit

@objc public class JiGuangManager : NSObject {
    @objc public static var shared = JiGuangManager()
    //MARK: <>外部变量
    
    //MARK: <>外部block
    
    
    //MARK: <>生命周期开始
    fileprivate override init() {
        super.init()
    }
    //MARK: <>功能性方法
    @objc public func startup(appKey:String,isProduction:Bool,privacyName:String,privacyUrl:String) {
        let config = JVAuthConfig()
        config.appKey = appKey
        config.channel = "App Store"
        config.isProduction = isProduction;
        config.timeout = 5000;
        config.authBlock = { (result) -> Void in
            if let result = Optional(result) {
                if let code = result["code"] as? Int, code == 8000 {
                    JVERIFICATIONService.preLogin(5000) { (result) in
                        if let result = Optional(result), let code = result["code"] as? Int,code == 7000 {
                            
                        }else if let result = Optional(result), let code = result["code"] as? Int {
                            
                        }else{
                            
                        }
                    }
                }else if let content = result["content"] {
                    
                }
            }
        }
        JVERIFICATIONService.setup(with: config)
        JVERIFICATIONService.setDebug(!isProduction)
        
        customWindowUI(privacyName:privacyName,privacyUrl:privacyUrl)
    }
    
    public func startLogin(workingChangeBlock:((_ isWorking:Bool)->())? = nil,complete:@escaping ((_ loginToken:String?,_ errorCode:Int)->())) {
        
        guard JVERIFICATIONService.checkVerifyEnable() == true else {
            complete(nil,-1000000)
            return
        }
        DispatchQueue.main.async {
            workingChangeBlock?(true)
        }
        
        if let vc = ScreenUIManager.topViewController() {
            JVERIFICATIONService.getAuthorizationWith(vc, hide: true, animated: true, timeout: 15*1000, completion: { (result) in
                if let result = Optional(result),let token = result["loginToken"] as? String, token.count > 0 {
                    DispatchQueue.main.async {
                        workingChangeBlock?(false)
                        complete(token,0)
                    }
                }else if let result = Optional(result), let code = result["code"] as? Int {
                    DispatchQueue.main.async {
                        workingChangeBlock?(false)
                        complete(nil,code)
                    }
                }else{
                    DispatchQueue.main.async {
                        workingChangeBlock?(false)
                        complete(nil,-99996)
                    }
                }
            }) { (type, content) in

            }
        }else{
            DispatchQueue.main.async {
                workingChangeBlock?(false)
                complete(nil,-99997)
            }
        }
    }
    
    public func clearLoginCache() {
        JVERIFICATIONService.clearPreLoginCache()
    }
    //弹窗模式
    fileprivate func customWindowUI(privacyName:String,privacyUrl:String) {
        let config = JVUIConfig()
        config.navCustom = true
        config.autoLayout = true
        config.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        
        //弹窗
        config.showWindow = true
        config.windowCornerRadius = 10
        config.windowBackgroundAlpha = 0.3
        
        let windowW: CGFloat = 300
        let windowH: CGFloat = 300
        let windowConstraintX = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.super, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        let windowConstraintY = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.super, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
        let windowConstraintW = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.none, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: windowW)
        let windowConstraintH = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.none, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant: windowH)
        config.windowConstraints = [windowConstraintX!, windowConstraintY!, windowConstraintW!, windowConstraintH!]
        config.windowHorizontalConstraints = config.windowConstraints
        
        
        //弹窗close按钮
        let window_close_nor_image = imageNamed(name: "windowClose")
        let window_close_hig_image = imageNamed(name: "windowClose")
        if let norImage = window_close_nor_image, let higImage = window_close_hig_image {
            config.windowCloseBtnImgs = [norImage, higImage]
        }
        let windowCloseBtnWidth = window_close_nor_image?.size.width ?? 15
        let windowCloseBtnHeight = window_close_nor_image?.size.height ?? 15
        
        let windowCloseBtnConstraintX = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.super, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1, constant: -5)
        let windowCloseBtnConstraintY = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.super, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 5)
        let windowCloseBtnConstraintW = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.none, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: windowCloseBtnWidth)
        let windowCloseBtnConstraintH = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.none, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant: windowCloseBtnHeight)
        config.windowCloseBtnConstraints = [windowCloseBtnConstraintX!, windowCloseBtnConstraintY!, windowCloseBtnConstraintW!, windowCloseBtnConstraintH!]
        config.windowCloseBtnHorizontalConstraints = config.windowCloseBtnConstraints
        
        //logo
        config.logoImg = UIImage(named: "cmccLogo") ?? UIImage()
        let logoWidth = config.logoImg.size.width
        let logoHeight = logoWidth
        let logoConstraintX = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.super, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        let logoConstraintY = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.super, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 10)
        let logoConstraintW = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.none, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: logoWidth)
        let logoConstraintH = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.none, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant: logoHeight)
        config.logoConstraints = [logoConstraintX!,logoConstraintY!,logoConstraintW!,logoConstraintH!]
        config.logoHorizontalConstraints = config.logoConstraints
               
        //号码栏
        let numberConstraintX = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.super, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant:0)
        let numberConstraintY = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.super, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant:130)
        let numberConstraintW = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.none, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant:130)
        let numberConstraintH = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.none, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant:25)
        config.numberConstraints = [numberConstraintX!, numberConstraintY!, numberConstraintW!, numberConstraintH!]
        config.numberHorizontalConstraints = config.numberConstraints
               
        //slogan
        let sloganConstraintX = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.super, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant:0)
        let sloganConstraintY = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.super, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant:160)
        let sloganConstraintW = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.none, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant:130)
        let sloganConstraintH = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.none, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant:20)
        config.sloganConstraints = [sloganConstraintX!, sloganConstraintY!, sloganConstraintW!, sloganConstraintH!]
        config.sloganHorizontalConstraints = config.sloganConstraints
               
        //登录按钮
        let login_nor_image = imageNamed(name: "loginBtn_Nor")
        let login_dis_image = imageNamed(name: "loginBtn_Dis")
        let login_hig_image = imageNamed(name: "loginBtn_Hig")
        if let norImage = login_nor_image, let disImage = login_dis_image, let higImage = login_hig_image {
            config.logBtnImgs = [norImage, disImage, higImage]
        }
        let loginBtnWidth = login_nor_image?.size.width ?? 100
        let loginBtnHeight = login_nor_image?.size.height ?? 100
        let loginConstraintX = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.super, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant:0)
        let loginConstraintY = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.super, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant:180)
        let loginConstraintW = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.none, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant:loginBtnWidth)
        let loginConstraintH = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.none, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant:loginBtnHeight)
        config.logBtnConstraints = [loginConstraintX!, loginConstraintY!, loginConstraintW!, loginConstraintH!]
        config.logBtnHorizontalConstraints = config.logBtnConstraints
               
        //勾选框
        let uncheckedImage = imageNamed(name: "checkBox_unSelected")
        let checkedImage = imageNamed(name: "checkBox_selected")
        let checkViewWidth = uncheckedImage?.size.width ?? 10
        let checkViewHeight = uncheckedImage?.size.height ?? 10
        config.uncheckedImg = uncheckedImage ?? UIImage()
        config.checkedImg = checkedImage ?? UIImage()
        let checkViewConstraintX = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.super, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant:20)
        let checkViewConstraintY = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.privacy, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant:0)
        let checkViewConstraintW = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.none, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant:checkViewWidth)
        let checkViewConstraintH = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.none, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant:checkViewHeight)
        config.checkViewConstraints = [checkViewConstraintX!, checkViewConstraintY!, checkViewConstraintW!, checkViewConstraintH!]
        config.checkViewHorizontalConstraints = config.checkViewConstraints
               
        //隐私
        let spacing = checkViewWidth + 20 + 5
        config.privacyState = true
        config.privacyTextAlignment = NSTextAlignment.left
        config.appPrivacyOne = [privacyName,privacyUrl]
        let privacyConstraintX = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.super, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant:spacing)
        let privacyConstraintX2 = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.super, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1, constant:-spacing)
        let privacyConstraintY = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.super, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant:-20)
        let privacyConstraintH = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.none, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant:50)
        config.privacyConstraints = [privacyConstraintX!,privacyConstraintX2!, privacyConstraintY!, privacyConstraintH!]
        config.privacyHorizontalConstraints = config.privacyConstraints
               
        //loading
        let loadingConstraintX = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.super, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant:0)
        let loadingConstraintY = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.super, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant:0)
        let loadingConstraintW = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.none, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant:30)
        let loadingConstraintH = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.none, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant:30)
        config.loadingConstraints = [loadingConstraintX!, loadingConstraintY!, loadingConstraintW!, loadingConstraintH!]
        config.loadingHorizontalConstraints = config.loadingConstraints
               
        JVERIFICATIONService.customUI(with: config) { (customView) in
            //自定义view, 加到customView上
            guard let customV = Optional(customView) else {
                return
            }
        }
   
    }
    
    fileprivate func imageNamed(name: String) -> UIImage? {
        if let bundlePath = Bundle.main.path(forResource: "JVerificationResource", ofType: "bundle") {
            let image = UIImage(contentsOfFile: bundlePath + "/\(name).png")
            return image
        }
        return nil
    }
    
    //MARK: <>内部View
    
    //MARK: <>内部UI变量
    //MARK: <>内部数据变量
    
    //MARK: <>内部block
    
}
