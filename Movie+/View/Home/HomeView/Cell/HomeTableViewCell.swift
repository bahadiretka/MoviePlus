//
//  HomeTableViewCell.swift
//  Movie+
//
//  Created by Bahadır Etka Kılınç on 25.06.2024.
//

import UIKit
import Kingfisher
import SwiftUI

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func configureCell<T: UICollectionViewCell>(_ cell: T, with item: Movie, type: ContentType) {
        if let bigCell = cell as? BigCollectionViewCell {
            bigCell.title.text = item.title
            if let posterPath = item.posterPath, let imageUrl = NetworkService.shared.getImageURL(for: posterPath) {
                bigCell.image.kf.setImage(with: imageUrl)
            }
            if let genreIDs = item.genreIDS {
                let text = NetworkService.shared.getGenreNames(for: genreIDs, type: type)
                bigCell.movieType.text = text.isEmpty ? "No Genre" : text
            }
        } else if let smallCell = cell as? SmallCollectionViewCell {
            smallCell.title.text = item.name
            if let posterPath = item.posterPath, let imageUrl = NetworkService.shared.getImageURL(for: posterPath) {
                smallCell.image.kf.setImage(with: imageUrl)
            }
            if let genreIDs = item.genreIDS {
                let text = NetworkService.shared.getGenreNames(for: genreIDs, type: type)
                smallCell.movieType.text = text.isEmpty ? "No Genre" : text
            }
        }
    }
}

extension HomeTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let homeVC = self.parentViewController as? HomeViewController else { return 0 }
        return collectionView.tag == 0 ? homeVC.viewModel.popularMovies.count : homeVC.viewModel.popularSeries.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let homeVC = self.parentViewController as? HomeViewController else { return UICollectionViewCell() }
        
        if collectionView.tag == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BigCollectionViewCell", for: indexPath) as? BigCollectionViewCell else { return UICollectionViewCell() }
            let movie = homeVC.viewModel.popularMovies[indexPath.row]
            configureCell(cell, with: movie, type: .movie)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SmallCollectionViewCell", for: indexPath) as? SmallCollectionViewCell else { return UICollectionViewCell() }
            let series = homeVC.viewModel.popularSeries[indexPath.row]
            configureCell(cell, with: series, type: .tv)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let homeVC = self.parentViewController as? HomeViewController else { return }
        
        if collectionView.tag == 0 {
            let movie = homeVC.viewModel.popularMovies[indexPath.row]
            let detailView = DetailView(movie: movie)
            let hostingController = UIHostingController(rootView: detailView)
            homeVC.navigationController?.pushViewController(hostingController, animated: true)
        } else {
            let series = homeVC.viewModel.popularSeries[indexPath.row]
            let detailView = DetailView(movie: series)
            let hostingController = UIHostingController(rootView: detailView)
            homeVC.navigationController?.pushViewController(hostingController, animated: true)
        }
    }
}
