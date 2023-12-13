//
//  APIController.swift
//  CollectionView CatInfo Cathing with pagination
//
//  Created by Андрей Соколов on 28.10.2023.
//

import Foundation
import UIKit

class BreedController {
    
    private let apiKey = "live_PTv2j5mgtAGsSJVgHEzPbYb5KRdp4ZCwQN1VESak4DA5Phg6A9HcP0BNrNWdiANR"
    
    var imageCache = NSCache<NSString, UIImage>()
    
    enum BreedsError: Error, LocalizedError {
        case breedsNotFound
        case breedImageURLNotfound
        case imageDataMissing
    }
    
    func fetchAllBreeds() async throws -> [Breed] {
        let urlComponents = URLComponents(string: "https://api.thecatapi.com/v1/breeds" )!
        
        let (data, response) = try await URLSession.shared.data(from: urlComponents.url!)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw BreedsError.breedsNotFound
        }
        
        let decoder = JSONDecoder()
        let searchResponse = try decoder.decode([Breed].self, from: data)

        return searchResponse
    }
    
    func fetchImageURL(fromID id: String) async throws -> URL? {
      
        let urlComponents = URLComponents(string: "https://api.thecatapi.com/v1/images/\(id)")!
        
        let (data, response) = try await URLSession.shared.data(from: urlComponents.url!)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw BreedsError.breedImageURLNotfound
        }
        
        let decoder = JSONDecoder()
        let searchResponse = try decoder.decode(BreedImageURL.self, from: data)

        guard let imageURLString = searchResponse.url else {
            return nil
        }
        
        let url = URL(string: imageURLString)
        
        return url
    }
    
    func fetchImage(from url: URL) async throws -> UIImage {
        
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            return cachedImage
        } else {
            
            let (data, responce) = try await URLSession.shared.data(from: url)
            
            guard let httpResponce = responce as? HTTPURLResponse,
                  httpResponce.statusCode == 200 else {
                throw BreedsError.imageDataMissing
            }
            
            guard let image = UIImage(data: data ) else {
                throw BreedsError.imageDataMissing
            }
            
            self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
            print("new")
            return image
        }
    }
}
