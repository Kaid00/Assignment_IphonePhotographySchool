//
//  lessonDetailRepresentable.swift
//  Assignment
//
//  Created by Azamah Junior Khan on 20/01/2023.
//

import Foundation
import SwiftUI

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

