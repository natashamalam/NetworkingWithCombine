//
//  AppViewController.swift
//  NetworkingWithCombine
//
//  Created by Alam, Mahjabin | Natasha | ECMPD on 2024/07/25.
//

import UIKit

class AppViewController: UIViewController {
    
    private var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search here"
        return searchBar
    }()
    
    private var moviesTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var verticalStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let viewModel: MoviesViewModel
    
    init(viewModel: MoviesViewModel = MoviesViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubViews()
    }
    
    func setupSubViews() {
        view.backgroundColor = .white
        
        //search bar
        searchBar.delegate = self
        verticalStackView.addArrangedSubview(searchBar)
        
        //table view
        moviesTableView.register(MovieDetailTableViewCell.self, forCellReuseIdentifier: "movieCell")
        moviesTableView.dataSource = self
        moviesTableView.delegate = self
        
        //stack bar
        verticalStackView.addArrangedSubview(moviesTableView)
        view.addSubview(verticalStackView)
        
        addLayoutConstraints()
    }
    
    func addLayoutConstraints() {
        let constraints = [
            verticalStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            verticalStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}

extension AppViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfContent()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as? MovieDetailTableViewCell else {
            return UITableViewCell()
        }
        cell.viewModel = try? viewModel.cellVM(at: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45.0
    }

}

extension AppViewController: UISearchBarDelegate {
    
}
