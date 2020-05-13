//
//  Article.swift
//  hl999_finalProject
//
//  Created by Hanzheng Li on 5/11/20.
//  Copyright © 2020 Hanzheng Li. All rights reserved.
//

import Foundation

struct SearchResponse: Codable {
    var response: ArticlesObject
}

struct ArticlesObject: Codable {
    var docs: [Article]
}

class Article: NSObject, Codable {
    var headline: Headline
    var snippet: String
    var web_url: String
    var source: String
    var multimedia: [Multimedia]
    
    init(headline: Headline, snippet: String, web_url: String, source: String, multimedia: [Multimedia]) {
        self.headline = headline
        self.snippet = snippet
        self.web_url = web_url
        self.source = source
        self.multimedia = multimedia
    }
    
    override var description: String {
        return web_url
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        return (object as? Article)!.web_url == web_url
    }
}

struct Headline: Codable {
    var main: String
    init(_ headline: String) {
        main = headline
    }
}

struct Multimedia: Codable {
    var url: String
    init(_ url: String) {
        self.url = url
    }
}
