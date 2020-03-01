//
//  HomeViewController.swift
//  SLSPracticalExam
//
//  Created by Suraj Nitinkumar Bhavsar on 01/03/20.
//  Copyright © 2020 Suraj Nitinkumar Bhavsar. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    var frameArray = [String]()

    @IBOutlet weak var txtParse: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readDataFromPlist()
        // Do any additional setup after loading the view.
    }
    
    func readDataFromPlist() {
        if let path = Bundle.main.path(forResource: "Test_Frames", ofType: "plist") {

            //If your plist contain root as Array
            if let array = NSArray(contentsOfFile: path) as? [String] {
                frameArray = array
            }
        }
    }
    
    @IBAction func btnParseString(_ sender: Any) {
        var parseString = ""
        for frameObj in frameArray {
            parseString = parseString + Global().hexStringtoAscii(frameObj)
        }
        txtParse.text = parseString
    }
    
    
    @IBAction func btnProfileClicked(_ sender: Any) {
        let ProfileViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        self.navigationController?.pushViewController(ProfileViewController, animated: true)
    }
    
    @IBAction func btnLogOutClicked(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout", preferredStyle: UIAlertController.Style.alert)
        let logoutAction = UIAlertAction(title: "Logout", style: .default) { (action) in
            UserDefaults.standard.set(false, forKey: "login")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "LoginNavigationController")
            self.view.window?.rootViewController = initialViewController
            self.view.window?.makeKeyAndVisible()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addAction(logoutAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
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
