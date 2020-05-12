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
    let abstractLabel = UILabel()
    
    override init (style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .black
        
        headlineLabel.translatesAutoresizingMaskIntoConstraints = false
        headlineLabel.numberOfLines = 0
        headlineLabel.textColor = UIColor.white
        headlineLabel.font = UIFont(name: "Avenir-Medium", size: 18)!
        contentView.addSubview(headlineLabel)
        
        abstractLabel.translatesAutoresizingMaskIntoConstraints = false
        abstractLabel.numberOfLines = 0
        abstractLabel.textColor = UIColor.lightGray
        abstractLabel.font = UIFont(name: "Avenir-Medium", size: 14)!
        contentView.addSubview(abstractLabel)
        
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
            abstractLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            abstractLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            abstractLabel.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: lineSpacing),
            abstractLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding/2)
        ])
    }
    
    func configure (headline: String, abstract: String) {
        headlineLabel.text = headline
        abstractLabel.text = abstract
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
