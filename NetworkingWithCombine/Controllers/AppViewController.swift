//
//  AppViewController.swift
//  NetworkingWithCombine
//
//  Created by Alam, Mahjabin | Natasha | ECMPD on 2024/07/25.
//

import UIKit
import Combine

class AppViewController: UIViewController {
    
    private var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search here"
        return searchBar
    }()
    
    private var noContentView: NoContentView = {
        let view = NoContentView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var moviesTableView: MovieTableView = {
        let tableContainingView = MovieTableView(viewModel: viewModel)
        tableContainingView.translatesAutoresizingMaskIntoConstraints = false
        return tableContainingView
    }()
    
    private var verticalStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var cancellables: [AnyCancellable] = []
    
    private let viewModel: MovieListViewModel
    
    init(viewModel: MovieListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubViews()
        
        viewModel.$dataFetchCompleted.sink { [weak self] status in
            switch status {
            case .notDone:
                self?.noContentView.show()
                self?.moviesTableView.hide()
            case .succeded:
                self?.noContentView.hide()
                self?.moviesTableView.show()
            case .failed:
                print("Will show another view with network error")
                self?.moviesTableView.hide()
            }
        }.store(in: &cancellables)
    }
    
    func setupSubViews() {
        view.backgroundColor = .white
        
        //search bar
        searchBar.delegate = self
        verticalStackView.addArrangedSubview(searchBar)

        //no content view
        verticalStackView.addArrangedSubview(noContentView)
        
        //stackView bar
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

extension AppViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.loadMovies(search: "batman")
    }
}
