//
//  CALayer+Extension.swift
//  quickvideoeditor
//
//  Created by Daniel Toranzo Pérez on 16/9/24.
//

import Foundation
import QuartzCore
import AVFoundation

extension CALayer {

    /// Applies fade-in and fade-out animations to the layer based on the provided `VideoLayer` settings.
    /// - Parameter layer: An instance of `VideoLayer` containing the animation parameters.
    /// - Precondition: The `layer` parameter must be a valid `VideoLayer` instance with properly configured `startTime`, `fadeInDuration`, `fadeOutDuration` and `layerEndTime`.
    /// - Postcondition: A fade-in and fade-out animations are added to the layer
    func applyAnimations(with layer: VideoLayer) {
        // CABasicAnimation: FadeIn
        if layer.fadeInDuration > 0 {
            let fadeInAnimation = CABasicAnimation(keyPath: "opacity")
            fadeInAnimation.fromValue = 0
            fadeInAnimation.toValue = 1
            fadeInAnimation.beginTime = layer.startTime == 0 ? AVCoreAnimationBeginTimeAtZero : layer.startTime
            fadeInAnimation.duration = layer.fadeInDuration
            fadeInAnimation.fillMode = .forwards
            fadeInAnimation.isRemovedOnCompletion = false
            add(fadeInAnimation, forKey: "fadeIn")
        }

        // CABasicAnimation: FadeOut
        let fadeOutAnimation = CABasicAnimation(keyPath: "opacity")
        fadeOutAnimation.fromValue = 1
        fadeOutAnimation.toValue = 0
        fadeOutAnimation.beginTime = layer.layerEndTime
        fadeOutAnimation.duration = layer.fadeOutDuration
        fadeOutAnimation.fillMode = .forwards
        fadeOutAnimation.isRemovedOnCompletion = false
        add(fadeOutAnimation, forKey: "fadeOut")
    }

}
