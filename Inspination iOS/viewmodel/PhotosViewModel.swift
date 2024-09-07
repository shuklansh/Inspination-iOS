//
//  PhotosViewModel.swift
//  Inspination iOS
//
//  Created by Ansh Shukla on 07/09/24.
//

import Foundation

@MainActor
class PhotosViewModel: ObservableObject {
    enum Status {
        case SUCCESS(data: PhotosResponse)
        case FAILURE(error: Error)
        case LOADING
        case NOT_INITIATED
    }
    
    @Published private(set) var status: Status = .NOT_INITIATED
    
    private let controller: FetchController
    
    init(controller: FetchController) {
        self.controller = controller
    }
    
    func fetchImagesForQuery(for query: String) async {
        status = .LOADING
        do {
            let dataForQuery = try await controller.fetchImages(for: query)
            status = .SUCCESS(data: dataForQuery)
        } catch {
            status = .FAILURE(error: error)
        }
    }
}
