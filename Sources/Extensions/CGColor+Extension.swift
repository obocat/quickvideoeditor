//
//  CGColor+Extension.swift
//  quickvideoeditor
//
//  Created by Daniel Toranzo Pérez on 16/9/24.
//

import Foundation
import CoreGraphics

extension CGColor {
    
    public static func from(hex: String) -> CGColor? {
        // Remove any leading "#" from the hex string
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexString.hasPrefix("#") {
            hexString.removeFirst()
        }

        // Ensure the string is the correct length (6 or 8 characters)
        guard hexString.count == 6 || hexString.count == 8 else {
            return nil
        }

        // Convert the hex string to an integer
        var rgb: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgb)

        // Extract the color components
        let red = CGFloat((rgb >> 16) & 0xFF) / 255.0
        let green = CGFloat((rgb >> 8) & 0xFF) / 255.0
        let blue = CGFloat(rgb & 0xFF) / 255.0
        let alpha = hexString.count == 8 ? CGFloat((rgb >> 24) & 0xFF) / 255.0 : 1.0

        // Create and return the CGColor
        return CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [red, green, blue, alpha])
    }
    
}
