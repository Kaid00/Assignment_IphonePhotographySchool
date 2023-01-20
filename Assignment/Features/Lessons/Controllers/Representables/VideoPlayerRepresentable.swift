//
//  VideoPlayerRepresentable.swift
//  Assignment
//
//  Created by Azamah Junior Khan on 20/01/2023.
//

import Foundation
import SwiftUI
import AVKit

struct VideoPlayer : UIViewControllerRepresentable {
    @Binding var play: Bool
    var video: String
    @Binding var online: Bool
    var playerItem: AVPlayerItem?
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<VideoPlayer>) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        
        if playerItem != nil {
            let player = AVPlayer(playerItem: playerItem)
            controller.player = player
        } else {
            let player1 = AVPlayer(url: URL(string: video)!)
            controller.player = player1
        }
        controller.showsPlaybackControls = true
        controller.videoGravity = .resize
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: UIViewControllerRepresentableContext<VideoPlayer>) {
        if play {
            uiViewController.player?.play()
            
        } else {
            uiViewController.player?.rate = 0
        }
        
    }
}
