//
//  LessonList.swift
//  Assignment
//
//  Created by Azamah Junior Khan on 17/01/2023.
//

import SwiftUI
struct LessonList: View {
    
    @StateObject private var viewModel = LessonsViewModel()
    @State private var path = NavigationPath()

    var body: some View {
        
        ZStack {
            Color("background").ignoresSafeArea()
            NavigationStack(path: $path) {
    
                ZStack {
                    if viewModel.isFetching {
                        ZStack {
                            Color("background")
                                .ignoresSafeArea()
                            
                            ProgressView()
                        }
                        
                    } else {
                        ScrollView(showsIndicators: false) {
                            ForEach(viewModel.lessons) { lesson in
                                NavigationLink(value: lesson) {
                                    LessonRow(lesson: lesson)
                                }

                            }
                            .navigationTitle("Lessons")
                        }
                        .ignoresSafeArea(edges: .bottom)
                        .navigationDestination(for: LessonObj.self) { lesson in
                            LessonDetail(lesson: lesson, path: $path, lessonsArray: viewModel.lessons)
                        }
                    }
                   
                }
                .task {
                    viewModel.fetchLessons()
                
                }
                .background(Color("background"))
            }

        }
        .preferredColorScheme(.dark)

    }
}

struct LessonList_Previews: PreviewProvider {
    static var previews: some View {
        LessonList()
    }
}
