//
//  PaginationController.swift
//  CollectionView CatInfo Cathing with pagination
//
//  Created by Андрей Соколов on 31.10.2023.
//

import Foundation
import UIKit

class PaginationController {
    
    static let shared = PaginationController()
    
    var imageCache = NSCache<NSString, UIImage>()
    
    enum PaginationBreedsError: Error, LocalizedError {
        case breedsNotFound
        case breedImageURLNotfound
        case imageDataMissing
    }
    
    func fetchBreeds(matching query: [String : String]) async throws -> [PaginationBreed] {
        var urlComponents = URLComponents(string: "https://api.thecatapi.com/v1/images/search?")!
        urlComponents.queryItems = query.map { URLQueryItem(name: $0.key, value: $0.value) }

        let (data, response) = try await URLSession.shared.data(from: urlComponents.url!)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw PaginationBreedsError.breedsNotFound
        }
        
        let decoder = JSONDecoder()
        let searchResponse = try decoder.decode([PaginationBreed].self, from: data)

        return searchResponse
    }
    
    func fetchImage(from url: URL) async throws -> UIImage {
        
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            print("cached image")
            return cachedImage
        } else {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw PaginationBreedsError.imageDataMissing
            }
            
            guard let image = UIImage(data: data) else {
                throw PaginationBreedsError.imageDataMissing
            }
            
            self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
            
            return image
        }
    }
}


