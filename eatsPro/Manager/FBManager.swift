//
//  FBManager.swift
//  eatsPro
//
//  Created by Antsumiiiiii on 4/29/22.
//

import Foundation
import FBSDKLoginKit
import SwiftyJSON

class FBManager {
    static let session = LoginManager()
    
    public class func getUserProfile(completionHandler: @escaping() -> Void) {
        
        if let token = AccessToken.current, !token.isExpired {
            GraphRequest(graphPath: "me", parameters: ["fields" : "name, email, picture.type(normal)"])
                .start { connection, result, error in
                    if error == nil {//no error
                        let json = JSON(result!)
                        print(json)
                        
                        User.currUser.setInfo(json: json)
                        
                        completionHandler()
                    }
                }
        }
        
    }
}
