//
//  LoginViewController.swift
//  SLSPracticalExam
//
//  Created by Suraj Nitinkumar Bhavsar on 01/03/20.
//  Copyright © 2020 Suraj Nitinkumar Bhavsar. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class LoginViewController: UIViewController {
    @IBOutlet weak var txtUserID: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnRmember: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInitialData()
    
        // Do any additional setup after loading the view.
    }
    
    func setupInitialData() {
        btnLogin.layer.cornerRadius = 5
        btnLogin.clipsToBounds = true
        textFieldRightButton() // Set custom Secure Entry Button on UITextField
        if (UserDefaults.standard.bool(forKey: "remember")) {
            btnRmember.tintColor = .link
            if let retrievedUserID = KeychainWrapper.standard.string(forKey: "userID") {
                txtUserID.text = retrievedUserID
            }
            if let retrievedPassword = KeychainWrapper.standard.string(forKey: "password") {
                txtPassword.text = retrievedPassword
            }
        } else {
            btnRmember.tintColor = .gray
        }
    }
    
    func textFieldRightButton() {
        let button = UIButton(type: .custom)
        let boldConfig = UIImage.SymbolConfiguration(weight: .bold)
        let secureEntry = UIImage(systemName: "eye.slash", withConfiguration: boldConfig)
        button.setImage(secureEntry, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button.frame = CGRect(x: CGFloat(txtPassword.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        button.addTarget(self, action: #selector(showHidePassword), for: .touchUpInside)
        txtPassword.rightView = button
        txtPassword.rightViewMode = .always
    }
    
    func loginValidation() {
        self.view.endEditing(true)
         
        txtUserID.text = txtUserID.text!.trimmingCharacters(in: .whitespaces)
        txtPassword.text = txtPassword.text!.trimmingCharacters(in: .whitespaces)


        guard (txtUserID.text?.count)! > 0 else {
                     
            Global().showFailureAlert(withTitle: "Alert", andMessage: "Please Enter UserID", viewController: self)
             
             return
        }

        guard Global().validateEmail(strEmail: txtUserID.text!) else {
            
            Global().showFailureAlert(withTitle: "Alert", andMessage: "Please Enter Valid UserID", viewController: self)
             
             return
        }


        guard (txtPassword.text?.count)! > 0 else {
         
            Global().showFailureAlert(withTitle: "Alert", andMessage: "Please Enter Password", viewController: self)

             return
        }

        KeychainWrapper.standard.set(txtUserID.text!, forKey: "userID")
        KeychainWrapper.standard.set(txtPassword.text!, forKey: "password")

        callLogInAPI()
    }
    
    func callLogInAPI() {
        var  paramer: [String: Any] = [:]
                        
        paramer["user_id"] = txtUserID.text
        paramer["password"] = txtPassword.text
        
        let strUrl = "Login"
                
        AFAPICaller().callAPI_POST(filePath: strUrl, params: paramer, showLoader: true, viewController: self, onSuccess: { (response, success) in
            if let response = response as? [String: AnyObject] {
                if let userData = response["data"] as? [String: AnyObject] {
                    if let archivedData = try? NSKeyedArchiver.archivedData(withRootObject: userData, requiringSecureCoding: true) {
                        UserDefaults.standard.set(archivedData, forKey: "userInfo")
                    }
                }
            }
            UserDefaults.standard.set(true, forKey: "login")
            UserDefaults.standard.synchronize()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "HomeNavigationController")
            self.view.window?.rootViewController = initialViewController
            self.view.window?.makeKeyAndVisible()
        }, onFailure: {
            
        })
    }
    
    @objc func showHidePassword() {
        
        //Toggle Show Hide
        txtPassword.isSecureTextEntry = !txtPassword.isSecureTextEntry
        let boldConfig = UIImage.SymbolConfiguration(weight: .bold)
        if (txtPassword.isSecureTextEntry) {
            let secureEntry = UIImage(systemName: "eye.slash", withConfiguration: boldConfig)
            (txtPassword.rightView as! UIButton).setImage(secureEntry, for: .normal)
        } else {
            let unSecureEntry = UIImage(systemName: "eye", withConfiguration: boldConfig)
            (txtPassword.rightView as! UIButton).setImage(unSecureEntry, for: .normal)
        }
    }
    
    @IBAction func btnRememberClicked(_ sender: Any) {
        if (UserDefaults.standard.bool(forKey: "remember")) {
            btnRmember.tintColor = .gray
            UserDefaults.standard.set(false, forKey: "remember")
        } else {
            btnRmember.tintColor = .link
            UserDefaults.standard.set(true, forKey: "remember")
        }
        UserDefaults.standard.synchronize()
    }
    @IBAction func btnLoginClicked(_ sender: Any) {
        loginValidation()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
