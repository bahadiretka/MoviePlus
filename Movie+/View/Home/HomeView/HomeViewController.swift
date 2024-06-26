//
//  HomeViewController.swift
//  Movie+
//
//  Created by Bahadır Etka Kılınç on 24.06.2024.
//

import UIKit

class HomeViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.fetchData()
        self.hideKeyboardWhenTappedAround()
    }
    
    override func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        userName.text = FirebaseAuthManager.shared.getCurrentUser()?.email
    }
    
    private func setupBindings() {
        viewModel.updateUI = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as? HomeTableViewCell else { return UITableViewCell() }
        
        cell.collectionView.delegate = cell
        cell.collectionView.dataSource = cell
        cell.collectionView.tag = indexPath.row
        cell.collectionView.reloadData()
        
        if indexPath.row == 0 {
            cell.title.text = "Popular Movies"
        } else {
            cell.title.text = "Popular Series"
        }
        
        return cell
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        performSearch(query: query)
    }
    
    func performSearch(query: String) {
        AnalyticsManager.shared.logEvent(.searchMovie, parameters: ["query" : query])
        let searchResultsVC = SearchResultsViewController(query: query)
        navigationController?.pushViewController(searchResultsVC, animated: true)
    }
}
