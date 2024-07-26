//
//  NoContentView.swift
//  NetworkingWithCombine
//
//  Created by Alam, Mahjabin | Natasha | ECMPD on 2024/07/26.
//

import UIKit

class NoContentView: UIView {

    var noContentLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.black
        label.text = "No Content Yet"
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

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubViews() {
        self.addSubview(noContentImageView)
        self.addSubview(noContentLabel)
        addLayoutConstraints()
    }
    
    private func addLayoutConstraints() {
        let constraints = [
            noContentImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            noContentImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            noContentImageView.widthAnchor.constraint(equalToConstant: 200),
            noContentImageView.heightAnchor.constraint(equalTo: noContentImageView.widthAnchor),
            
            noContentLabel.topAnchor.constraint(equalTo: noContentImageView.bottomAnchor, constant: 20),
            noContentLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    //public API
    func show() {
        self.isHidden = false
    }
    func hide() {
        self.isHidden = true
    }
}
