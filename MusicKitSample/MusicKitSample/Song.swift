//
//  Song.swift
//  MusicKitSample
//
//  Created by Dobrinka Tabakova on 12/17/17.
//  Copyright © 2017 Dobrinka Tabakova. All rights reserved.
//

import UIKit

struct Results : Decodable {
    enum ResultsKeys: String, CodingKey {
        case results
    }
    
    enum SongsKeys: String, CodingKey {
        case songs
    }
    
    enum DataKeys: String, CodingKey {
        case data
    }
    
    public init(from decoder: Decoder) throws {
        let results = try decoder.container(keyedBy: ResultsKeys.self)
        let resultsValues = try results.nestedContainer(keyedBy: SongsKeys.self, forKey: ResultsKeys.results)
        let dataValues = try resultsValues.nestedContainer(keyedBy: DataKeys.self, forKey: SongsKeys.songs)
        songs = try dataValues.decode([Song].self, forKey: DataKeys.data)
    }
    
    var songs: [Song]
}

struct Song: Decodable {
    enum SongKeys: String, CodingKey {
        case name
        case artistName
    }
    
    enum AttributesKeys: String, CodingKey {
        case attributes
    }
    
    var name: String
    var artistName: String
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: AttributesKeys.self)
        let attributesValues = try values.nestedContainer(keyedBy: SongKeys.self, forKey: AttributesKeys.attributes)
        name = try attributesValues.decode(String.self, forKey: SongKeys.name)
        artistName = try attributesValues.decode(String.self, forKey: SongKeys.artistName)
    }
}
