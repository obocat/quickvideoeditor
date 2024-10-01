//
//  QuickVideoEditorCore.swift
//  quickvideoeditor
//
//  Created by Daniel Toranzo Pérez on 17/9/24.
//

import AppKit
import Foundation
@preconcurrency import AVFoundation

actor QuickVideoEditorCore {
    let videoData: VideoData
    let outputFileURL: URL
    let overwriteOutputFile: Bool

    /// Initializes a `QuickVideoEditorCore` with the provided video data and output settings.
    /// - Parameters:
    ///     - videoData: The data representing the video to be edited.
    ///     - outputFileURL: The URL where the edited video will be saved.
    ///     - overwriteOutputFile: A Boolean indicating whether to overwrite the output file if it already exists.
    init(videoData: VideoData, outputFileURL: URL, overwriteOutputFile: Bool) {
        self.videoData = videoData
        self.outputFileURL = outputFileURL
        self.overwriteOutputFile = overwriteOutputFile
    }
    
    /// Creates the final video by composing tracks and exporting the result.
    /// - Throws: An error if the composition or export process fails.
    public func createVideo() async throws {
        let composition = try await createComposition()
        let layers = try createCALayers()
        let videoComposition = try createVideoComposition(
            to: composition,
            videoLayer: layers.0,
            parentLayer: layers.1
        )
        try await export(composition: composition, videoComposition: videoComposition)
    }
}

private extension QuickVideoEditorCore {
    
    /// Creates an `AVMutableComposition` by inserting all audio and video tracks from `videoData`.
    /// - Throws: An error if any track cannot be inserted into the composition.
    /// - Returns: An `AVMutableComposition` containing all the inserted tracks.
    func createComposition() async throws -> AVMutableComposition {
        let composition = AVMutableComposition()
        for audioTrack in videoData.audioTracks {
            try await insert(audioTrack: audioTrack, into: composition)
        }
        
        for videoTrack in videoData.videoTracks {
            try await insert(videoTrack: videoTrack, into: composition)
        }
        return composition
    }
    
    /// Inserts a `VideoTrack` into the given `AVMutableComposition`.
    /// - Parameters:
    ///     - videoTrack: The video track to be inserted.
    ///     - composition: The composition into which the video track will be inserted.
    /// - Throws: An error if the video track cannot be inserted.
    func insert(videoTrack: VideoTrack, into composition: AVMutableComposition) async throws {
        let compositionVideoLayer = composition.addMutableTrack(
            withMediaType: .video,
            preferredTrackID: kCMPersistentTrackID_Invalid
        )
        let videoURL = URL(fileURLWithPath: videoTrack.videoURL)
        let videoAsset = AVURLAsset(url: videoURL)
        if let assetVideoTrack = try await videoAsset.loadTracks(withMediaType: .video).first {
            videoTrack.naturalSize = try await assetVideoTrack.load(.naturalSize)
            let layerDuration = CMTime(seconds: videoTrack.duration, preferredTimescale: 600)
            let playbackOffset = CMTime(seconds: videoTrack.playbackOffset, preferredTimescale: 600)
            let startTime = CMTime(
                seconds: videoTrack.startTime,
                preferredTimescale: 600
            )
            let videoAssetRange = CMTimeRange(
                start: playbackOffset,
                duration: layerDuration
            )
            try compositionVideoLayer?.insertTimeRange(
                videoAssetRange,
                of: assetVideoTrack,
                at: startTime
            )
        }
    }
    
    /// Inserts an `AudioTrack` into the given `AVMutableComposition`.
    /// - Parameters:
    ///     - audioTrack: The audio track to be inserted.
    ///     - composition: The composition into which the audio track will be inserted.
    /// - Throws: An error if the audio track cannot be inserted.
    func insert(audioTrack: AudioTrack, into composition: AVMutableComposition) async throws {
        let compositionAudioTrack = composition.addMutableTrack(
            withMediaType: .audio,
            preferredTrackID: kCMPersistentTrackID_Invalid
        )
        let audioURL = URL(fileURLWithPath: audioTrack.audioURL)
        let audioAsset = AVURLAsset(url: audioURL)
        let startTime = CMTime(
            seconds: audioTrack.startTime,
            preferredTimescale: 600
        )
        let duration = CMTime(
            seconds: audioTrack.duration,
            preferredTimescale: 600
        )
        var timeRange = CMTimeRange(
            start: CMTime.zero,
            duration: duration
        )
        if let assetAudioTrack = try await audioAsset.loadTracks(withMediaType: .audio).first {
            if audioTrack.duration == -1 {
                timeRange = try await assetAudioTrack.load(.timeRange)
            }
            try compositionAudioTrack?.insertTimeRange(
                timeRange,
                of: assetAudioTrack,
                at: startTime
            )
        }
    }
    
