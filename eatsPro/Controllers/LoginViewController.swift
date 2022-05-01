//
//  LoginViewController.swift
//  eatsPro
//
//  Created by Antsumiiiiii on 4/29/22.
//

import UIKit
import FBSDKLoginKit
import AVFoundation


class LoginViewController: UIViewController {

    @IBOutlet weak var buttonLogin: UIButton!
    
    var userType: String = USERTYPE_CUSTOMER
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if(AccessToken.current != nil){
            FBManager.getUserProfile {
                self.buttonLogin.setTitle("Continue as \(User.currUser.name!)", for: .normal)
                self.buttonLogin.sizeToFit()
            }
        }
    }
    
    func redirect() {
        if let token = AccessToken.current, !token.isExpired{
            print(AccessToken.current!.tokenString)
            performSegue(withIdentifier: "CustomerView", sender: self)
            //that means user logs in, move to next view controller
        }
    }
    
    @IBAction func fbLogin(_ sender: Any) {
        if (AccessToken.current != nil) { //that means it is not none
            APIManager.session.login(userType: userType) { error in
                if error == nil {
                    self.redirect()
                }
            }
        } else {
            FBManager.session.logIn(permissions: ["public_profile", "email"], from: self) {
                Result, Error in
                if (Error == nil) { //means no error
                    FBManager.getUserProfile {
                        APIManager.session.login(userType: self.userType) { error in
                            if error == nil {
                                self.redirect()
                            }
                        }
                    }
                }
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
