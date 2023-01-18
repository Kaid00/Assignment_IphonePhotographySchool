//
//  LessonRow.swift
//  Assignment
//
//  Created by Azamah Junior Khan on 17/01/2023.
//

import SwiftUI

struct LessonRow: View {
    var lesson: LessonObj
    var body: some View {
        
        VStack {
            HStack {
                
                AsyncImage(url: URL(string: lesson.thumbnail)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    case .failure:
                        Image(systemName: "questionmark")
                            .frame(width: 120, height: 80)

                       default:
                        Image(systemName: "questionmark")
                            .frame(width: 120, height: 80)

                    }
                                        
                }
                .frame(width: 120, height: 80)
                .padding(.trailing, 8)

                Text(lesson.name)
                    .font(.callout)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                    .padding(.trailing)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.accentColor)

            }
            .padding()
            
            Divider()
                .frame(width: 260)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .preferredColorScheme(.dark)
        .background(Color("background"))
        
    }
}

struct LessonRow_Previews: PreviewProvider {
    static var previews: some View {
        LessonRow(lesson: mockLesson)
    }
}
