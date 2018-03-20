//
//  NearbyCell.swift
//  MyRoutes
//
//  Created by Aryan Sharma on 20/03/18.
//  Copyright © 2018 Aryan Sharma. All rights reserved.
//

import UIKit

class NearbyCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var shadowView: UIView!
    
    var nearby: MapService.NearbySearchResult! {
        didSet{
            titleLabel.text = nearby.name
            subtitleLabel.text = nearby.name + " lies in the vicinty of " + nearby.vicinity!
            //fetch 1st image form reference
            if nearby.photos != nil {
                if UserDefaults.standard.data(forKey: nearby.name) == nil {
                    MapService.shared.fetchPhoto(photo: nearby.photos[0]) { (data) in
                        self.imgView.image = UIImage(data: data)
                        UserDefaults.standard.set(data, forKey: self.nearby.name)
                    }
                } else {
                    let data = UserDefaults.standard.data(forKey: nearby.name)
                    self.imgView.image = UIImage(data: data!)
                }
            }
            self.imgView.layer.cornerRadius = self.imgView.frame.height/2
            self.imgView.layer.masksToBounds = false
            self.imgView.clipsToBounds = true
            shadowView.dropShadow()
        }
    }
}
