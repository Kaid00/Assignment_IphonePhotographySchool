//
//  ImageRetriever.swift
//  Assignment
//
//  Created by Azamah Junior Khan on 18/01/2023.
//

import Foundation

struct ImageRetriever {
    func fetch(_ imgUrl: String) async throws -> Data {
        guard let url = URL(string: imgUrl) else {
            throw RetrieverError.invalidUrl
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
}

private extension ImageRetriever {
    enum RetrieverError: Error {
        case invalidUrl
    }
}
