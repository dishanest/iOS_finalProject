//
//  ArticleTableViewCell.swift
//  hl999_finalProject
//
//  Created by Hanzheng Li on 5/11/20.
//  Copyright © 2020 Hanzheng Li. All rights reserved.
//

import UIKit
import SnapKit

class ArticleTableViewCell: UITableViewCell {

    let headlineLabel = UILabel()
    let sourceLabel = UILabel()
    
    override init (style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .black
        
        headlineLabel.translatesAutoresizingMaskIntoConstraints = false
        headlineLabel.numberOfLines = 0
        headlineLabel.textColor = UIColor.white
        headlineLabel.font = UIFont(name: "Avenir-Medium", size: 18)!
        contentView.addSubview(headlineLabel)
        
        sourceLabel.translatesAutoresizingMaskIntoConstraints = false
        sourceLabel.numberOfLines = 0
        sourceLabel.textColor = UIColor.lightGray
        sourceLabel.font = UIFont(name: "Avenir-Medium", size: 14)!
        contentView.addSubview(sourceLabel)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        let padding: CGFloat = 12
        let lineSpacing: CGFloat = 8
        NSLayoutConstraint.activate([
            headlineLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            headlineLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            headlineLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding/2),
        ])
        NSLayoutConstraint.activate([
            sourceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            sourceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            sourceLabel.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: lineSpacing),
            sourceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding/2)
        ])
    }
    
    func configure (article: Article) {
        headlineLabel.text = article.headline.main
        sourceLabel.text = "Source: " + article.source
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
