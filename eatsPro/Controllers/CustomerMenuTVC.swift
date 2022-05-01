//
//  CustomerMenuTVC.swift
//  eatsPro
//
//  Created by Antsumiiiiii on 4/29/22.
//

import UIKit

class CustomerMenuTVC: UITableViewController {

    @IBOutlet weak var Avatar: UIImageView!
    @IBOutlet weak var labelTag: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        labelTag.text = User.currUser.name
        Avatar.image = try! UIImage(data: Data(contentsOf: URL(string: User.currUser.pictureURL!)!))
        Avatar.layer.cornerRadius = 35
        Avatar.layer.borderWidth = 1
        Avatar.layer.borderColor = UIColor.white.cgColor
        Avatar.clipsToBounds = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CustomerLogout" {
            APIManager.session.logout { error in
                if error == nil {
                    FBManager.session.logOut() //log out user
                    User.currUser.resetInfo() //reset the user information
                    
                    let board = UIStoryboard(name: "Main", bundle: nil)
                    let loginViewController = board.instantiateViewController(withIdentifier: "MainController") as! LoginViewController
                    self.view.window?.rootViewController = loginViewController
                    
                }
            }
        }
    }

}
