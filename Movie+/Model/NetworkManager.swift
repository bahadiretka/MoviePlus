//
//  NetworkManager.swift
//  Movie+
//
//  Created by Bahadır Etka Kılınç on 25.06.2024.
//



import Alamofire

protocol NetworkServiceProtocol {
    func fetchGenres(completion: @escaping () -> Void)
    func fetchMovies(completion: @escaping ([Movie]) -> Void)
    func fetchSeries(completion: @escaping ([Movie]) -> Void)
    func search(query: String, completion: @escaping ([Movie]) -> Void)
    func getImageURL(for path: String) -> URL?
    func getGenreNames(for genreIDs: [Int], type: ContentType) -> String
}

class NetworkService: NetworkServiceProtocol {
    static let shared = NetworkService()
    private let apiKey = "api-key"
    private let baseImageURL = "https://image.tmdb.org/t/p/w500"
    
    var movieGenres: [Int: String] = [:]
    var tvGenres: [Int: String] = [:]
    
    func fetchGenres(completion: @escaping () -> Void) {
        let movieGenresURL = "https://api.themoviedb.org/3/genre/movie/list?api_key=\(apiKey)"
        let tvGenresURL = "https://api.themoviedb.org/3/genre/tv/list?api_key=\(apiKey)"
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        AF.request(movieGenresURL).responseDecodable(of: GenreResult.self) { response in
            if let genreResult = response.value {
                for genre in genreResult.genres {
                    self.movieGenres[genre.id] = genre.name
                }
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        AF.request(tvGenresURL).responseDecodable(of: GenreResult.self) { response in
            if let genreResult = response.value {
                for genre in genreResult.genres {
                    self.tvGenres[genre.id] = genre.name
                }
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }
    
    func fetchMovies(completion: @escaping ([Movie]) -> Void) {
        let urlString = "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)"
        fetchData(from: urlString, completion: completion)
    }
    
    func fetchSeries(completion: @escaping ([Movie]) -> Void) {
        let urlString = "https://api.themoviedb.org/3/tv/popular?api_key=\(apiKey)"
        fetchData(from: urlString, completion: completion)
    }
    
    func search(query: String, completion: @escaping ([Movie]) -> Void) {
        let urlString = "https://api.themoviedb.org/3/search/multi?api_key=\(apiKey)&query=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query)"
        fetchData(from: urlString, completion: completion)
    }
    
    private func fetchData(from urlString: String, completion: @escaping ([Movie]) -> Void) {
        AF.request(urlString).responseDecodable(of: ContentResult.self) { response in
            switch response.result {
            case .success(let movieResult):
                completion(movieResult.results ?? [])
            case .failure(let error):
                print("Error fetching data: \(error)")
                completion([])
            }
        }
    }
    
    func getImageURL(for path: String) -> URL? {
        return URL(string: "\(baseImageURL)\(path)")
    }
    
    func getGenreNames(for genreIDs: [Int], type: ContentType) -> String {
        let genres = genreIDs.prefix(2).map { id in
            switch type {
            case .movie:
                return movieGenres[id] ?? ""
            case .tv:
                return tvGenres[id] ?? ""
            }
        }
        return genres.joined(separator: ", ")
    }
}
