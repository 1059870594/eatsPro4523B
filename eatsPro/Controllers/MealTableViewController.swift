//
//  MealTableViewController.swift
//  eatsPro
//
//  Created by Antsumiiiiii on 4/28/22.
//

import UIKit

class MealTableViewController: UITableViewController {
    
    var restaurant: Restaurant?
    var meals = [Meal]()

    override func viewDidLoad() {
        super.viewDidLoad()

        if let restaurantName = restaurant?.name{
            self.navigationItem.title = restaurantName
        }
        
        self.fetchMeal()
    }
    
    func fetchMeal(){
        if let restaurantId = restaurant?.id{
            APIManager.session.getMeals(restaurantId: restaurantId) { json in
                if json != nil {
                    print(json!)
                    
                    self.meals = []
                    if let meals = json!["foodItems"].array {
                        for i in meals{
                            self.meals.append(Meal(json: i))
                        }
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return meals.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MealCell", for: indexPath) as! MealViewCell

        let meal = meals[indexPath.row]
        cell.mealName.text = meal.name
        cell.labelMealDescription.text = meal.description
        cell.labelMealPrice.text = "$\(meal.price!)"

        if let image = meal.image {
            Utils.loadImage(cell.imageMealImage,"\(image)")
        }
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
