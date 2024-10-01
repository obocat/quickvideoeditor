//
//  app-main.swift
//  quickvideoeditor
//
//  Created by Daniel Toranzo Pérez on 17/9/24.
//

import Foundation
import ArgumentParser
import AVFoundation

@main
struct QuickVideoEditor: AsyncParsableCommand {
    @Option(name: [.long, .short], help: "QuickVideoEditor JSON project file path")
    var projectFileURLPath: String

    @Option(name: [.long, .short], help: "output file path")
    var outputFileURLPath: String
    
    @Option(name: [.customLong("overwrite")], help: "overwrite output file")
    var overwriteOutputFile: Bool = false

    func run() async throws {
        let projectFileURL = URL(fileURLWithPath: projectFileURLPath)
        let outputFileURL = URL(fileURLWithPath: outputFileURLPath)
        let data = try Data(contentsOf: projectFileURL)
        let videoData = try JSONDecoder().decode(VideoData.self, from: data)
        let core = QuickVideoEditorCore(
            videoData: videoData,
            outputFileURL: outputFileURL,
            overwriteOutputFile: overwriteOutputFile
        )
        try await core.createVideo()
    }
}
