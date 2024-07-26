//
//  Movie.swift
//  NetworkingWithCombine
//
//  Created by Alam, Mahjabin | Natasha | ECMPD on 2024/07/25.
//

import UIKit

struct MovieResponse: Decodable {
    let search: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case search = "Search"
    }
}

struct Movie: Codable {
    let title: String
    let year: String
    let imdbID: String
    let poster: String
    
    var posterImage: UIImage? = UIImage(named: "no_image")
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID = "imdbID"
        case poster = "Poster"
    }
    
    init(title: String, year: String, imdbID: String, poster: String) {
        self.title = title
        self.year = year
        self.imdbID = imdbID
        self.poster = poster
    }
    
    func fetchImage(named: String) {}
    
}
