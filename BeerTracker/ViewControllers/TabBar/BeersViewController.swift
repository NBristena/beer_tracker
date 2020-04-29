//
//  BeersViewController.swift
//  BeerTracker
//
//  Created by user166111 on 4/27/20.
//  Copyright © 2020 FMI. All rights reserved.
//

import UIKit
import Firebase

class BeersViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    let db = Firestore.firestore()
    let userBeersDb = Firestore.firestore().collection("users/\(Auth.auth().currentUser!.uid)/beers")
    
    var beerData : [Beer] = []
    var userBeers : [String:String] = [:]
    var searchedBeer : [Beer] = []
    var searchActive = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Beers", style: .plain, target: nil, action: nil)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.beerData = []
        self.userBeers = [:]
        self.getData()
    }
    
    func getData() {
        let group1 = DispatchGroup()
        group1.enter()
        var name = ""
        var savedAs = ""
        userBeersDb.getDocuments { (snapshot, error) in
            if let error = error {print("getUserBeer() error: \(error)")
            }else{
                if snapshot!.documents.count > 1 {
                    for doc in snapshot!.documents{
                        name = (doc.data()["name"] as! String)
                        savedAs = (doc.data()["savedAs"] as! String)
                        self.userBeers[name] = savedAs
                        }
                }
            }
            group1.leave()
        }
        
        group1.notify(queue: .main){
            let group2 = DispatchGroup()
            group2.enter()
            var beer = Beer()
            self.db.collection("beers").getDocuments { (snapshot, error) in
                if let error = error {print("getData() error: \(error)")
                }else{
                    for doc in snapshot!.documents{
                        beer.id = doc.documentID
                        beer.name = (doc.data()["name"] as! String)
                        beer.brewery = (doc.data()["brewery"] as! String)
                        beer.type = (doc.data()["type"] as! String)
                        beer.ABV = (doc.data()["ABV"] as! String)
                        
                        if let val = self.userBeers[beer.name!]{
                            beer.mark = val
                        }else{
                            beer.mark = "none"
                        }
                        
                        self.beerData.append(beer)
                    }
                    self.tableView.reloadData()
                }
                group2.leave()
            }
            group2.notify(queue: .main){}
        }
    }
    
    func getBeer(name: String) -> Beer{
        var beer = Beer()
        for b in self.beerData{
            if b.name == name{
                beer = b
            }
        }
        return beer
    }
     
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoBeerPage"{
            if let cell = sender as? UITableViewCell, let indexPath = self.tableView.indexPath(for: cell){
                let beerPage = segue.destination as? BeerPageViewController
                beerPage!.beer = beerData[indexPath.row]
            }
        }
    }

}


/*-----------------------------*
 |         SEARCH BAR          |
 *-----------------------------*/
extension BeersViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.showsCancelButton = true
        searchedBeer = beerData.filter({$0.name!.lowercased().contains(searchText.lowercased())})
        searchActive = true
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        self.searchBar.resignFirstResponder()
        //self.searchBar.endEditing(true)
    }
     
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
        searchActive = false
        searchBar.text = ""
        searchBar.showsCancelButton = false
        self.tableView.reloadData()
    }
}



/*-----------------------------*
 |         TABLE VIEW          |
 *-----------------------------*/
extension BeersViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive{
            return searchedBeer.count
        }else{
           return beerData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BeerCell") as! BeersTableViewCell
        cell.tableViewController = self
        if searchActive{
            cell.setBeerCell(with: searchedBeer[indexPath.row])
        }else{
            cell.setBeerCell(with: beerData[indexPath.row])
        }
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}



/*-----------------------------*
 |         CELL CLASS          |
 *-----------------------------*/
class BeersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelBeerName: UILabel!
    @IBOutlet weak var labelBrewery: UILabel!
    @IBOutlet weak var labelBeerType: UILabel!
    
    @IBOutlet weak var markWishlist: UIImageView!
    @IBOutlet weak var markCheckin: UIImageView!
    @IBOutlet weak var markChallenge: UIImageView!
    
    var tableViewController : BeersViewController?
    
    func setBeerCell(with beer: Beer){
        self.labelBeerName.text = beer.name
        self.labelBrewery.text = beer.brewery
        self.labelBeerType.text = beer.type
        
        if beer.mark == "checkin"{
            self.markCheckin.alpha = 1
            self.markWishlist.alpha = 0
            self.markChallenge.alpha = 0
        }else if beer.mark == "wish"{
            self.markCheckin.alpha = 0
            self.markWishlist.alpha = 1
            self.markChallenge.alpha = 0
        }else if beer.mark == "challenge"{
            self.markCheckin.alpha = 0
            self.markWishlist.alpha = 0
            self.markChallenge.alpha = 1
        }else{
            self.markCheckin.alpha = 0
            self.markWishlist.alpha = 0
            self.markChallenge.alpha = 0
        }
    }
     
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
     
}
