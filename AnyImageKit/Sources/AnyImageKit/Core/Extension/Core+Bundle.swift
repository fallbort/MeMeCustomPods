//
//  Core+Bundle.swift
//  AnyImageKit
//
//  Created by 刘栋 on 2020/9/23.
//  Copyright © 2020-2021 AnyImageProject.org. All rights reserved.
//

import Foundation

#if !ANYIMAGEKIT_ENABLE_SPM
extension Bundle {
    
    private class _BundleClass { }
    
    static let anyImageKitCore: Bundle = {
        let bundle = Bundle(for: _BundleClass.self)
        guard let url = bundle.url(forResource: "AnyImageKit_Core", withExtension: "bundle"), let resource = Bundle(url: url) else {
            return bundle
        }
        return resource
    }()
    
    
    static let anyImageKitPicker: Bundle = {
        let bundle = Bundle(for: _BundleClass.self)
        guard let url = bundle.url(forResource: "AnyImageKit_Picker", withExtension: "bundle"), let resource = Bundle(url: url) else {
            return bundle
        }
        return resource
    }()
    
    
    
    static let anyImageKitEditor: Bundle = {
        let bundle = Bundle(for: _BundleClass.self)
        guard let url = bundle.url(forResource: "AnyImageKit_Editor", withExtension: "bundle"), let resource = Bundle(url: url) else {
            return bundle
        }
        return resource
    }()
    
    
    static let anyImageKitCapture: Bundle = {
        let bundle = Bundle(for: _BundleClass.self)
        guard let url = bundle.url(forResource: "AnyImageKit_Capture", withExtension: "bundle"), let core = Bundle(url: url) else {
            return bundle
        }
        return core
    }()
    
}
#endif
