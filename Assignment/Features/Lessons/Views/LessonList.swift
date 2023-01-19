//
//  LessonList.swift
//  Assignment
//
//  Created by Azamah Junior Khan on 17/01/2023.
//

import SwiftUI

struct LessonList: View {
    
    @StateObject private var viewModel = LessonsViewModel()

    var body: some View {
        
        ZStack {
            Color("background").ignoresSafeArea()
            NavigationView {
                
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
                                NavigationLink {
                                    LessonDetail(lesson: lesson)
                                } label: {
                                    LessonRow(lesson: lesson)
                                }
                            }
                            .navigationTitle("Lessons")
                        }
                        .ignoresSafeArea(edges: .bottom)
                    }
                   
                }
                .task {viewModel.fetchLessons()}
                .alert(isPresented: $viewModel.errorOccurred, error: viewModel.error) {
                    Button{
                        viewModel.fetchLessons()
                    } label: {
                        Text("Retry")
                    }
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
