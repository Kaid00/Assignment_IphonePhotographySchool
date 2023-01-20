//
//  LessonDetail.swift
//  Assignment
//
//  Created by Azamah Junior Khan on 17/01/2023.
//

import SwiftUI
import AVKit

struct LessonDetail: View {
    var lesson: LessonObj
    private let total: Double = 1
    @ObservedObject var networkMonitor = NetworkMonitor()
    @StateObject var downloadManager = DownloadManager()
    @State var player = AVPlayer()
    @State private var play: Bool = false
    @State private var progress: Double = 0.11
    
    @State private var nextLesson: Bool = false
    @State var connected: Bool = true
    
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color("background")
                    .ignoresSafeArea()
                   
                VStack(spacing: 0) {
                   
                    VideoPlayer(
                        play: $play,
                        video: lesson.video_url,
                        online: $networkMonitor.isConnected,
                        playerItem: downloadManager.getVideoFileAsset(fileName: lesson.name)
                    )
                        .frame(height: UIDevice.current.orientation.isLandscape ? geo.size.height / 3 : geo.size.height / 3)
                        .overlay {
                            if !play { thumbnail }
                        }
                    
                    lessonDetailRepresentable(lesson: lesson)
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        if !networkMonitor.isConnected || !connected {
                            HStack(spacing: 6) {
                                ProgressView()
                                Text("Connecting...")
                                    .font(.caption2)
                            }
                        }
                       
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        if !downloadManager.isDownloaded && !downloadManager.isDownloading{
                            Button {
                                withAnimation {
                                    downloadManager.isDownloading = true
                                    downloadManager.downloadFile(fileName: lesson.name, videoLink: lesson.video_url)
                                }
                            } label: {
                                HStack {
                                    Image(systemName: "icloud.and.arrow.down")
                                    Text("Download")
                                }
                                .font(.callout)
                                
                            }
                        } else if !downloadManager.isDownloaded && downloadManager.isDownloading {
                            Button {
                                withAnimation {
                                    downloadManager.isDownloading = false
                                    downloadManager.reset()
                                }
                            } label: {
                                HStack {
                                    ProgressView(value: downloadManager.progress, total: total)
                                        .progressViewStyle(GaugeProgressStyle())
                                        .frame(width: 18, height: 18)
                                        .contentShape(Rectangle())
                                        .padding()
                                    
                                    Text("Cancel download")
                                }

                            }
                        }
                        else {
                            Button {
                                withAnimation {
                                }
                            } label: {
                                HStack {
                                    Image(systemName: "checkmark.icloud")

                                    Text("Downloaded")
                                }

                            }
                        }
                        
                        
                    }
                }
                
                .onTapGesture {
                    connected = NetworkMonitor().isConnected
                }
                
            }
         
        }
        .onAppear {
            downloadManager.checkFileExist(fileName: lesson.name)
            
        }
   
    }
    
    var thumbnail: some View {
        ZStack {
            AsyncCacheImage(url: lesson.thumbnail) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure(_):
                    Image(systemName: "questionmark")
                        .frame(width: 120, height: 80)
                @unknown default:
                    EmptyView()
                
                }
                
            }
            
            Color.black.opacity(0.3)
            
            Image(systemName: "play.fill")
                .font(.system(size: 60))
                .foregroundColor(.white).opacity(0.9)
            
        }
        .onTapGesture {
            withAnimation {
                
                play = true
            }
        }

    }
}

struct LessonDetail_Previews: PreviewProvider {
    static var previews: some View {
        LessonDetail(lesson: mockLesson)
    }
}

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
            
        }
    
    }
}



struct lessonDetailRepresentable: UIViewRepresentable {
    var lesson: LessonObj
    
    func makeUIView(context: Context) -> Details {
        let view = Details()
        view.configure(with: LessonObj(
            id: lesson.id,
            name: lesson.name,
            description: lesson.description,
            thumbnail: lesson.thumbnail,
            video_url: lesson.video_url)
        )        
        return view
    }
    
    func updateUIView(_ uiView: Details, context: Context) {
        //
    }
}


