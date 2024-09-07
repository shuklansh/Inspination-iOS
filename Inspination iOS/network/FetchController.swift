//
//  FetchController.swift
//  Inspination iOS
//
//  Created by Ansh Shukla on 07/09/24.
//

import Foundation

class FetchController {
    enum NetworkError: Error{
        case urlError, responseError
    }
    
    private let baseUrl = URL(string: "https://api.pexels.com/")!
    
    func fetchImages(for key: String) async throws -> PhotosResponse {
        let fetchUrl = baseUrl.appending(path: "v1/search")
        var fetchComponent = URLComponents(
            url: fetchUrl,
            resolvingAgainstBaseURL: true
        )
        
        let queryComponent = URLQueryItem(name: "query", value: key.replaceSpaceWithPlus)
        let pageCountComponent = URLQueryItem(name: "page", value: "1")
        let perPageComponent = URLQueryItem(name: "per_page", value: "50")
        
        fetchComponent?.queryItems = [queryComponent, pageCountComponent, perPageComponent]
        
        guard let finalFetchUrl = fetchComponent?.url else {
            throw NetworkError.urlError
        }
        
        var request = URLRequest(url: finalFetchUrl)
        request.httpMethod = "GET"
        
        // Add any necessary headers here
        request.setValue("YOUR_API_KEY", forHTTPHeaderField: "Authorization")
        // Add other headers if needed

        // Use URLSession.shared.data(for:) with URLRequest
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.responseError
        }
        
        let photosList = try JSONDecoder().decode(PhotosResponse.self, from: data)
        return photosList
    }
    
}
