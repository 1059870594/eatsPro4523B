//
//  MealDetailsViewController.swift
//  eatsPro
//
//  Created by Antsumiiiiii on 4/28/22.
//

import UIKit

class MealDetailsViewController: UIViewController {

    @IBOutlet weak var buttonMinus: UIButton!
    @IBOutlet weak var buttonPlus: UIButton!
    
    @IBOutlet weak var imageMealIamge: UIImageView!
    @IBOutlet weak var labelMealName: UILabel!
    @IBOutlet weak var labelMealDescription: UILabel!
    
    @IBOutlet weak var labelQty: UILabel!
    @IBOutlet weak var labelTotal: UILabel!
    @IBOutlet weak var buttonAddToCart: UIButton!
    
    var meal: Meal?
    var qty = 1;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.formatButtons()
        self.fetchMeal()
        
    }
    

    func formatButtons(){
        buttonMinus.layer.cornerRadius = buttonMinus.frame.width / 2
        buttonMinus.layer.masksToBounds = true

        buttonMinus.backgroundColor = .clear
        buttonMinus.layer.borderWidth = 1
        buttonMinus.layer.borderColor = UIColor.systemGray5.cgColor

        buttonPlus.layer.cornerRadius = buttonMinus.frame.width / 2
        buttonPlus.layer.masksToBounds = true

        buttonPlus.backgroundColor = .clear
        buttonPlus.layer.borderWidth = 1
        buttonPlus.layer.borderColor = UIColor.systemGray5.cgColor
    }
    
    func fetchMeal() {
        self.labelQty.text = "\(qty)"
        self.labelMealName.text = meal?.name
        self.labelMealDescription.text = meal?.description
        if let price = meal?.price {
            labelTotal.text = "$\(price)"
            
        }
                
        if let imageUrl = meal?.image {
            Utils.loadImage(imageMealIamge, "\(imageUrl)")
        }
    }
    
    // Mark: -Cart
    @IBAction func decreaseQty(_ sender: Any) {
        if qty >= 2 {
            qty -= 1
            labelQty.text = String(qty)
            
            let newText = "Add \(qty) To Cart"
            buttonAddToCart.setTitle(newText, for: .normal)
            
            if let price = meal?.price {
                labelTotal.text = "$\(price * Float(qty))"
            }
        }
    }
    
    @IBAction func increaseQty(_ sender: Any) {
        if qty < 99 {
            qty += 1
            labelQty.text = String(qty)
            
            let newText = "Add \(qty) To Cart"
            buttonAddToCart.setTitle(newText, for: .normal)
            
            if let price = meal?.price {
                labelTotal.text = "$\(price * Float(qty))"
            }
        }
    }
    
    @IBAction func addToCart(_ sender: Any) {
    }
    
}
