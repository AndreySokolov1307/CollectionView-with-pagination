//
//  File.swift
//  CollectionView CatInfo Cathing with pagination
//
//  Created by Андрей Соколов on 31.10.2023.
//

import Foundation

struct PaginationBreed: Codable, Hashable {
//Для того чтобы програма не крашилась изза - supplied identifiers are not unique
    let uuid = UUID()
    
    let id: String
    let url: String
    let breeds: [PagBreeds]
}

struct PagBreeds: Codable, Hashable {
    let name: String
    let wikipediaURL: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case wikipediaURL = "wikipedia_url"
    }
}

