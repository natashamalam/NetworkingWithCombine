//
//  ContentErrorView.swift
//  NetworkingWithCombine
//
//  Created by Alam, Mahjabin | Natasha | ECMPD on 2024/07/26.
//

import UIKit
import Combine

class NoSearchResultView: UIView {
    
    var noContentLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.red
        label.setContentHuggingPriority(.required, for: .vertical)
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var noContentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "no_content")
        return imageView
    }()
    
    var retryButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Retry", for: .normal)
        button.backgroundColor = UIColor.systemGreen
        return button
    }()
    
    var lastSearchedKeyword: String?
    
    var retryAction: ((String?) -> Void)?
    
    private let viewModel: MovieListViewModel
    private var cancellables: [AnyCancellable] = []
    
    init(viewModel: MovieListViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubViews() {
        viewModel.$noContentLabel.sink { text in
            self.noContentLabel.text = text
        }.store(in: &cancellables)
        
        self.addSubview(noContentImageView)
        self.addSubview(noContentLabel)
        self.addSubview(retryButton)
        
        retryButton.addTarget(self, action: #selector(retry(_:)), for: .touchUpInside)
       
        addLayoutConstraints()
    }
    
    private func addLayoutConstraints() {
        let constraints = [
            noContentImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            noContentImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -40),
            noContentImageView.widthAnchor.constraint(equalToConstant: 200),
            noContentImageView.heightAnchor.constraint(equalTo: noContentImageView.widthAnchor),
            
            noContentLabel.topAnchor.constraint(equalTo: noContentImageView.bottomAnchor, constant: 20),
            noContentLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            retryButton.topAnchor.constraint(equalTo: noContentLabel.bottomAnchor, constant: 25),
            retryButton.centerXAnchor.constraint(equalTo: noContentLabel.centerXAnchor),
            retryButton.widthAnchor.constraint(equalToConstant: 200),
            retryButton.heightAnchor.constraint(equalToConstant: 60)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        retryButton.layer.cornerRadius = 5.0
    }
    
    @objc func retry(_ sender: UIButton) {
        if let lastSearchedKeyword {
            retryAction?(lastSearchedKeyword)
        }
    }
    
    //public API
    func show(with searchedKeyword: String) {
        self.lastSearchedKeyword = searchedKeyword
        self.isHidden = false
    }
    func hide() {
        self.isHidden = true
    }
}
