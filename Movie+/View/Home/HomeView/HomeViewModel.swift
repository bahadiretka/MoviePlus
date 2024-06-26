//
//  HomeViewModel.swift
//  Movie+
//
//  Created by Bahadır Etka Kılınç on 25.06.2024.
//

import Foundation

class HomeViewModel {
    private let networkService: NetworkServiceProtocol
    var popularMovies: [Movie] = []
    var popularSeries: [Movie] = []
    
    var updateUI: (() -> Void)?
    
    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }
    
    func fetchData() {
        networkService.fetchGenres { [weak self] in
            self?.networkService.fetchMovies { movies in
                self?.popularMovies = movies
                self?.updateUI?()
            }
            
            self?.networkService.fetchSeries { series in
                self?.popularSeries = series
                self?.updateUI?()
            }
        }
    }
    
    func getImageURL(for path: String) -> URL? {
        return networkService.getImageURL(for: path)
    }
}
