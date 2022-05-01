//
//  PaymentViewController.swift
//  eatsPro
//
//  Created by Antsumiiiiii on 4/28/22.
//

import UIKit
import Lottie
import Stripe

class PaymentViewController: UIViewController {

    @IBOutlet weak var animeView: AnimationView!
    @IBOutlet weak var cardTextField: STPPaymentCardTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animeView.contentMode = .scaleAspectFit
        animeView.animationSpeed = 1
        animeView.loopMode = .loop
        animeView.play()
        // Do any additional setup after loading the view.
        
        cardTextField.postalCodeEntryEnabled = false
        
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
