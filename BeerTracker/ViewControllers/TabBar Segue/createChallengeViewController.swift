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
    

    let usersDb = Firestore.firestore().collection("users")
    let userBeersDb = Firestore.firestore().collection("users/\(Auth.auth().currentUser!.uid)/beers")
    
    var beer = Beer()
    var users : [User] = []
    var searchedUser : [String] = []
    var searchActive = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        getUsers()
        
    }
    
    func getUsers(){
        let group = DispatchGroup()
        group.enter()
        var user = User()
        usersDb.getDocuments { (snapshot, error) in
            if let error = error {print("getUsers() error: \(error)")
            }else{
                for doc in snapshot!.documents{
                    if(doc.documentID != Auth.auth().currentUser!.uid){
                        user.id = (doc.documentID as! String)
                        user.name = (doc.data()["name"] as! String)
                        user.email = (doc.data()["email"] as! String)
                    }
                    self.users.append(user)
                }
            }
            group.leave()
        }
        group.notify(queue: .main){}
    }

    
    func setupView(){
        self.background.layer.cornerRadius = 10
        
        self.challengeButton.layer.cornerRadius = 10
        self.challengeButton.layer.borderWidth = 0.2
        
        self.labelBeerName.text = beer.name!
        
        self.title = "CHALLENGE"
    }

}


/*-----------------------------*
 |         SEARCH BAR          |
 *-----------------------------*/
extension createChallengeViewController: UISearchBarDelegate{
    
    /*func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.showsCancelButton = true
        searchedUser = beerData.filter({$0.name!.lowercased().contains(searchText.lowercased())})
        searchActive = true
        self.tableView.reloadData()
    }*/
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        self.searchBar.endEditing(true)
    }
     
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
        searchActive = false
        searchBar.text = ""
        searchBar.showsCancelButton = false
        //self.tableView.reloadData()
    }
}
