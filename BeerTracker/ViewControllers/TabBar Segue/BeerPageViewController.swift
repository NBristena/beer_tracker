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
    
    @IBOutlet weak var background: UIView!
    
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
    var userBeersDb = Firestore.firestore().collection("users/\(Auth.auth().currentUser!.uid)/beers")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("GOT TO SEGUE")
        if segue.identifier == "createChallenge"{
            //if let cell = sender as? UITableViewCell, let indexPath = self.tableView.indexPath(for: cell){
            print("GOT INTO TRANSITION")
            let challengePage = segue.destination as? createChallengeViewController
                challengePage!.beer = beer
            //}
        }
    }
    

    @IBAction func challengeButtonTapped(_ sender: Any) {
        print("TAPPED THE BUTTON")
    }

    @IBAction func wishlistButtonTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "",
                                      message: "Are you sure you want to add this beer to WISHLIST?",
                                      preferredStyle: .actionSheet)
   
        let saveAction = UIAlertAction(title: "WISH", style: .default) { _ in
            self.userBeersDb.document((self.beer.id)!).setData(["savedAs":"wish",
                                                                "id":self.beer.id!,
                                                                "name":self.beer.name!,
                                                                "brewery":self.beer.brewery!,
                                                                "type":self.beer.type!,
                                                                "ABV":self.beer.ABV!
            ])
            self.beer.mark = "wish"
            self.viewDidLoad()
        }
              
        let cancelAction = UIAlertAction(title: "I changed my mind", style: .cancel)
            
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
            
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func checkinButton(_ sender: Any) {
        let alert = UIAlertController(title: "Action",
                                      message: "Are you sure you want to add this beer to CKECK-INS?",
                                      preferredStyle: .actionSheet)
              
        let saveAction = UIAlertAction(title: "CHECK-IN", style: .default) { _ in
            self.userBeersDb.document((self.beer.id)!).setData(["savedAs":"checkin",
                                                                "id":self.beer.id!,
                                                                "name":self.beer.name!,
                                                                "brewery":self.beer.brewery!,
                                                                "type":self.beer.type!,
                                                                "ABV":self.beer.ABV!,
                                                                "date":Timestamp(date: Date())
            ])
            self.beer.mark = "checkin"
            self.viewDidLoad()
        }
              
        let cancelAction = UIAlertAction(title: "I changed my mind", style: .cancel)
            
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
            
        present(alert, animated: true, completion: nil)
    }
    
    
    func setupView(){
        self.background.layer.cornerRadius = 10
        
        self.wishlistButton.layer.cornerRadius = 10
        self.wishlistButton.layer.borderWidth = 0.2
        self.wishlistButton.layer.borderColor = UIColor.darkGray.cgColor
        self.challengeButton.layer.cornerRadius = 10
        self.challengeButton.layer.borderWidth = 0.2
        self.challengeButton.layer.borderColor = UIColor.darkGray.cgColor
        self.checkinButton.layer.cornerRadius = 10
        self.checkinButton.layer.borderWidth = 0.2
        
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
            
            self.wishlistButton.alpha = 0
            self.challengeButton.setTitle("Create another CHALLENGE", for: .normal)
        }
        else{
            self.markCheckin.alpha = 0
            self.markWishlist.alpha = 0
            self.markChallenge.alpha = 0
            self.wishlistButton.alpha = 1
            self.challengeButton.setTitle("Create CHALLENGE", for: .normal)
            self.checkinButton.setTitle("CHECK-IN", for: .normal)
        }
        
        self.labelName.text = beer.name!
        self.labelBrewery.text = beer.brewery!
        self.labelType.text = beer.type!
        self.labelABV.text = beer.ABV! + " ABV"
        
    }
    
    
    
}
