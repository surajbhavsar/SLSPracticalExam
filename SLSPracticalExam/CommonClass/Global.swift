//
//  Global.swift
//  SLSPracticalExam
//
//  Created by Suraj Nitinkumar Bhavsar on 01/03/20.
//  Copyright © 2020 Suraj Nitinkumar Bhavsar. All rights reserved.
//

import UIKit

class Global: NSObject {
    
    static let baseURL = "http://192.99.13.59:8081/user/v2/"
    static let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func validateEmail(strEmail: String) -> Bool {
        let emailRegex: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: strEmail)
    }
    
    func showFailureAlert(withTitle title: String, andMessage
        message:String, viewController: UIViewController){
        let alert = UIAlertController(title: title, message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style:
            UIAlertAction.Style.default, handler: nil))
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func hexStringtoAscii(_ hexString : String) -> String {

        let pattern = "(0x)?([0-9a-f]{2})"
        let regex = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let nsString = hexString as NSString
        let matches = regex.matches(in: hexString, options: [], range: NSMakeRange(0, nsString.length))
        let characters = matches.map {
            Character(UnicodeScalar(UInt32(nsString.substring(with: $0.range(at: 2)), radix: 16)!)!)
        }
        return String(characters)
    }
}

