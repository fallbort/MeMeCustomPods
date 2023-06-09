//
//  CaptureResult.swift
//  AnyImageKit
//
//  Created by 刘栋 on 2020/9/28.
//  Copyright © 2020-2021 AnyImageProject.org. All rights reserved.
//

import Foundation

public struct CaptureResult: Equatable {
    
    public let mediaURL: URL
    public let type: PHMediaType
    
    init(mediaURL: URL, type: PHMediaType) {
        self.mediaURL = mediaURL
        self.type = type
    }
}
