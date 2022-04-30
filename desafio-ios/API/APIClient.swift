//
//  APIClient.swift
//  desafio-ios
//
//  Created by Lucas Nascimento on 16/12/2017.
//  Copyright © 2017 Lucas Nascimento. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire



class APIClient {
    
    static let sharedInstance = APIClient()
    
    static let SERVER_NAME = "https://api.github.com/"
    var url: String = "search/repositories?q=language:Java&sort=stars&page="
    var urlPullRequests: String = "repos/iluwatar/java-design-patterns/pulls"
    
    
    final class private func get(path: String, completion: @escaping (_ success: Bool, _ data: JSON?) -> ()) {
        
        let endpoint = SERVER_NAME + path
        
        Alamofire.request(endpoint, method: .get, encoding: URLEncoding.default).validate().responseJSON { response in
            
            switch response.result {
                case .success:
                    guard let responseValue = response.result.value  else {
                        completion(false, nil)
                        return
                    }

                    let responseJSON = JSON(responseValue)

                    completion(true, responseJSON)

                case .failure(_):
                    if response.response?.statusCode == 200 {
                        print("JSON could not be serialized or Data nil")
                        completion( true, nil)

                    }
                    completion( false, nil)
                }
        }
    }
    
    //MARK: GET Methods
    func getJavaMostPopularRepositories(indexPage: Int, completion: @escaping (_ success: Bool, _ dataResponse: [Repository]?, _ errorMessage: String?) -> ()){
        
        APIClient.get(path: "\(url)\(indexPage)") { (success, dataResponse) in
            if success {
                
                let results = dataResponse?["items"].arrayValue
                
                if results != nil {
                    
                    var repositoriesArray = [Repository]()
                    for value in results! {
                        let repository = Repository(dictionary: value)
                        repositoriesArray.append(repository)
                    }
                    
                    completion(success, repositoriesArray, nil)
                } else {
                    completion(false, nil, "Houve um problema de comunicação com os servidores. Tente novamente mais tarde.")
                }
            } else {
                completion(success, nil, "Não há dados a serem exibidos.")
                
            }
        }
    }
    
    func getPullRequestsFromRepository(fullName: String, completion: @escaping (_ success: Bool, _ dataResponse: [PullRequests]?, _ errorMessage: String?) -> ()){
        
        APIClient.get(path: "repos/\(fullName)/pulls") { (success, dataResponse) in
            if success {
                
                let results = dataResponse?.arrayValue
                
                if results != nil {
                    
                    var pullRequestsArray = [PullRequests]()
                    for value in results! {
                        let pullRequest = PullRequests(dictionary: value)
                        pullRequestsArray.append(pullRequest)
                    }
                    
                    completion(success, pullRequestsArray, nil)
                } else {
                    completion(false, nil, "Houve um problema de comunicação com os servidores. Tente novamente mais tarde.")
                }
            } else {
                completion(success, nil, "Não há dados a serem exibidos.")
            }
        }
    }
    
}


