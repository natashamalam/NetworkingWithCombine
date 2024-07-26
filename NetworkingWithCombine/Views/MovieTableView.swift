//
//  MovieTableView.swift
//  NetworkingWithCombine
//
//  Created by Alam, Mahjabin | Natasha | ECMPD on 2024/07/26.
//

import UIKit

class MovieTableView: UIView {

    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    
    private let viewModel: MovieListViewModel
    
    init(viewModel: MovieListViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubViews() {
        
        tableView.register(MovieDetailTableViewCell.self, forCellReuseIdentifier: "movieCell")
        tableView.dataSource = self
        tableView.delegate = self
        
        addSubview(tableView)
        addLayoutConstraints()
        
    }
    
    private func addLayoutConstraints() {
        let constraints = [
            tableView.topAnchor.constraint(equalTo: self.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: self.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: self.rightAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    //public API
    func show() {
        self.isHidden = false
        self.reloadData()
    }
    
    func hide() {
        self.isHidden = true
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
}


extension MovieTableView: UITableViewDataSource, UITableViewDelegate {
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
