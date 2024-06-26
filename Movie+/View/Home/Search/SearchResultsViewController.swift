//
//  SearchResultsViewController.swift
//  Movie+
//
//  Created by Bahadır Etka Kılınç on 25.06.2024.
//

import UIKit
import SwiftUI

class SearchResultsViewController: UIViewController {
    private let query: String
    private var searchResults: [Movie] = []
    private let tableView = UITableView()
    
    init(query: String) {
        self.query = query
        super.init(nibName: nil, bundle: nil)
        self.title = query
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        performSearch()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SearchResultCell")
    }
    
    private func performSearch() {
        NetworkService.shared.search(query: query) { [weak self] results in
            self?.searchResults = results
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}

extension SearchResultsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath)
        let result = searchResults[indexPath.row]
        cell.textLabel?.text = result.title ?? result.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedResult = searchResults[indexPath.row]
        let detailView = DetailView(movie: selectedResult)
        let hostingController = UIHostingController(rootView: detailView)
        navigationController?.pushViewController(hostingController, animated: true)
    }
}
