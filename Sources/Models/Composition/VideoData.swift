//
//  VideoData.swift
//  quickvideoeditor
//
//  Created by Daniel Toranzo Pérez on 17/9/24.
//

import Foundation
import CoreGraphics

/// Represents the data required for a video composition, including scenes, text layers, image layers, and resolution video size.
///
/// This class holds collections of `VideoScene`, `TextLayer`, and `ImageLayer` objects, as well as the resolution size of the video.
class VideoData: Decodable {

    /// An array of audio tracks.
    let audioTracks: [AudioTrack]
    
    let videoTracks: [VideoTrack]
    
    /// An array of text layers to be included in the video.
    let textLayers: [TextLayer]

    /// An array of image layers to be included in the video.
    let imageLayers: [ImageLayer]

    /// The resolution of the video.
    let size: CGSize
    
    let duration: Double

    /**
     Combines the text layers and image layers into a single array of `VideoLayer`.
     - Returns: An array of `VideoLayer` objects combining `textLayers` and `imageLayers`.
     - Precondition: `textLayers` and `imageLayers` must be valid and not contain `nil` elements.
     - Postcondition: Returns an array of `VideoLayer` objects including all `TextLayer` and `ImageLayer` instances.
     */
    func getLayers() -> [VideoLayer] {
        textLayers + imageLayers
    }

    /**
     Initializes a new `VideoData` instance with specified parameters.
     - Parameters:
        - videoScenes: An array of `VideoScene` objects representing the scenes in the video.
        - textLayers: An array of `TextLayer` objects representing the text layers in the video.
        - imageLayers: An array of `ImageLayer` objects representing the image layers in the video.
        - size: The size of the video.
     - Precondition: `videoScenes`, `textLayers`, `imageLayers`, and `size` must be valid. `videoScenes` should have at least one valid item. `textLayers` and `imageLayers` can be empty but not `nil`. `size` must be a valid `CGSize`.
     - Postcondition: A `VideoData` instance is created with the provided parameters.
     */
    init(audioTracks: [AudioTrack], textLayers: [TextLayer], imageLayers: [ImageLayer], videoTracks: [VideoTrack], size: CGSize, duration: Double) {
        self.audioTracks = audioTracks
        self.textLayers = textLayers
        self.imageLayers = imageLayers
        self.videoTracks = videoTracks
        self.size = size
        self.duration = duration
    }
}

