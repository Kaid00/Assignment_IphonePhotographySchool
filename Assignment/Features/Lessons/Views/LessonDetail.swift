//
//  LessonDetail.swift
//  Assignment
//
//  Created by Azamah Junior Khan on 17/01/2023.
//

import SwiftUI
import AVKit

struct LessonDetail: View {
    @State var player = AVPlayer()
    var lesson: LessonObj
    @State var play: Bool = false
    @State var downloadingVideo: Bool = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color("background")
                    .ignoresSafeArea()
                VStack(spacing: 0) {
                    
                    VideoPlayer(play: $play, video: lesson.video_url)
                        .frame(height: UIDevice.current.orientation.isLandscape ? geo.size.height / 3 : geo.size.height / 3)
                        .overlay {
                            if !play { thumbnail }
                        }
                    
                    lessonDetailRepresentable(lesson: lesson)
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        if !downloadingVideo {
                            Button {
                                withAnimation {
                                    downloadingVideo = true
                                }
                            } label: {
                                HStack {
                                    Image(systemName: "icloud.and.arrow.down")
                                    Text("Download")
                                }
                                .font(.callout)

                            }
                        } else {
                            Button {
                                withAnimation {
                                    downloadingVideo = false
                                }
                            } label: {
                                HStack {
                                    ProgressView()
                                        .padding(.trailing, 10)
                                    Text("Cancel download")
                                }

                            }
                        }
                        
                        
                    }
                }
                
            }
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
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<VideoPlayer>) -> AVPlayerViewController {
        
        let player1 = AVPlayer(url: URL(string: video)!)
        
        let controller = AVPlayerViewController()
        controller.player = player1
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
