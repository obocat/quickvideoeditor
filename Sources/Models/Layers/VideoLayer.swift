//
//  VideoLayer.swift
//  quickvideoeditor
//
//  Created by Daniel Toranzo Pérez on 17/9/24.
//

import Foundation
import QuartzCore

/// A class that defines the properties and methods required for video layers.
///
/// Any type conforming to `VideoLayer` must provide the start time, duration, fade-in/fade-out durations,
/// frame dimensions, and a method to convert itself into a `CALayer`.
class VideoLayer: Codable {
    
    /// The start time of the video layer in seconds.
    var startTime: Double

    /// The duration for which the video layer is visible in seconds.
    var duration: Double

    /// The duration of the fade-in effect in seconds.
    var fadeInDuration: Double

    /// The duration of the fade-out effect in seconds.
    var fadeOutDuration: Double

    /// The frame of the video layer in the video.
    var frame: CGRect
    
    /// The zIndex of the video layer.
    var zIndex: Int

    /// Converts this `VideoLayer` to a `CALayer` suitable for rendering.
    /// - Returns: A `CALayer` representing the video layer.
    /// - Postcondition: Returns a `CALayer` configured according to the properties of the `VideoLayer`.
    func updateAttributes(for caLayer: CALayer) throws -> CALayer {
        caLayer.frame = frame
        caLayer.zPosition = CGFloat(zIndex)
        caLayer.opacity = fadeInDuration == 0 ? 1 : 0
        return caLayer
    }
    
    func toCAVideoLayer() throws -> CALayer {
        return CALayer()
    }
}

extension VideoLayer {

    /// Calculates the end time of the video layer's visibility.
    /// - Returns: The end time of the video layer in seconds.
    /// - Precondition: `startTime` and `duration` must be valid values.
    /// - Postcondition: Returns a `Double` representing the end time of the video layer.
    var layerEndTime: Double {
        startTime + duration
    }

}
