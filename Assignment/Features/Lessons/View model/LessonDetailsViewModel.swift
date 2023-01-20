//
//  LessonDetailsViewModel.swift
//  Assignment
//
//  Created by Azamah Junior Khan on 20/01/2023.
//

import Foundation

class LessonDetailViewModel: ObservableObject {
    @Published var play: Bool = false
    @Published var islastLesson: Bool = false
    @Published var nextLessonIndex: Int = 0
    @Published var connected: Bool = true
    
    func goToNext(_ lessonsArray: [LessonObj], currentLesson: LessonObj) {
        if let ndx = lessonsArray.firstIndex(where: {$0.id == currentLesson.id}) {
            if ndx + 1 < lessonsArray.count {
                self.nextLessonIndex = ndx + 1
            } else {
                self.islastLesson = true
                
            }
        }
    }
    
}
