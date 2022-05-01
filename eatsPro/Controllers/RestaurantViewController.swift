//
//  RestaurantViewController.swift
//  eatsPro
//
//  Created by Antsumiiiiii on 4/28/22.
//

import UIKit
import SkeletonView

class RestaurantViewController: UIViewController {

    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    
    @IBOutlet weak var tableViewRestaurant: UITableView!
    
    @IBOutlet weak var searchBarRestaurant: UISearchBar!
    
    var restaurants = [Restaurant]() //a list of restaurants
    var filterdRestaurants = [Restaurant]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil{
            menuBarButton.target = self.revealViewController()
            menuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        self.tableViewRestaurant.showAnimatedGradientSkeleton(
            usingGradient: .init(baseColor: .concrete),
            animation: nil,
            transition: .crossDissolve(0.25)
        )
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.fetchRestaurants()
        }
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "ViewMealList"{
            let controller = segue.destination as! MealTableViewController
            controller.restaurant = restaurants[(tableViewRestaurant.indexPathForSelectedRow!.row)] //should be able to display resName on top
        }
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
                
                self.tableViewRestaurant.stopSkeletonAnimation()
                self.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
                
                self.tableViewRestaurant.reloadData()
                
                
            }
            
        }
    }

}

extension RestaurantViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterdRestaurants = self.restaurants.filter({ (res: Restaurant) -> Bool in
            return res.name?.lowercased().range(of: searchText.lowercased()) != nil
        })
        
        self.tableViewRestaurant.reloadData()
    }
}

extension RestaurantViewController: SkeletonTableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchBarRestaurant.text != ""{
            return self.filterdRestaurants.count
        }
        return self.restaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell", for: indexPath) as! RestaurantViewCell
        
        let restaurant: Restaurant
        
        if searchBarRestaurant.text != ""{
            restaurant = filterdRestaurants[indexPath.row]
        }else{
            restaurant = restaurants[indexPath.row]
        }
        
        cell.labelResName.text = restaurant.name
        cell.labelResAddress.text = restaurant.address
        
        if let logo = restaurant.logo{
            let url = "\(logo)"
            Utils.loadImage(cell.imageResLogo, url)
        }
        
        return cell
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "RestaurantCell"
    }
}
