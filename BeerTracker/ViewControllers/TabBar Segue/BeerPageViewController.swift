//
//  BeerPageViewController.swift
//  BeerTracker
//
//  Created by user166111 on 4/29/20.
//  Copyright © 2020 FMI. All rights reserved.
//

import UIKit
import Firebase

class BeerPageViewController: UIViewController {
    
    @IBOutlet weak var background: UILabel!
    @IBOutlet weak var challengeButton: UIButton!
    @IBOutlet weak var wishlistButton: UIButton!
    @IBOutlet weak var checkinButton: UIButton!
    
    @IBOutlet weak var markWishlist: UIImageView!
    @IBOutlet weak var markCheckin: UIImageView!
    @IBOutlet weak var markChallenge: UIImageView!
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelBrewery: UILabel!
    @IBOutlet weak var labelType: UILabel!
    @IBOutlet weak var labelABV: UILabel!
    
    var beer = Beer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("GOT BEER: \(beer.name!)")
        print("with mark: \(beer.mark!)")
        print("")
        
        setupView()
        
        
        // Do any additional setup after loading the view.
    }
    
    func setupView(){
        self.background.layer.cornerRadius = 10
        self.background.layer.masksToBounds = true
        
        self.wishlistButton.layer.cornerRadius = 10
        self.wishlistButton.layer.borderWidth = 0.2
        self.wishlistButton.layer.borderColor = UIColor.darkGray.cgColor
        self.challengeButton.layer.cornerRadius = 10
        self.challengeButton.layer.borderWidth = 0.2
        self.challengeButton.layer.borderColor = UIColor.darkGray.cgColor
        self.checkinButton.layer.cornerRadius = 10
        self.checkinButton.layer.borderWidth = 0.3
        
        if beer.mark == "checkin"{
            self.markCheckin.alpha = 1
            self.markWishlist.alpha = 0
            self.markChallenge.alpha = 0
            self.checkinButton.setTitle("CHECK-IN again", for: .normal)
            self.wishlistButton.alpha = 0
        }
        else if beer.mark == "wish"{
            self.markCheckin.alpha = 0
            self.markWishlist.alpha = 1
            self.markChallenge.alpha = 0
            self.wishlistButton.alpha = 0
        }
        else if beer.mark == "challenge"{
            self.markCheckin.alpha = 0
            self.markWishlist.alpha = 0
            self.markChallenge.alpha = 1
            self.wishlistButton.alpha = 1
        }
        else{
            self.markCheckin.alpha = 0
            self.markWishlist.alpha = 0
            self.markChallenge.alpha = 0
            self.wishlistButton.alpha = 1
        }
        
        self.labelName.text = beer.name!
        self.labelBrewery.text = beer.brewery!
        self.labelType.text = beer.type!
        self.labelABV.text = beer.ABV! + " ABV"
        
    }
    
    @IBAction func challengeButtonTapped(_ sender: Any) {
    }

    @IBAction func wishlistButtonTapped(_ sender: Any) {
    }
    
    @IBAction func checkinButton(_ sender: Any) {
    }
    
}
