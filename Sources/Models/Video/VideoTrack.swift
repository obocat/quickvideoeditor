//
//  VideoTrack.swift
//  quickvideoeditor
//
//  Created by Daniel Toranzo Pérez on 30/9/24.
//

import Foundation
import QuartzCore
import AppKit

class VideoTrack: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case startTime
        case duration
        case frame
        case videoURL
        case filter
        case playbackOffset
    }
    
    let startTime: Double
    let duration: Double
    let frame: CGRect
    /// The file URL of the video for this scene.
    let videoURL: String
    let playbackOffset: Double
    
    @CodableIgnored
    var naturalSize: CGSize?
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.startTime = try container.decode(Double.self, forKey: .startTime)
        self.duration = try container.decode(Double.self, forKey: .duration)
        self.frame = try container.decode(CGRect.self, forKey: .frame)
        self.videoURL = try container.decode(String.self, forKey: .videoURL)
        self.playbackOffset = try container.decode(Double.self, forKey: .playbackOffset)
    }
    
}

