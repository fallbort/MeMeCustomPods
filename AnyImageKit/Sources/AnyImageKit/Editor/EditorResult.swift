//
//  EditorResult.swift
//  AnyImageKit
//
//  Created by 刘栋 on 2020/9/28.
//  Copyright © 2020-2021 AnyImageProject.org. All rights reserved.
//

import Foundation

public enum MediaType: Int {
    case photo = 0
    case video = 1
    case photoVideo = 2
    case text = 3
}

public struct EditorResult: Equatable {
    
    public let mediaURL: URL
    public let type: MediaType
    public let isEdited: Bool
    
    init(mediaURL: URL, type: MediaType, isEdited: Bool) {
        self.mediaURL = mediaURL
        self.type = type
        self.isEdited = isEdited
    }
}
