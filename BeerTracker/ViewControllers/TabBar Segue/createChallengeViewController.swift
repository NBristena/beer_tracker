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
    @IBOutlet weak var createButton: UIButton!
    
    
    let usersDb = Firestore.firestore().collection("users")
    let challengesDb = Firestore.firestore().collection("challenges")
    let uid = Auth.auth().currentUser!.uid
    //let userBeersDb = Firestore.firestore().collection("users/\(Auth.auth().currentUser!.uid)/beers")
    var userEmail : String = " "

    var beer = Beer()
    var users : [User] = []
    var searchedUser : [User] = []
    var searchActive = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("gets to view load")
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
                        user.id = doc.documentID
                        user.name = (doc.data()["name"] as! String)
                        user.email = (doc.data()["email"] as! String)
                    }else{
                        self.userEmail = (doc.data()["email"] as! String)
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
        
        self.createButton.layer.cornerRadius = 10
        self.createButton.layer.borderWidth = 0.2
        
        self.labelBeerName.text = beer.name!
        
        self.title = "CHALLENGE"
    }

    /*
    @IBAction func createButtonTapped(_ sender: Any) {
        let chId = UUID().uuidString
        // presupunem ca aici am avea email-urile userilor in cauza si facem rost de uid-ul fiecaruia
        let users = [uid,"ncdbcsr7krh3Hs6gD3XwXgqerfJ2"]
        self.challengesDb.document(chId).setData(["id":chId,
                                                  "beerId":beer.id!,
                                                  "createdBy":userEmail,
                                                  "users":users
        ])
        for userId in users{
            usersDb.document(userId).collection("beers").document(beer.id!).setData(["savedAs" : "challenge",
                                                                                     "id":beer.id!,
                                                                                     "name":beer.name!,
                                                                                     "brewery":beer.brewery!,
                                                                                     "type":beer.type!,
                                                                                     "ABV":beer.ABV!,
                                                                                     "challengeId":chId,
                                                                                     "date":Timestamp(date: Date())],
                                                                                    merge: true)
        }
        
        self.navigationController?.popToRootViewController(animated: true)
    }*/
    
    
    
}


/*-----------------------------*
 |         SEARCH BAR          |
 *-----------------------------*/
extension createChallengeViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.showsCancelButton = true
        searchedUser = users.filter({$0.email!.lowercased().contains(searchText.lowercased())})
        searchActive = true
        self.tableView.reloadData()
    }
    
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
