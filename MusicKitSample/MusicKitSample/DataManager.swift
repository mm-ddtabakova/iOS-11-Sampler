//
//  DataManager.swift
//  MusicKitSample
//
//  Created by Dobrinka Tabakova on 12/17/17.
//  Copyright © 2017 Dobrinka Tabakova. All rights reserved.
//

import UIKit

class DataManager: NSObject {
    //Apple Documentation
    //https://developer.apple.com/library/content/documentation/NetworkingInternetWeb/Conceptual/AppleMusicWebServicesReference/SetUpWebServices.html#//apple_ref/doc/uid/TP40017625-CH2-SW1
    let token = "developer_token"
    
    static let sharedInstance = DataManager()
    
    private let defaultSession = URLSession(configuration: .default)
    
    private var dataTask: URLSessionDataTask?
    
    func getSearchResults(searchTerm: String, completion: @escaping ([Song]?) -> Void) {
        dataTask?.cancel()
        
        guard let  escapedSearchTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            completion(nil)
            return
        }
        
        if var urlComponents = URLComponents(string: "https://api.music.apple.com/v1/catalog/us/search") {
            urlComponents.query = "term=\(escapedSearchTerm)&types=songs&limit=25"
            
            guard let url = urlComponents.url else {
                completion(nil)
                return
            }
            
            var request = URLRequest(url: url)
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            dataTask = defaultSession.dataTask(with: request) {(data, response, error ) in
                guard error == nil else {
                    print("Error")
                    completion(nil)
                    return
                }
                
                guard let content = data else {
                    print("No data")
                    completion(nil)
                    return
                }

                let jsonDecoder = JSONDecoder()
                guard let songs = (try? jsonDecoder.decode(Results.self, from: content))?.songs else {
                    print("Decoding error")
                    completion(nil)
                    return
                }
                completion(songs)
            }
            dataTask?.resume()
        }
    }
}
