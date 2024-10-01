//
//  TextLayer.swift
//  quickvideoeditor
//
//  Created by Daniel Toranzo Pérez on 17/9/24.
//

import Foundation
import Cocoa
import SwiftUI

/// Represents a text layer that can be added to a video composition.
///
/// This class encapsulates properties and methods to create a text layer for video composition.
class TextLayer: VideoLayer {
    
    enum CodingKeys: String, CodingKey {
        case text
        case textColor
        case fontSize
    }
            
    /// The text content to be displayed.
    let text: String

    /// The color of the text in hexadecimal format.
    let textColor: String

    /// The font size of the text.
    let fontSize: CGFloat
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.text = try container.decode(String.self, forKey: .text)
        self.textColor = try container.decode(String.self, forKey: .textColor)
        self.fontSize = try container.decode(CGFloat.self, forKey: .fontSize)
        try super.init(from: decoder)
    }
    
    /// Converts the hexadecimal text color to a SwiftUI color.
    /// - Returns: A `CGColor` representing the text color.
    /// - Precondition: `textColor` must be a valid hexadecimal color string.
    /// - Postcondition: Returns a `CGColor` with the specified color or `.clear` color if `textColor` is invalid.
    func toTextColor() -> CGColor {
        CGColor.from(hex: textColor) ?? .clear
    }

    /// Converts this `TextLayer` to a `CALayer` suitable for rendering text.
    /// - Returns: A `CATextLayer` configured with the text, font size, color, and frame.
    /// - Precondition: The `text`, `fontSize`, and `frame` properties must be valid.
    /// - Postcondition: Returns a `CATextLayer` with `string`, `fontSize`, `foregroundColor`, `alignmentMode`, and `frame` set according to the properties of the `TextLayer`.
    override func toCAVideoLayer() throws -> CALayer {
        let caTextLayer = CATextLayer()
        caTextLayer.string = text
        caTextLayer.fontSize = fontSize
        caTextLayer.foregroundColor = toTextColor()
        caTextLayer.alignmentMode = .center
        return try updateAttributes(for: caTextLayer)
    }

}
