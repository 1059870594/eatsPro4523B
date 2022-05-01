//
//  RestaurantViewController.swift
//  eatsPro
//
//  Created by Antsumiiiiii on 4/28/22.
//

import UIKit

class RestaurantViewController: UIViewController {

    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    
    @IBOutlet weak var tableViewRestaurant: UITableView!
    
    var restaurants = [Restaurant]() //a list of restaurants
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil{
            menuBarButton.target = self.revealViewController()
            menuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        self.fetchRestaurants()
        // Do any additional setup after loading the view.
    }
    

    func fetchRestaurants(){
        APIManager.session.getRestaurants{ json in
            if json != nil{
                //print(json!)
                
                self.restaurants = []
                if let listRes = json!["restaurants"].array{
                    for item in listRes{
                        let restaurant = Restaurant(json: item)
                        self.restaurants.append(restaurant)
                    }
                }
                
                self.tableViewRestaurant.reloadData()
                
                
            }
            
        }
    }
    
    func loadImage(imageView : UIImageView, urlString: String){
        let imgURL: URL = URL(string: urlString)!
        URLSession.shared.dataTask(with: imgURL){
            (data, response, error) in
            guard let data = data, error == nil else { return }
            
            DispatchQueue.main.async{
                imageView.image = UIImage(data: data)
            }
        }.resume()
    }

}

extension RestaurantViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.restaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell", for: indexPath) as! RestaurantViewCell
        
        let restaurant: Restaurant
        restaurant = restaurants[indexPath.row]
        
        cell.labelResName.text = restaurant.name
        cell.labelResAddress.text = restaurant.address
        
        if let logo = restaurant.logo{
            let url = "\(logo)"
            loadImage(imageView: cell.imageResLogo, urlString: url)
        }
        
        return cell
    }
    
}
