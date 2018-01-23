//
//  Repository.swift
//  desafio-ios
//
//  Created by Lucas Nascimento on 16/12/2017.
//  Copyright © 2017 Lucas Nascimento. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class Repository {
    
    static var sharedInstanceRepository: Repository?
    var nameRepository: String?
    var descriptionRepository: String?
    var full_name: String?
    var name: String?
    var username: String?
    var avatarUrl: String?
    var numberStars: String?
    var numberForks: String?
    
    init(nameRepository :String, descriptionRepository :String, name :String, full_name: String, username :String, avatarUrl :String, numberStars :String, numberForks:String){
        
        self.nameRepository = nameRepository
        self.descriptionRepository = descriptionRepository
        self.full_name = full_name
        self.name = name
        self.username = username
        self.avatarUrl = avatarUrl
        self.numberStars = numberStars
        self.numberForks = numberForks
    }
    
    init(dictionary: JSON) {
        
        let ownerData = dictionary["owner"].dictionaryValue
        
        self.nameRepository = dictionary["full_name"].stringValue
        self.descriptionRepository = dictionary["description"].stringValue
        self.full_name = dictionary["full_name"].stringValue
        self.name = dictionary["name"].stringValue
        self.username = ownerData["login"]?.stringValue
        self.numberStars = dictionary["stargazers_count"].stringValue
        self.numberForks = dictionary["forks"].stringValue
        self.avatarUrl = ownerData["avatar_url"]?.string
       
    }
    
}
