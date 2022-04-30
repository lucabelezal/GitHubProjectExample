//
//  RepositoryDetailViewController.swift
//  desafio-ios
//
//  Created by Lucas Nascimento on 16/12/2017.
//  Copyright © 2017 Lucas Nascimento. All rights reserved.
//

import UIKit
import PKHUD

class RepositoryDetailViewController: UIViewController {
    
    //MARK: Variables
    var pull: PullRequests?
    var repository: Repository?
    var pullRequests: [PullRequests] = []
    var repositoryName: String!
    var fullName: String!
    var nameRepository: String!
    var countRow = 50
    
    //MARK: Outlets
    @IBOutlet weak var tableViewDetail: UITableView!
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = nameRepository
        
        self.tableViewDetail.delegate = self
        self.tableViewDetail.dataSource = self
        self.registerCellNibs()
        
        if fullName != nil {
            loadPullRequestData(name:fullName!)
        }
    }
    
    //MARK: Nibs
    func registerCellNibs() {
        self.tableViewDetail.register(UINib(nibName: "DetailRepositoryTableViewCell", bundle: nil), forCellReuseIdentifier: "ReuseRepositoryDetail")
        self.tableViewDetail.register(UINib(nibName: "HeaderDetailRepositoryTableViewCell", bundle: nil), forCellReuseIdentifier: "ReuseHeaderRepositoryDetail")
    }
    
    //MARK: Request
    func loadPullRequestData(name: String){
        HUD.show(.labeledProgress(title: "Aguarde", subtitle: "Carregando..."))
        APIClient.sharedInstance.getPullRequestsFromRepository(fullName: name) { (success, arrayResult, error) in
            if success {
                self.pullRequests = arrayResult!
                self.countRow = self.pullRequests.count
                self.tableViewDetail.reloadData()
                HUD.hide()
            }
            else {
                HUD.hide()
                let alert = UIAlertController(title: "Atenção", message: error!, preferredStyle: .alert)
                
                let button = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(button)
                //self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

//MARK: Table Delegate/DataSource
extension RepositoryDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pullRequests.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReuseHeaderRepositoryDetail") as! HeaderDetailRepositoryTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reuseRepository = tableView.dequeueReusableCell(withIdentifier: "ReuseRepositoryDetail", for: indexPath) as! DetailRepositoryTableViewCell
        reuseRepository.selectionStyle = UITableViewCellSelectionStyle.none
        
        let pullRequest = self.pullRequests[indexPath.row]
        reuseRepository.title.text = pullRequest.title
        reuseRepository.body.text = pullRequest.body
        reuseRepository.name.text = pullRequest.name
        reuseRepository.photo.sd_setImage(with: URL(string: pullRequest.avatarUrl!), placeholderImage: UIImage(named: "usuario"))
        
        if let value = pullRequest.date {
            reuseRepository.date.text = Helper.convertDateFormatter(date: value)
        }
        return reuseRepository
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableViewDetail.deselectRow(at: indexPath, animated: true)
        UIApplication.shared.openURL(self.pullRequests[indexPath.row].htmlUrl!)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150;
    }
}

