//
//  LoginVC.swift
//  MyRoutes
//
//  Created by Aryan Sharma on 19/03/18.
//  Copyright © 2018 Aryan Sharma. All rights reserved.
//

import UIKit
import FirebaseAuth
import SVProgressHUD

class LoginVC: UIViewController, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        disableLoginBtn()
        setupTextFields()
    }
    
    //MARK:- Methods
    
    fileprivate func setupTextFields() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }
    
    fileprivate func enableLoginBtn() {
        loginBtn.isEnabled = true
        loginBtn.alpha = 1.0
    }
    
    fileprivate func disableLoginBtn() {
        loginBtn.isEnabled = false
        loginBtn.alpha = 0.5
    }
    
    @objc fileprivate func editingChanged() {
        if isValidEmail(testStr: emailTextField.text!) && passwordTextField.text?.count != 0 {
            enableLoginBtn()
        } else {
            disableLoginBtn()
        }
    }
    
    fileprivate func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    //MARK:- IBActions
    @IBAction func loginBtnPressed(_ sender: Any) {
        SVProgressHUD.show()
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if let error = error as NSError? {
                print("Error logging in: \(error) \(error.localizedDescription)")
               
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                SVProgressHUD.dismiss()
                self.present(alert, animated: true, completion: nil)

                return
            }
            
            if let user = user {
                print("Successfully logged in")
                print(user.uid)
                print(user.email ?? "")
                
                self.completeSignIn()
            }
        }
    }
    
    fileprivate func completeSignIn() {
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        SVProgressHUD.dismiss()
        let delegateTemp = UIApplication.shared.delegate
        delegateTemp?.window!?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
    }
    
    //MARK: TextFieldDelegates
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
}
