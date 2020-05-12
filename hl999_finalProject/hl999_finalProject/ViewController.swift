//
//  ViewController.swift
//  hl999_finalProject
//
//  Created by Hanzheng Li on 5/11/20.
//  Copyright © 2020 Hanzheng Li. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    var tableView: UITableView!
    var cellReuseIdentifier = "ArticleCellReuseIdentifier"
    var searchBarView: UITextField!
    var searchButton: UIButton!
    var loadingLabel: UILabel!
    var timer: Timer!
    var time: Int = 0
    
    var articles = [Article]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(containsOnlyCharacters(list: ["apples", "cowboys"]))
        
        title = "NYT Article Search"
        
        view.backgroundColor = .black
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        configureSearchBarView()
        configureSearchButton()
        configureTableView()
        configureLoadingLabel()
        setupConstraints()
        
        makeRequest(query: [])
    }
    
    func configureSearchBarView() {
        searchBarView = UITextField()
        searchBarView.translatesAutoresizingMaskIntoConstraints = false
        searchBarView.delegate = self
        searchBarView.layer.cornerRadius = 5
        searchBarView.layer.masksToBounds = true
        searchBarView.layer.borderColor = UIColor.lightGray.cgColor
        searchBarView.layer.borderWidth = 1.0
        let padding = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 5, height: 5))
        searchBarView.leftView = padding
        searchBarView.leftViewMode = .always
        searchBarView.rightView = padding
        searchBarView.rightViewMode = .always
        searchBarView.font = UIFont.systemFont(ofSize: 16)
        searchBarView.attributedPlaceholder = NSAttributedString(string: "Search by article keyword",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        searchBarView.textColor = .white
        view.addSubview(searchBarView)
    }
    
    func configureSearchButton() {
        searchButton = UIButton()
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.setImage(UIImage(named: "magnifyingglass")!, for: .normal)
        searchButton.backgroundColor = .black
        searchButton.addTarget(self, action: #selector(textFieldShouldReturn), for: .touchUpInside)
        view.addSubview(searchButton)
    }
    
    func configureTableView() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsSelection = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ArticleTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .black
        tableView.layer.masksToBounds = true
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        view.addSubview(tableView)
    }
    
    func configureLoadingLabel() {
        loadingLabel = UILabel()
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        loadingLabel.font = UIFont(name: "Avenir-Medium", size: 14)!
        loadingLabel.textColor = .white
        loadingLabel.text = "Loading results"
        view.addSubview(loadingLabel)
        timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(loadingAnimation), userInfo: nil, repeats: true)
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
    
    func setupConstraints() {
        let searchPadding: CGFloat = 12
        let tablePadding: CGFloat = 8
        NSLayoutConstraint.activate([
            searchBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: searchPadding),
            searchBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(searchPadding + 30)),
            searchBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: searchPadding),
            searchBarView.bottomAnchor.constraint(equalTo: searchBarView.topAnchor, constant: 30),
        ])
        NSLayoutConstraint.activate([
            searchButton.leadingAnchor.constraint(equalTo: searchBarView.trailingAnchor, constant: searchPadding),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -searchPadding),
            searchButton.topAnchor.constraint(equalTo: searchBarView.topAnchor),
            searchButton.bottomAnchor.constraint(equalTo: searchBarView.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: tablePadding),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -tablePadding),
            tableView.topAnchor.constraint(equalTo: searchBarView.bottomAnchor, constant: searchPadding),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            loadingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    func makeRequest(query: [String]) {
        articles = []
        tableView.reloadData()
        loadingLabel.isHidden = false
        print("made request")
        print(query)
        NetworkManager.searchArticles(query: query) { articles in
            self.articles = articles
            print("received request")
            print(articles)
            DispatchQueue.main.async {
                self.loadingLabel.isHidden = true
                self.tableView.reloadData()
            }
        }
    }
    
    func containsOnlyCharacters(list: [String]) -> Bool {
        func aux(string: String) -> Bool {
            for ch in string {
                if !"abcdefghijklmnopqrstuvwxyz".contains(ch) {
                    return false
                }
            }
            return true
        }
        let bools = list.map { string in
            aux(string: string)
        }
        return !bools.contains(false)
    }
    
    func searchArticles() {
        guard let searchText = searchBarView.text else { return }
        if !searchText.isEmpty {
            let query = searchText.trimmingCharacters(in: .whitespaces).split(separator: " ").map { substr -> String in
                return String(substr).lowercased().trimmingCharacters(in: .whitespaces)
            }
            if !containsOnlyCharacters(list: query) {
                let alert = UIAlertController(title: "Error", message: "Field can only contain letters. ", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default))
                self.present(alert, animated: true, completion: nil)
            } else {
                makeRequest(query: query)
            }
        } else {
            let alert = UIAlertController(title: "Error", message: "Field cannot be empty. ", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: UITextFieldDelegate Protocol
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchArticles()
        return true
    }
    
    // MARK: UITableViewDataSource Protocol
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! ArticleTableViewCell
        let headline = articles[indexPath.row].headline.main
        let abstract = articles[indexPath.row].abstract
        cell.configure(headline: headline, abstract: abstract)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = self.articles[indexPath.row]
        let vc = DetailsViewController(article: article)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
