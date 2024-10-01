//
//  CGImage+Extension.swift
//  quickvideoeditor
//
//  Created by Daniel Toranzo Pérez on 17/9/24.
//

import Foundation
import CoreGraphics
import QuartzCore

extension CGImage {
        
    static func processImage(from url: URL) throws -> CGImage {
        guard let imageSource = CGImageSourceCreateWithURL(url as CFURL, nil) else {
            throw ImageProcessingError.imageLoadingFailed
        }
        
        guard let cgImage = CGImageSourceCreateImageAtIndex(imageSource, 0, nil) else {
            throw ImageProcessingError.imageCreationFailed
        }
        
        return cgImage
    }
    
}
