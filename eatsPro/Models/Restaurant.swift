//
//  Restaurant.swift
//  eatsPro
//
//  Created by Antsumiiiiii on 4/30/22.
//

import Foundation
import SwiftyJSON

class Restaurant{
    var id: Int?
    var name: String?
    var address: String?
    var logo: String?
    var phone: String?
    
    init(json: JSON){
        self.id = json["id"].int
        self.name = json["name"].string
        self.address = json["address"].string
        self.logo = json["logo"].string
        self.phone = json["phone"].string
    }
}
