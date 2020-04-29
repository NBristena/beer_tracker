//
//  createChallengeViewController.swift
//  BeerTracker
//
//  Created by user166111 on 4/29/20.
//  Copyright © 2020 FMI. All rights reserved.
//

import UIKit
import Firebase

class createChallengeViewController: UIViewController {

    @IBOutlet weak var background: UIView!
    @IBOutlet weak var labelBeerName: UILabel!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var challengeButton: UIButton!
    
    var beer = Beer()
    var userBeersDb = Firestore.firestore().collection("users/\(Auth.auth().currentUser!.uid)/beers")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }
    
    func setupView(){
        self.background.layer.cornerRadius = 10
        
        self.challengeButton.layer.cornerRadius = 10
        self.challengeButton.layer.borderWidth = 0.2
        
        self.labelBeerName.text = beer.name!
    }

}
