//
//  ImageLayer.swift
//  quickvideoeditor
//
//  Created by Daniel Toranzo Pérez on 17/9/24.
//

import Foundation
import QuartzCore
import Cocoa

/// Represents an image layer that can be added to a video composition.
///
/// This class encapsulates properties and methods to create an image layer for video composition.
class ImageLayer: VideoLayer {
        
    enum CodingKeys: String, CodingKey {
        case imageURL
        case cornerRadius
    }
    
    /// The file URL of the image to be displayed.
    let imageURL: String
    
    /// The corner radius of the video layer.
    let cornerRadius: CGFloat
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.imageURL = try container.decode(String.self, forKey: .imageURL)
        self.cornerRadius = try container.decode(CGFloat.self, forKey: .cornerRadius)
        try super.init(from: decoder)
    }
    
    /// Converts this `ImageLayer` to a `CALayer` suitable for rendering an image.
    /// - Returns: A `CALayer` configured with the image content, frame, and initial opacity.
    /// - Precondition: `imageURL` must be a valid path to an image file. The file must be accessible and must be a valid image format.
    /// - Postcondition: Returns a `CALayer` with the image content set to the `contents` property if the image is loaded successfully; otherwise, the `contents` property remains `nil`. The `frame` and `cornerRadius` properties are also set according to the properties of the `ImageLayer`.
    override func toCAVideoLayer() throws -> CALayer {
        let caImageLayer = try CAImageLayer(
            imageURL: URL(fileURLWithPath: imageURL)
        )
        caImageLayer.cornerRadius = cornerRadius
        return try updateAttributes(for: caImageLayer)
    }
}

