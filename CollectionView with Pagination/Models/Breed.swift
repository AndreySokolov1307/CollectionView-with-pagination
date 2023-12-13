//
//  File.swift
//  CollectionView CatInfo Cathing with pagination
//
//  Created by Андрей Соколов on 28.10.2023.
//

import Foundation

struct Breed: Codable, Hashable {
    let id: String
    let name: String
    let wikipediaURL: String?
    let referenceImageID: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case wikipediaURL = "wikipedia_url"
        case referenceImageID = "reference_image_id"
    }
}

struct BreedImageURL: Codable, Hashable  {
    let url: String?
}

