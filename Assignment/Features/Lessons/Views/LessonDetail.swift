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
    @Binding var path: NavigationPath
    var lessonsArray: [LessonObj]
    
    @StateObject var viewModel = LessonDetailViewModel()
    @ObservedObject var networkMonitor = NetworkMonitor()
    @StateObject var downloadManager = DownloadManager()    
    @State var connected: Bool = true
    
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color("background")
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    
                    VideoPlayer(
                        play: $viewModel.play,
                        video: lesson.video_url,
                        online: $networkMonitor.isConnected,
                        playerItem: downloadManager.getVideoFileAsset(fileName: lesson.name)
                    )
                    .frame(height: UIDevice.current.orientation.isLandscape ? geo.size.height / 3 : geo.size.height / 3)
                    .overlay {
                        if !viewModel.play { thumbnail }
                    }
                    
                    lessonDetailRepresentable(lesson: lesson)
                    
                    nextLessonBtn
  
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
                                    ProgressView(value: downloadManager.progress, total: 1)
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

            viewModel.goToNext(lessonsArray, currentLesson: lesson)
        }
        .onDisappear {
            viewModel.play = false
        }
        
    }
    var nextLessonBtn: some View {
        Button {
            if !viewModel.islastLesson {
                path.append(lessonsArray[viewModel.nextLessonIndex])
            } else {
                path.removeLast(path.count)
            }
            
        } label: {
            if !viewModel.islastLesson {
                HStack {
                    Text("Next lesson")
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.accentColor)
                }
            } else {
                HStack {
                    Text("Back to lessons")
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.accentColor)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.trailing, 24)
        .offset(y: -50)
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
                
                viewModel.play = true
            }
        }
        
    }
}

struct LessonDetail_Previews: PreviewProvider {
    static var previews: some View {
        LessonDetail(lesson: mockLesson, path: .constant(NavigationPath()), lessonsArray: mockLessonArray)
    }
}



