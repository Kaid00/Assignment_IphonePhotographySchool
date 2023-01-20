//
//  LessonsViewModel.swift
//  Assignment
//
//  Created by Azamah Junior Khan on 17/01/2023.
//

import Foundation
import Combine

final class LessonsViewModel: ObservableObject {
    
    private var downloadManager = DownloadManager()
    @Published var lessons = [LessonObj]()
    @Published var errorOccurred: Bool = false
    @Published var error: LessonError?
    @Published private(set) var isFetching: Bool = false
    
    private var bag = Set<AnyCancellable>()
    
    func fetchLessons() {
        let lessonsUrlString = "https://iphonephotographyschool.com/test-api/lessons"

        if let url = URL(string: lessonsUrlString) {
            isFetching = true
            URLSession.shared.dataTaskPublisher(for: url)
                .receive(on: DispatchQueue.main)
                .tryMap({ res in
                    
                    guard let response = res.response as? HTTPURLResponse,
                          response.statusCode >= 200 && response.statusCode <= 300 else {

                       
                        throw LessonError.invalidStatusCode
                    }
                    
                    guard let lessons = try? JSONDecoder().decode(Lesson.self, from: res.data) else {
                        throw LessonError.failedToDecode
                    }
                    
                    self.downloadManager.downloadJSON(data: res.data)

                    
                    return lessons.lessons
                })
                .sink { [weak self] res in
                    
                    defer{ self?.isFetching = false }
                    
                    switch res {
                    case .failure(let error):
                        self?.errorOccurred = true
                        self?.error = LessonError.custom(error: error)
                        self?.fetchLocalLessons()
                    default: break
                    }
                    
                } receiveValue: { [weak self] lesson in
                    self?.lessons = lesson
                }
                .store(in: &bag)
        }
    }
    
    func fetchLocalLessons() {
        self.lessons =  self.downloadManager.getLocalLessons()
        
    }
    
}

extension LessonsViewModel {
    enum LessonError: LocalizedError {
        case custom(error: Error)
        case failedToDecode
        case invalidStatusCode
        
        var errorDescription: String? {
            switch self {
            case .failedToDecode:
                return "Failed to decode response"
            case .custom(let error):
                return error.localizedDescription
            case .invalidStatusCode:
            return "Request falls within an invalid range"
            }
            
            
        }
    }
}
