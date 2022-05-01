
import Foundation
import Alamofire
import SwiftyJSON
import FBSDKLoginKit
import Photos

class APIManager {
    
    static let session = APIManager()
    
    let initURL = NSURL(string: BASE_URL)
    var accessToken = ""
    var refreshToken = ""
    var expired = Date()
    
    // API func for login
    func login(userType: String, completionHandler: @escaping(NSError?) -> Void) {
        let path = "api/facebook/convert-token/"
        let url = initURL!.appendingPathComponent(path)
        let params: [String: Any] = [
            "grant_type": "convert_token",
            "client_id": CLIENT_ID,
            "client_secret": CLIENT_SECRET,
            "backend": "facebook",
            "token": AccessToken.current!.tokenString,
            "user_type": "customer"
        ]
        
        AF.request(url!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            switch response.result {
                case .success(let value):
                    let jsonData = JSON(value)
                    print(jsonData)
                    self.accessToken = jsonData["access_token"].string!
                    self.refreshToken = jsonData["refresh_token"].string!
                    self.expired = Date().addingTimeInterval(TimeInterval(jsonData["expires_in"].int!))
                    completionHandler(nil)
                    break
                
                case .failure(let error):
                    completionHandler(error as NSError?)
                    break
            }
        }
    }
    
    // API func for logout
    func logout(completionHandler: @escaping(NSError?) -> Void) {
        let path = "api/facebook/revoke-token/"
        let url = initURL!.appendingPathComponent(path)
        let params: [String: Any] = [
            "client_id": CLIENT_ID,
            "client_secret": CLIENT_SECRET,
            "token": self.accessToken
        ]
        
        AF.request(url!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            switch response.result {
                case .success:
                    completionHandler(nil)
                    break
                
                case .failure(let error):
                    completionHandler(error as NSError?)
                    break
            }
        }
    }
    
    // API to refresh the access token when it's expired
    func refreshTokenIfNeed(completionHandler: @escaping() -> Void) {
        let path = "api/facebook/refresh-token/"
        let url = initURL!.appendingPathComponent(path)
        let params: [String: Any] = [
            "access_token": self.accessToken,
            "refresh_token": self.refreshToken
        ]
        
        if Date() > self.expired{
            AF.request(url!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil)
                .responseJSON { response in
                    switch response.result {
                        case .success(let value):
                            let jsonData = JSON(value)
                            
                            self.accessToken = jsonData["access_token"].string!
                            
                            self.expired = Date().addingTimeInterval(TimeInterval(jsonData["expires_in"].int!))
                            completionHandler()
                            break
                        
                        case .failure:
                            break
                    }
            
            }
        }else{
            completionHandler()
        }
    }
    
    
    //Request Server function
    func requestServer(_ method: Alamofire.HTTPMethod, _ path: String,_ params: [String: Any]?,_ encoding: ParameterEncoding, _ completionHandler: @escaping(JSON?) -> Void) {
        
        let url = initURL?.appendingPathComponent(path)
        
        refreshTokenIfNeed {
            AF.request(url!, method: method, parameters: params, encoding: encoding)
                .responseJSON{ response in
                    switch response.result{
                    case .success(let value):
                        let jsonData = JSON(value)
                        completionHandler(jsonData)
                        break
                    
                    case .failure(let error):
                        print(error.errorDescription!)
                        completionHandler(nil)
                        break
                    }
                }
        }
    }

    
    // API to refresh all restaurants
    func getRestaurants(completionHandler: @escaping(JSON?) -> Void) {
        let path = "api/customer/restaurant/"
        requestServer(.get, path, nil, JSONEncoding.default, completionHandler)
    }
    
    // API to fetch all meals of a restaurant
    func getMeals(restaurantId: Int, completionHandler: @escaping(JSON?) -> Void){
        let path = "api/customer/meals/\(restaurantId)"
        requestServer(.get, path, nil, JSONEncoding.default, completionHandler)
    }
}

