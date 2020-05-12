//
//  Article.swift
//  hl999_finalProject
//
//  Created by Hanzheng Li on 5/11/20.
//  Copyright © 2020 Hanzheng Li. All rights reserved.
//

import Foundation

struct SearchResponse: Codable {
    var status: String
    var response: ArticlesObject
}

struct ArticlesObject: Codable {
    var docs: [Article]
}

struct Article: Codable {
    var headline: Headline
    var byline: Byline
    var abstract: String
    var snippet: String
    var web_url: String
    var multimedia: [Multimedia]
}

struct Byline: Codable {
    var original: String
}

struct Headline: Codable {
    var main: String
}

struct Multimedia: Codable {
    var caption: String
    var credit: String
    var height: Int
    var width: Int
    var url: String
}
