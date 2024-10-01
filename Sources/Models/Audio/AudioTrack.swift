//
//  AudioTrack.swift
//  quickvideoeditor
//
//  Created by Daniel Toranzo Pérez on 18/9/24.
//


class AudioTrack: Decodable {
    /// The file URL of the audio.
    let audioURL: String
    
    /// The start time of the audio.
    let startTime: Double
    
    /// The duration of the audio track in seconds.
    let duration: Double
}
