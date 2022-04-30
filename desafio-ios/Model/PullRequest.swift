//
//  PullRequest.swift
//  desafio-ios
//
//  Created by Lucas Nascimento on 17/12/2017.
//  Copyright © 2017 Lucas Nascimento. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class PullRequests  {
    
    static var sharedInstancePullRequests: PullRequests?
    var name: String?
    var avatarUrl: String?
    var title: String?
    var date: String?
    var body: String?
    var htmlUrl: URL?

    init(name: String, avatarUrl: String, title: String, date: String, body: String, htmlUrl: URL){
        self.name = name
        self.avatarUrl = avatarUrl
        self.title = title
        self.date = date
        self.body = body
        self.htmlUrl = htmlUrl
    }
    
    init(dictionary: JSON) {
        
        let user = dictionary["user"].dictionaryValue
        
        self.name = user["login"]?.stringValue
        self.avatarUrl = user["avatar_url"]?.string
        self.title = dictionary["title"].stringValue
        self.date = dictionary["created_at"].stringValue
        self.body = dictionary["body"].stringValue
        self.htmlUrl = dictionary["html_url"].url
    }
    
}

