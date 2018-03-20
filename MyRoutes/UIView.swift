//
//  UIView.swift
//  MyRoutes
//
//  Created by Aryan Sharma on 19/03/18.
//  Copyright © 2018 Aryan Sharma. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func dropShadow(scale: Bool = true) {
        
        self.layer.cornerRadius = 2.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.masksToBounds = true
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 1.0
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = false
        self.layer.shouldRasterize = true

    }

}
