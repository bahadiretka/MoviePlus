//
//  Movie.swift
//  Movie+
//
//  Created by Bahadır Etka Kılınç on 25.06.2024.
//

enum ContentType {
    case movie
    case tv
}

struct ContentResult: Codable {
    let page: Int?
    let results: [Movie]?
    let totalPages, totalResults: Int?
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct Movie: Codable {
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]?
    let id: Int?
    let originalTitle, overview: String?
    let posterPath, releaseDate, title: String?
    let firstAirDate: String?
    let voteAverage: Double?
    let name: String?
    let language: String?
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case voteAverage = "vote_average"
        case name
        case firstAirDate = "first_air_date"
        case language = "original_language"
    }
}

struct GenreResult: Codable {
    let genres: [Genre]
}

struct Genre: Codable {
    let id: Int
    let name: String
}
