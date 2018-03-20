//
//  SidebarVC.swift
//  MyRoutes
//
//  Created by Aryan Sharma on 20/03/18.
//  Copyright © 2018 Aryan Sharma. All rights reserved.
//

import UIKit
import FirebaseAuth

class SidebarVC: UIViewController {
    
    @IBOutlet weak var profImgView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        profImgView.layer.cornerRadius = profImgView.frame.height / 2
        title = "Hello There!"
    }

    
    @IBAction func logoutBtnPressed(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "isLoggedIn")
        try! Auth.auth().signOut()
        self.dismiss(animated: false, completion: nil)
        UIApplication.shared.delegate?.window!?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC")
    }
    

}
