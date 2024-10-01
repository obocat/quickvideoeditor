//
//  CAImageLayer.swift
//  quickvideoeditor
//
//  Created by Daniel Toranzo Pérez on 17/9/24.
//

import QuartzCore

/// A subclass of `CALayer` that displays a `CGImage` as its content.
///
/// This class is initialized with a URL pointing to an image file, and it will load the image from the URL and set it as the content of the layer.
class CAImageLayer: CALayer {

    /// The `CGImage` to be displayed by this layer.
    let image: CGImage
    
    /// Initializes a `CAImageLayer` with the image located at the specified URL.
    /// - Parameters:
    ///     - imageURL: The URL pointing to the image file.
    /// - Throws: An error if the image cannot be loaded or processed.
    /// - Precondition: The `imageURL` must be a valid URL that points to an image file that can be processed into a `CGImage`.
    /// - Postcondition: The `image` property is set to the `CGImage` created from the image file located at the `imageURL`.
    init(imageURL: URL) throws {
        self.image = try CGImage.processImage(from: imageURL)
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func display() {
        contents = image
    }
}