    /// Creates an `AVVideoComposition` with the specified video and parent layers.
    /// - Parameters:
    ///     - composition: The composition containing the video tracks.
    ///     - videoLayer: The layer where video content is rendered.
    ///     - parentLayer: The parent layer containing all video and animation layers.
    /// - Throws: An error if the video composition cannot be created.
    /// - Returns: An `AVVideoComposition` configured with the provided layers.
    func createVideoComposition(to composition: AVMutableComposition, videoLayer: CALayer, parentLayer: CALayer) throws -> AVVideoComposition {
        let videoComposition = AVMutableVideoComposition()
        videoComposition.renderSize = videoData.size
        videoComposition.frameDuration = CMTime(value: 1, timescale: 30)
        let videoTracks = composition.tracks(withMediaType: .video)
        var instructions: [any AVVideoCompositionInstructionProtocol] = []
        
        for (index, videoLayer) in self.videoData.videoTracks.enumerated() {
            let videoCompositionInstruction = AVMutableVideoCompositionInstruction()
            let videoLayerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTracks[index])
            let videoDuration = CMTime(seconds: videoLayer.duration, preferredTimescale: 600)
            let videoStartTime = CMTime(seconds: videoLayer.startTime, preferredTimescale: 600)
            videoCompositionInstruction.timeRange = CMTimeRange(start: videoStartTime, duration: videoDuration)
            
            let videoWidth = videoLayer.naturalSize!.width
            let videoHeight = videoLayer.naturalSize!.height
            let containerWidth = videoLayer.frame.width
            let containerHeight = videoLayer.frame.height
            let scaleY = containerHeight / videoHeight
            let scaleTransform = CGAffineTransform(scaleX: scaleY, y: scaleY)
            let videoScaledWidth = videoWidth * scaleY
            let translationX = (containerWidth - videoScaledWidth) / 2
            let translationTransform = CGAffineTransform(translationX: translationX, y: videoLayer.frame.origin.y)
            let finalTransform = scaleTransform.concatenating(translationTransform)
            videoLayerInstruction.setTransform(finalTransform, at: .zero)
            
            videoCompositionInstruction.layerInstructions = [videoLayerInstruction]
            instructions.append(videoCompositionInstruction)
        }
 
        videoComposition.instructions = instructions
        videoComposition.animationTool = AVVideoCompositionCoreAnimationTool(
            postProcessingAsVideoLayer: videoLayer,
            in: parentLayer
        )
        return videoComposition
    }
    
    /// Creates the video and parent layers for video composition.
    /// - Throws: An error if any layer cannot be created or configured.
    /// - Returns: A tuple containing the video layer and the parent layer.
    func createCALayers() throws -> (CALayer, CALayer) {
        let parentLayer = CALayer()
        parentLayer.frame = CGRect(origin: .zero, size: videoData.size)
        let videoLayer = CALayer()
        videoLayer.frame = CGRect(origin: .zero, size: videoData.size)
       
        for layer in videoData.getLayers() {
            let caLayer = try layer.toCAVideoLayer()
            caLayer.setNeedsDisplay()
            caLayer.displayIfNeeded()
            parentLayer.addSublayer(caLayer)
            caLayer.applyAnimations(with: layer)
        }
        
        parentLayer.addSublayer(videoLayer)
        return (videoLayer, parentLayer)
    }
    
    /// Deletes the file at the specified URL if it exists.
    /// - Parameters:
    ///     - url: The URL of the file to be deleted.
    /// - Throws: An error if the file cannot be deleted.
    func deleteFile(at url: URL) throws {
        if FileManager.default.fileExists(atPath: outputFileURL.path) {
            try FileManager.default.removeItem(at: outputFileURL)
        }
    }

    /// Exports the video composition to the output file URL.
    /// - Parameters:
    ///     - composition: The composition to be exported.
    ///     - videoComposition: The video composition to be applied during export.
    /// - Throws: An error if the export process fails.
    func export(composition: AVMutableComposition, videoComposition: AVVideoComposition) async throws {
        if overwriteOutputFile {
            try deleteFile(at: outputFileURL)
        }
        let exportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality)
        let audioMix = AVMutableAudioMix()
        let inputAudioParameters = composition.tracks(withMediaType: .audio).map {
            let inputParameter = AVMutableAudioMixInputParameters(track: $0)
            return inputParameter
        }
        audioMix.inputParameters = inputAudioParameters
        exportSession?.audioMix = audioMix
        exportSession?.videoComposition = videoComposition
        try await exportSession?.export(to: outputFileURL, as: .mp4)
    }
    
}
