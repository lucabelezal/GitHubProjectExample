//
//  DetailRepositoryTableViewCell.swift
//  desafio-ios
//
//  Created by Lucas Nascimento on 17/12/2017.
//  Copyright © 2017 Lucas Nascimento. All rights reserved.
//

import UIKit

class DetailRepositoryTableViewCell: UITableViewCell {
        
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var body: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var photo: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.photo.layer.cornerRadius = self.photo.frame.size.height/2
        self.photo.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
