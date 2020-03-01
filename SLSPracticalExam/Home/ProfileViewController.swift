//
//  ProfileViewController.swift
//  SLSPracticalExam
//
//  Created by Suraj Nitinkumar Bhavsar on 01/03/20.
//  Copyright © 2020 Suraj Nitinkumar Bhavsar. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblFirstName: UILabel!
    @IBOutlet weak var lblLastName: UILabel!
    @IBOutlet weak var lblMobileNo: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Profile"
        imgUser.layer.cornerRadius = 60
        imgUser.clipsToBounds = true
        setUserDatail()
        // Do any additional setup after loading the view.
    }
    
    func setUserDatail() {
        if let archivedData = UserDefaults.standard.data(forKey: "userInfo"), let userInfo = (try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(archivedData)) as? [String: AnyObject] {
            
            if let userName = userInfo["username"] as? String {
                lblUserName.text = "User Name:  \(userName)"
            }
            
            if let firstName = userInfo["first_name"] as? String {
                lblFirstName.text = "First Name:  \(firstName)"
            }
            
            if let lastName = userInfo["last_name"] as? String {
                lblLastName.text = "Last Name:  \(lastName)"
            }
            
            if let mobileNo = userInfo["mobile"] as? String {
                lblMobileNo.text = "Mobile No:  \(mobileNo)"
            }
            
            if let imagebase64String = userInfo["user_image"] as? String{
                let imageData = NSData(base64Encoded: imagebase64String, options: .ignoreUnknownCharacters)
                imgUser.image = UIImage.init(data: imageData! as Data)
            }
        }
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
