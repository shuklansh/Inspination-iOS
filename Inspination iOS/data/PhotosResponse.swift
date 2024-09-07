//
//  PhotosResponse.swift
//  Inspination iOS
//
//  Created by Ansh Shukla on 07/09/24.
//

import Foundation

struct PhotosResponse: Decodable {
    let next_page: String
    let page: Int
    let per_page: Int
    let photos: [Photo]
    let total_results: Int
}

struct Photo: Decodable, Hashable {
    let id: Int
    let photographer_url: String
    let photographer: String
    let src: Src
}

struct Src: Decodable, Hashable {
    let landscape: URL
    let large: URL
    let small: URL
    let medium: URL
}
