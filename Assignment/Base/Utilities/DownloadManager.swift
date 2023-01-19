//
//  DownloadManager.swift
//  Assignment
//
//  Created by Azamah Junior Khan on 18/01/2023.
//

import Foundation
import AVKit
import SwiftUI

final class DownloadManager: ObservableObject {
    @Published var isDownloading: Bool = false
    @Published var isDownloaded: Bool = false
    @Published var observation: NSKeyValueObservation?
    @Published private(set) var progress: Double = 0
    @Published private(set) var dataTask: URLSessionDataTask?
    
    func downloadFile(fileName: String, videoLink: String) {
        let formattedFileName = fileName.replacingOccurrences(of: " ", with: "_")

        isDownloading = true
        isDownloaded = false
        
        let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        
        let destinationUrl = docsUrl?.appendingPathComponent("\(formattedFileName).mp4")
        
        if let destinationUrl = destinationUrl {
            if FileManager().fileExists(atPath: destinationUrl.path) {
                #if DEBUG
                print("File already exists")
                #endif
                withAnimation{
                    isDownloading = false
                    isDownloaded = true
                }
             
            } else {
                #if DEBUG
                print("File is downloading")
                #endif

                let urlRequest = URLRequest(url: URL(string: videoLink)!)
                
                dataTask = URLSession.shared.dataTask(with: urlRequest) {(data, response, error) in
                    

                    if let error = error {
                        #if DEBUG
                        print("Request error:", error)
                        #endif
                        DispatchQueue.main.async {
                            withAnimation {
                                self.isDownloaded = false
                                self.isDownloading = false
                            }
                        }
                        return
                    }
                    
                    guard let response = response as? HTTPURLResponse else {return}

                    if response.statusCode == 200 {
                        #if DEBUG
                        print("File downloaded ")
                        #endif

                        guard let data = data else {
                            withAnimation {
                                self.isDownloading = false
                                self.isDownloaded = false
                            }
                           
                            return
                        }
                        
                        DispatchQueue.main.async {
                            do{
                                try data.write(to: destinationUrl, options: Data.WritingOptions.atomic)
                                DispatchQueue.main.async {
                                    withAnimation {
                                        self.isDownloaded = true
                                        self.isDownloading = false
                                    }
                               
                                }
                            }catch let error {
                                print("Error decoding:", error)
                                self.isDownloading = false
                                self.isDownloaded = false
                            }
                        }
                    }
                }
                
                self.observation = dataTask?.progress.observe(\.fractionCompleted) { observationProgress, _ in
                    
                    DispatchQueue.main.async {
                        self.progress = observationProgress.fractionCompleted
                    }
                    
                }
                dataTask?.resume()
                
                if !isDownloading {
                    dataTask?.cancel()
                    progress = 0
                }

            }
        }
    }
    
    
    func checkFileExist(fileName: String) {
        let formattedFileName = fileName.replacingOccurrences(of: " ", with: "_")
        let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        
        let destinationUrl = docsUrl?.appendingPathComponent("\(formattedFileName).mp4")
        if let destinationUrl = destinationUrl {
            if (FileManager().fileExists(atPath: destinationUrl.path())) {
                isDownloaded = true
            } else {
                isDownloaded = false
            }
        } else {
            isDownloaded = false
        }
    }
    
    func getVideoFileAsset(fileName: String) -> AVPlayerItem? {
        let formattedFileName = fileName.replacingOccurrences(of: " ", with: "_")

        let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first

        let destinationUrl = docsUrl?.appendingPathComponent("\(formattedFileName).mp4")
        if let destinationUrl = destinationUrl {
            if (FileManager().fileExists(atPath: destinationUrl.path())) {
                let avAsset = AVAsset(url: destinationUrl)
                return AVPlayerItem(asset: avAsset)
            } else {
                return nil
            }

        } else {
            return nil
        }
       
    }
    
    func reset() {
        dataTask?.cancel()
        self.progress = 0
    }
}
