//
//  BeerPageViewController.swift
//  BeerTracker
//
//  Created by user166111 on 4/29/20.
//  Copyright © 2020 FMI. All rights reserved.
//

import UIKit

class BeerPageViewController: UIViewController {
    
    @IBOutlet weak var challengeButton: UIButton!
    @IBOutlet weak var wishlistButton: UIButton!
    @IBOutlet weak var checkinButton: UIButton!
    
    //let beer : Beer
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.challengeButton.layer.cornerRadius = 10
        self.challengeButton.layer.borderWidth = 0.3
        self.wishlistButton.layer.cornerRadius = 10
        self.wishlistButton.layer.borderWidth = 0.3
        self.checkinButton.layer.cornerRadius = 10
        self.checkinButton.layer.borderWidth = 0.3
        
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func challengeButtonTapped(_ sender: Any) {
    }
    

    @IBAction func wishlistButtonTapped(_ sender: Any) {
    }
    
    @IBAction func checkinButton(_ sender: Any) {
    }
    
}
