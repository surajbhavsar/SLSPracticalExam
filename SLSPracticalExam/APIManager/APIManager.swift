//
//  APIManager.swift
//  SLSPracticalExam
//
//  Created by Suraj Nitinkumar Bhavsar on 01/03/20.
//  Copyright © 2020 Suraj Nitinkumar Bhavsar. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

class AFAPICaller: NSObject {
    typealias AFAPICallerSuccess = (_ responseData: Any, _ success: Bool) -> Void
    typealias AFAPICallerFailure = () -> Void
    
    func callAPI_POST(filePath: String, params: [String: Any]?, showLoader: Bool, viewController: UIViewController, onSuccess: @escaping (AFAPICallerSuccess), onFailure: @escaping (AFAPICallerFailure)) {
        
        guard Connectivity.isConnectedToInternet() else {
            
            Global().showFailureAlert(withTitle: "Alert", andMessage: "Please Check your internet connection", viewController: viewController)

            return
        }
        
        if (showLoader) {
            MBProgressHUD.showAdded(to: viewController.view, animated: true)
        }
        
        let strPath = Global.baseURL + filePath;
        
        let headers = ["Content-Type": "application/json"]
                
        request(strPath, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            if (showLoader) {
                MBProgressHUD.hide(for: viewController.view, animated: true)
            }
            if response.result.isSuccess {
                if let dictResponse = response.result.value  as? [String:Any] {
                    if let status = dictResponse["returnStatus"] as? Bool, status == true{
                        onSuccess(dictResponse, true)
                    } else {
                        if let message = dictResponse["message"] as? String {
                            Global().showFailureAlert(withTitle: "Alert", andMessage: message, viewController: viewController)
                        } else{
                            Global().showFailureAlert(withTitle: "Alert", andMessage: "Someting Went Wrong", viewController: viewController)
                        }
                        onFailure()
                    }
                }
            } else {
                Global().showFailureAlert(withTitle: "Alert", andMessage: response.result.error!.localizedDescription, viewController: viewController)
                onFailure()
            }
        }
    }
}
