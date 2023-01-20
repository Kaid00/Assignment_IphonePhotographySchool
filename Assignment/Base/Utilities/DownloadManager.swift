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
    
    func formatFileName(name: String) -> String{
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let formattedName = trimmed.replacingOccurrences(of: " ", with: "_")
        
        return formattedName
        
    }
    func downloadJSON(data: Data) {
        let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let destinationUrl = docsUrl?.appendingPathComponent("localLessonsData")

        if let destinationUrl = destinationUrl {
            if FileManager().fileExists(atPath: destinationUrl.path) {
                do {
                    try FileManager().removeItem(atPath: destinationUrl.path)
                    DispatchQueue.main.async {
                        do{
                            try data.write(to: destinationUrl, options: Data.WritingOptions.atomic)
                        } catch let error {
                            print("Error writing json:", error)
                        }
                    }
                } catch let error {
                    print("Error while deleting video file:", error)
                }
             
                
            } else {
                DispatchQueue.main.async {
                    do{
                        try data.write(to: destinationUrl, options: Data.WritingOptions.atomic)
                    #if DEBUG
                    print("File saved")
                    #endif
                    }catch let error {
                        
                        print("Error writing json:", error)
                    }
                }
            }
        }
    }
    
  
    func downloadFile(fileName: String, videoLink: String) {
        let formattedFileName = formatFileName(name: fileName)

        isDownloading = true
        isDownloaded = false
        
        let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        
        let destinationUrl = docsUrl?.appendingPathComponent("\(formattedFileName).mp4")
        
        if let destinationUrl = destinationUrl {
            if FileManager().fileExists(atPath: destinationUrl.path) {
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
        let formattedFileName = formatFileName(name: fileName)
        let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        
        let destinationUrl = docsUrl?.appendingPathComponent("\(formattedFileName).mp4")
        if let destinationUrl = destinationUrl {
            if (FileManager().fileExists(atPath: destinationUrl.path)) {
                isDownloaded = true
            } else {
                isDownloaded = false
            }
        } else {
            isDownloaded = false
        }
    }
    
    func getVideoFileAsset(fileName: String) -> AVPlayerItem? {
        let formattedFileName = formatFileName(name: fileName)

        let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first

        let destinationUrl = docsUrl?.appendingPathComponent("\(formattedFileName).mp4")
        if let destinationUrl = destinationUrl {
            if (FileManager().fileExists(atPath: destinationUrl.path)) {
                let avAsset = AVAsset(url: destinationUrl)
                return AVPlayerItem(asset: avAsset)
            } else {
                return nil
            }

        } else {
            return nil
        }
       
    }
    
    func getLocalLessons() -> [LessonObj] {
        var localLessons = [LessonObj]()
        let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        
        let destinationUrl = docsUrl?.appendingPathComponent("localLessonsData")

        if let destinationUrl = destinationUrl {
            if (FileManager().fileExists(atPath: destinationUrl.path)) {
                do {
                    let value = try Data(contentsOf: destinationUrl)
                    localLessons = try JSONDecoder().decode(Lesson.self, from: value).lessons
                } catch {
                }
            } else {
            }
        }
        return localLessons

    }
    
    func reset() {
        dataTask?.cancel()
        self.progress = 0
    }
}
