//
//  RepositoryViewController.swift
//  desafio-ios
//
//  Created by Lucas Nascimento on 16/12/2017.
//  Copyright © 2017 Lucas Nascimento. All rights reserved.
//

import UIKit
import PKHUD
import SDWebImage

class RepositoryViewController: UIViewController {
    
    //MARK: Variables
    var imageid = [String]()
    var countRow = 50
    var operations = [Operation]()
    var queue = OperationQueue()
    var loadMoreStatus = false
    var repositories: [Repository] = []
    var indexOfPageRequest = 1
    var fullNameUser: String!
    var valueToPass:String!
    var valueToPassNameRepository:String!
    
    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewMore: UIView!
    @IBOutlet weak var viewMoreTop: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var loadText: UILabel!
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewMore.isHidden = true
        self.viewMoreTop.isHidden = true
        self.viewMoreTop.frame.size.height = 0
        self.navigationItem.backBarButtonItem?.title = ""
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.registerCellNibs()
        self.loadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: Nibs
    func registerCellNibs() {
        self.tableView.register(UINib(nibName: "RepositoryTableViewCell", bundle: nil), forCellReuseIdentifier: "ReuseRepository")
    }
    
    //MARK: Request
    func loadData(){
        
        if(indexOfPageRequest <= 0)
        {
            indexOfPageRequest = 1
        }
        APIClient.sharedInstance.getJavaMostPopularRepositories(indexPage: self.indexOfPageRequest) { (success, arrayResult, error) in
            if success {
                self.repositories += arrayResult!
                self.countRow = self.repositories.count
                self.tableView.reloadData()
            }
            else {
                let alert = UIAlertController(title: "Atenção", message: error!, preferredStyle: .alert)
                
                let button = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(button)
                //self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

//MARK: Table Delegate/DataSource
extension RepositoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reuseRepository = tableView.dequeueReusableCell(withIdentifier: "ReuseRepository", for: indexPath) as! RepositoryTableViewCell
        reuseRepository.selectionStyle = UITableViewCellSelectionStyle.none
        
        let repository = self.repositories[indexPath.row]
        reuseRepository.nameRepository.text = repository.nameRepository
        reuseRepository.descriptionRepository.text = repository.descriptionRepository
        reuseRepository.username.text = repository.username
        reuseRepository.name.text = repository.name
        reuseRepository.numberForks.text = repository.numberForks
        reuseRepository.numberStars.text = repository.numberStars
        reuseRepository.photoAuthor.sd_setImage(with: URL(string: repository.avatarUrl!), placeholderImage: UIImage(named: "usuario"))
        if let full_name = repository.full_name {
            fullNameUser = "\(full_name)"
            reuseRepository.fullName = "\(full_name)"
        }
        return reuseRepository
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let indexPath = tableView.indexPathForSelectedRow
        let currentCell = tableView.cellForRow(at: indexPath!) as! RepositoryTableViewCell
        
        valueToPass = currentCell.fullName as String!
        valueToPassNameRepository = currentCell.nameRepository.text as String!
        performSegue(withIdentifier: "DetailRepositorySegue", sender: self)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height {
            self.loadMore()
        }
        
        //if tableView.contentOffset == CGPoint.zero
        //{
        //self.loadMorePrevious()
        //}
    }
    
    //MARK: Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "DetailRepositorySegue"{
            
            let viewController = segue.destination as! RepositoryDetailViewController
            if let value = valueToPass as String! {
                viewController.fullName = value
            }
            if let value = valueToPassNameRepository as String! {
                viewController.nameRepository = value
            }
        }
    }
    
    //MARK: Load Photo and Cache
    func printphoto(data: NSDictionary){
        if let jsondata1 = data["data"] as? [[String: Any]]  {
            for jsondata in jsondata1{
                let id = jsondata["id"] as! String
                imageid += [id]
                print(id)
            }
        }
    }
    
    //MARK: Infinite Scroll
    func loadMore() {
        
        HUD.show(.labeledProgress(title: "Aguarde", subtitle: "Carregando..."))
        if ( loadMoreStatus == false ) {
            self.loadMoreStatus = true
            //self.indicator.startAnimating()
            //self.viewMore.isHidden = false
            loadMoreBegin(loadMoreEnd: {(x:Int) -> () in
                self.tableView.reloadData()
                self.loadMoreStatus = false
                //self.indicator.stopAnimating()
                //self.viewMore.isHidden = true
                HUD.hide()
                HUD.flash(.success)
            })
        }
    }
    
    func loadMorePrevious()
    {
        if ( loadMoreStatus == false ) {
            UIView.animate(withDuration: 0.3, animations: {
                self.viewMoreTop.frame.size.height = 32
            })
            self.loadMoreStatus = true
            self.indicator.startAnimating()
            self.viewMoreTop.isHidden = false
            loadMoreBeginPrevious(loadMoreEnd: {(x:Int) -> () in
                self.tableView.reloadData()
                self.loadMoreStatus = false
                self.indicator.stopAnimating()
                UIView.animate(withDuration: 0.3,
                               delay: 0.1,
                               options: UIViewAnimationOptions.curveEaseIn, animations: {
                                self.viewMoreTop.frame.size.height = 0
                })
                self.viewMoreTop.isHidden = true
            })
        }
    }
    
    func loadMoreBegin(loadMoreEnd:@escaping (Int) -> ()) {
        DispatchQueue.global().async {
            self.indexOfPageRequest += 1
            self.loadData()
            sleep(2)
            DispatchQueue.main.async() {
                loadMoreEnd(0)
            }
        }
    }
    
    func loadMoreBeginPrevious(loadMoreEnd:@escaping (Int) -> ()) {
        DispatchQueue.global().async {
            self.indexOfPageRequest -= 1
            self.loadData()
            sleep(2)
            DispatchQueue.main.async() {
                loadMoreEnd(0)
            }
        }
    }
    
    
}















