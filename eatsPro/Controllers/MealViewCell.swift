//
//  MealViewCell.swift
//  eatsPro
//
//  Created by Antsumiiiiii on 5/1/22.
//

import UIKit

class MealViewCell: UITableViewCell {

    @IBOutlet weak var imageMealImage: UIImageView!
    @IBOutlet weak var mealName: UILabel!
    @IBOutlet weak var labelMealDescription: UILabel!
    @IBOutlet weak var labelMealPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
