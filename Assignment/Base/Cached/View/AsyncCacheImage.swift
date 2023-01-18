//
//  CachedImage.swift
//  Assignment
//
//  Created by Azamah Junior Khan on 18/01/2023.
//

import SwiftUI

struct AsyncCacheImage<Content: View>: View {
    
    @StateObject private var manager = CachedImageManager()
    
    let url: String
    let animation: Animation?
    let transition: AnyTransition
    let content: (AsyncImagePhase) -> Content

    init(
        url: String,
        animation: Animation? = nil,
        transition: AnyTransition = .identity,
        @ViewBuilder content: @escaping (AsyncImagePhase) -> Content) {
            
        self.url = url
        self.animation = animation
        self.transition = transition
        self.content = content
    }
    
    var body: some View {
         ZStack {
            switch manager.currentState {
            case .loading:
                content(.empty)
                    .transition(transition)
            case .success(let data):
                if let image = UIImage(data: data) {
                    content(.success(Image(uiImage: image)))
                        .transition(transition)

                } else {
                    content(.failure(CachedImageError.invalidData))
                        .transition(transition)

                }
            case .failed(let error):
                content(.failure(error))
                    .transition(transition)

            default:
                content(.empty)
                    .transition(transition)

            }
        }
        .animation(animation, value: manager.currentState)
        .task {
            await manager.load(url)
        }
    }
}

struct CachedImage_Previews: PreviewProvider {
    static var previews: some View {
        AsyncCacheImage(url: mockLesson.thumbnail) {_ in
            EmptyView() }
    }
}


extension AsyncCacheImage {
    enum CachedImageError: Error {
        case invalidData
    }
}
