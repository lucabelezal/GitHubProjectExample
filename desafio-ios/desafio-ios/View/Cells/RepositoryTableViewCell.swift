//
//  RepositoryTableViewCell.swift
//  desafio-ios
//
//  Created by Lucas Nascimento on 16/12/2017.
//  Copyright © 2017 Lucas Nascimento. All rights reserved.
//

import UIKit

class RepositoryTableViewCell: UITableViewCell {

    @IBOutlet weak var nameRepository: UILabel!
    @IBOutlet weak var descriptionRepository: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var numberStars: UILabel!
    @IBOutlet weak var numberForks: UILabel!
    @IBOutlet weak var photoAuthor: UIImageView!
    @IBOutlet weak var forkRepositoryImage: UIImageView!
    @IBOutlet weak var starRepositoryImage: UIImageView!
    var fullName: String!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.photoAuthor.layer.cornerRadius = self.photoAuthor.frame.size.height/2
        self.photoAuthor.clipsToBounds = true
        
        self.forkRepositoryImage.image = forkRepositoryImage.image?.withRenderingMode(.alwaysTemplate)
        forkRepositoryImage.tintColor = UIColor(red:223.0/255.0, green:147.0/255.0, blue:5.0/255.0, alpha:1.0)
        
        self.starRepositoryImage.image = starRepositoryImage.image?.withRenderingMode(.alwaysTemplate)
        starRepositoryImage.tintColor = UIColor(red:223.0/255.0, green:147.0/255.0, blue:5.0/255.0, alpha:1.0)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
