//
//  NetworkManager.swift
//  hl999_finalProject
//
//  Created by Hanzheng Li on 5/11/20.
//  Copyright © 2020 Hanzheng Li. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager {
    private static let apiURL = "https://api.nytimes.com/svc/search/v2/articlesearch.json?"
    private static let apiKeyURL = "&api-key=Dnu48mvebUt2HO8lmbaJYDntulihi49G"

    
    static func searchArticles(query: [String], completion: @escaping (([Article]) -> Void)) {
        let endpointURL = getEndpointURL(query: query)
        AF.request(endpointURL, method: .get).validate().responseData { (response) in
            switch response.result {
            case .success(let data):
                let decoder = JSONDecoder()
                if let articlesData = try? decoder.decode(SearchResponse.self, from: data) {
                    completion(articlesData.response.docs)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    static func getEndpointURL(query: [String]) -> String {
        var queryURL = "q="
        var i = 0
        for str in query {
            if i == 0 {
                queryURL = queryURL + str
            } else if i < query.count {
                queryURL = queryURL + "+" + str
            }
            i = i + 1
        }
        return apiURL + queryURL + apiKeyURL
    }
    
    static func getImage(article: Article, didGetImages: @escaping ((UIImage?) -> Void)) {
        if article.multimedia.count > 0 {
            let imageURL = "https://nytimes.com/" + article.multimedia[0].url
            AF.request(imageURL, method: .get).validate().responseData { response in
                switch response.result {
                case .success(let data):
                    if let image = UIImage(data: data) {
                        didGetImages(image)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        else { didGetImages(nil) }
        
        
    }
}
