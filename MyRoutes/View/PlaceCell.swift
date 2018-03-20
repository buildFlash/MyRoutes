//
//  PlaceCell.swift
//  MyRoutes
//
//  Created by Aryan Sharma on 19/03/18.
//  Copyright © 2018 Aryan Sharma. All rights reserved.
//

import UIKit
import SDWebImage

class PlaceCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var shadowView: UIView!
    
    var place: Place! {
        didSet {
            nameLabel.text = place.name
            descriptionLabel.text = place.description
            guard let url = URL(string: place.imgUrl ) else { return }
            print(url)
            imgView.sd_setImage(with: url, completed: nil)
            shadowView.dropShadow()
            
            self.imgView.layer.cornerRadius = self.imgView.frame.height / 2
            self.imgView.layer.masksToBounds = false
            self.imgView.clipsToBounds = true

        }
    }    
}
