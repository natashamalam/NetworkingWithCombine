//
//  TMovieDetailTableViewCell.swift
//  NetworkingWithCombine
//
//  Created by Alam, Mahjabin | Natasha | ECMPD on 2024/07/25.
//

import UIKit

class MovieDetailTableViewCell: UITableViewCell {

    var captionLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.black
        label.setContentHuggingPriority(.required, for: .vertical)
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var releaseYearLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = UIColor.gray
        label.setContentHuggingPriority(.required, for: .vertical)
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var captionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var viewModel: MovieCellViewModel? {
        didSet {
            updateContentData()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupSubViews()
        self.updateContentData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubViews() {
        self.contentView.addSubview(captionImageView)
        self.contentView.addSubview(captionLabel)
        self.contentView.addSubview(releaseYearLabel)
        addLayoutConstraints()
    }
    
    private func addLayoutConstraints() {
        let constraints = [
            captionImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            captionImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            captionImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 15),
            captionImageView.widthAnchor.constraint(equalTo: captionImageView.heightAnchor, multiplier: 1.0),
            
            captionLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            captionLabel.leadingAnchor.constraint(equalTo: captionImageView.trailingAnchor, constant: 15.0),
            captionLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -15.0),
            
            releaseYearLabel.topAnchor.constraint(equalTo: captionLabel.bottomAnchor, constant: 5),
            releaseYearLabel.leadingAnchor.constraint(equalTo: captionLabel.trailingAnchor),
            releaseYearLabel.trailingAnchor.constraint(equalTo: captionLabel.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func updateContentData() {
        captionLabel.text = viewModel?.titleString
        releaseYearLabel.text = viewModel?.releaseYearString
        captionImageView.image = viewModel?.posterImage
    }
    
}
