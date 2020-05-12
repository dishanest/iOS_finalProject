//
//  DetailsViewController.swift
//  hl999_finalProject
//
//  Created by Hanzheng Li on 5/11/20.
//  Copyright © 2020 Hanzheng Li. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var article: Article!
    var headlineLabel = UILabel()
    var imageView = UIImageView()
    var snippetLabel = UILabel()
    var articleButton = UIButton()
    var buttonURL: String!
    var loadingLabel: UILabel!
    var timer: Timer!
    var time: Int = 0
    
    init(article: Article) {
        super.init(nibName:nil, bundle: nil)
        self.article = article
        self.buttonURL = article.web_url
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Article Details"
        view.backgroundColor = .black
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action:#selector(popVC))
        
        headlineLabel = UILabel()
        headlineLabel.translatesAutoresizingMaskIntoConstraints = false
        headlineLabel.textColor = .white
        headlineLabel.font = UIFont(name: "Avenir-Medium", size: 24)!
        headlineLabel.numberOfLines = 0
        headlineLabel.text = article.headline.main
        view.addSubview(headlineLabel)
        
        loadingLabel = UILabel()
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        loadingLabel.font = UIFont(name: "Avenir-Medium", size: 14)!
        loadingLabel.textColor = .white
        loadingLabel.text = "Loading image..."
        view.addSubview(loadingLabel)
        
        timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(loadingAnimation), userInfo: nil, repeats: true)
        
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        NetworkManager.getImage(article: article) { (imageOption) in
            self.loadingLabel.isHidden = false
            DispatchQueue.main.async {
                self.loadingLabel.isHidden = true
                if let image = imageOption { self.imageView.image = image }
                else { self.imageView.image = UIImage(named: "imagedoesntexist")! }
            }
        }
        view.addSubview(imageView)
        
        snippetLabel = UILabel()
        snippetLabel.translatesAutoresizingMaskIntoConstraints = false
        snippetLabel.textColor = .white
        snippetLabel.font = UIFont(name: "Avenir-Medium", size: 16)!
        snippetLabel.numberOfLines = 0
        snippetLabel.text = article.snippet
        view.addSubview(snippetLabel)
        
        articleButton = UIButton()
        articleButton.translatesAutoresizingMaskIntoConstraints = false
        articleButton.setTitle("View article", for: .normal)
        articleButton.setTitleColor(.white, for: .normal)
        articleButton.backgroundColor = .darkGray
        articleButton.layer.cornerRadius = 5
        articleButton.layer.borderWidth = 1
        articleButton.layer.borderColor = UIColor.darkGray.cgColor
        articleButton.contentEdgeInsets = UIEdgeInsets(top: 5,left: 10,bottom: 5,right: 10)
        articleButton.addTarget(self, action: #selector(openURL), for: .touchUpInside)
        view.addSubview(articleButton)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        let padding: CGFloat = 12
        let imageFrameHeight: CGFloat = 275
        NSLayoutConstraint.activate([
            headlineLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            headlineLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            headlineLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding)
        ])
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: headlineLabel.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: headlineLabel.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: 2 * padding),
            imageView.bottomAnchor.constraint(equalTo: imageView.topAnchor, constant: imageFrameHeight)
        ])
        NSLayoutConstraint.activate([
            snippetLabel.leadingAnchor.constraint(equalTo: headlineLabel.leadingAnchor),
            snippetLabel.trailingAnchor.constraint(equalTo: headlineLabel.trailingAnchor),
            snippetLabel.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: imageFrameHeight + 4 * padding)
        ])
        NSLayoutConstraint.activate([
            articleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            articleButton.topAnchor.constraint(equalTo: snippetLabel.bottomAnchor, constant: 2 * padding),
            articleButton.heightAnchor.constraint(equalToConstant: 3 * padding),
            articleButton.widthAnchor.constraint(equalToConstant: 10 * padding)
        ])
    }
    
    @objc func loadingAnimation() {
        switch time % 3 {
        case 0:
            loadingLabel.text = "Loading results."
        case 1:
            loadingLabel.text = "Loading results.."
        case 2:
            loadingLabel.text = "Loading results..."
        default:
            loadingLabel.text = "Loading results"
        }
        time += 1
    }
    
    @objc func popVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func openURL() {
        if let url = URL(string: buttonURL) {
            UIApplication.shared.open(url)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
