//
//  BookmarkViewController.swift
//  hl999_finalProject
//
//  Created by Hanzheng Li on 5/12/20.
//  Copyright © 2020 Hanzheng Li. All rights reserved.
//

import UIKit

class BookmarkViewController: UIViewController {

    var tableView: UITableView!
    let cellReuseIdentifier = "cellReuseIdentifier"
    let userDefaults = UserDefaults.standard
    var bookmarks: [Article]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bookmarks = [Article]()
        let decoder = JSONDecoder()
        if let dataArray = userDefaults.array(forKey: Constants.UserDefaults.bookmarks) as? [Data] {
            bookmarks = dataArray.map { data in
                if let decoded = try? decoder.decode(Article.self, from: data) {
                    return decoded
                }
                return Article(headline: Headline("data conversion fail"), snippet: "", web_url: "", source: "", multimedia: [])
            }
        }
        print("bookmark page: ")
        print(bookmarks!)

        title = "Bookmarked Articles"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(popVC))
        view.backgroundColor = .black

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
        
        setupConstraints()
    }
    
    func setupConstraints() {
        let padding: CGFloat = 8
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
        ])
    }
    
    @objc func popVC() {
        navigationController?.popViewController(animated: true)
        let encoder = JSONEncoder()
        let encodedBookmarks: [Data] = self.bookmarks.map { bookmark in
            if let encodedObject = try? encoder.encode(bookmark) {
                return encodedObject
            }
            return Data()
        }
        self.userDefaults.set(encodedBookmarks, forKey: Constants.UserDefaults.bookmarks)
    }
}

extension BookmarkViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! ArticleTableViewCell
        let article = bookmarks[indexPath.row]
        cell.configure(article: article)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = self.bookmarks[indexPath.row]
        let vc = DetailsViewController(article: article)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let selectedArticle = bookmarks[indexPath.row]
        let alreadyBookmarked = bookmarks.contains(selectedArticle)
        let bookmarkAction = UIContextualAction(style: .normal, title:  "", handler: {
            (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            if alreadyBookmarked {
                self.bookmarks.remove(at: self.bookmarks.firstIndex(of: selectedArticle)!)
            } else {
                self.bookmarks.append(selectedArticle)
            }
            tableView.reloadData()
            success(true)
        })
        
        if alreadyBookmarked { bookmarkAction.image = UIImage(named: "bookmark.fill") }
        else { bookmarkAction.image = UIImage(named: "bookmark") }
        bookmarkAction.backgroundColor = .black
        return UISwipeActionsConfiguration(actions: [bookmarkAction])
    }

    
}
