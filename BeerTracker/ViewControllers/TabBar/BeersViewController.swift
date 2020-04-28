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
    let uid: String =  Auth.auth().currentUser!.uid
    
    var beerData : [Beer] = []
    var userBeers : [String:String] = [:]
    var searchedBeer : [Beer] = []
    var searchActive = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getData(beerData: beerData){ (beerData) in
            print(beerData)
        }
        
        
        

        //let uid: String =  Auth.auth().currentUser!.uid
        
        /*let checkinsRef = db.collection("users/"+uid+"/checkins")
           
         * CREATE
        checkinsRef.addDocument(data: ["name":"crud-name", "brewery":"crud-brewery", "type":"crud-type", "ABV":10])
                
         let newDoc = checkinsRef.document()
         newDoc.setData(["name":"crud2-name", "brewery":"crud2-brewery", "type":"crud2-type", "ABV":11, "id": newDoc.documentID])
         
         checkinsRef.document("crud3").setData(["name":"crud3-name", "brewery":"crud3-brewery", "type":"crud3-type", "ABV":12])
         
         * UPDATE
         checkinsRef.document("beer-d").updateData([field:value])
         
         * DELETE
         checkinsRef.document("beer-d").delete()
         
         
           */
    }

    func getData(beerData: [Beer], handler: @escaping (([Beer]) -> ()) ){
        let dispGr = DispatchGroup()
        dispGr.enter()
        db.collection("users/\(uid)/beers").getDocuments { (snapshot, error) in
            if let error = error {print("getUserBeer() error: \(error)")
            }else{
                for doc in snapshot!.documents{
                    let name = (doc.data()["name"] as! String)
                    let savedAs = (doc.data()["savedAs"] as! String)
                    self.userBeers[name] = savedAs
                }
            }
            dispGr.leave()
        }
        
        dispGr.notify(queue: .main){
            var beer = Beer()
            self.db.collection("beers").getDocuments { (snapshot, error) in
                if let error = error {print("getData() error: \(error)")
                }else{
                    for doc in snapshot!.documents{
                        beer.name = (doc.data()["name"] as! String)
                        beer.brewery = (doc.data()["brewery"] as! String)
                        beer.type = (doc.data()["type"] as! String)
                        beer.ABV = (doc.data()["ABV"] as! String)
                        if let val = self.userBeers[beer.name!]{
                            beer.mark = val
                            print("FOR \(beer.name!) FOUND \(beer.mark!)")
                        }else{
                            print("FOR \(beer.name!) NOT FOUND")
                        }
                        
                        self.beerData.append(beer)
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func getUserBeers(completion: () -> Void ){
        print("AICI 1")
        db.collection("users/\(uid)/beers").getDocuments { (snapshot, error) in
            print("AICI 2")
            if let error = error {print("getUserBeer() error: \(error)")
            }else{
                for doc in snapshot!.documents{
                    let name = (doc.data()["name"] as! String)
                    let savedAs = (doc.data()["savedAs"] as! String)
                    self.userBeers[name] = savedAs
                    print("ADDED \(name) : \(self.userBeers[name]!)")
                }
                print("AICI 3")
            }
            print("AICI 4")
        }
        completion()
    }
     
     /*func chooseData() -> [Beer]{
             if searchActive{
                 return self.searchedBeer
             }else{
                 return self.beerData
             }
     }*/
     

}

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
         if searchActive{
             cell.setBeerCell(with: searchedBeer[indexPath.row])
         }else{
             cell.setBeerCell(with: beerData[indexPath.row])
         }
         cell.accessoryType = .disclosureIndicator
         return cell
     }
     
 }

 extension BeersViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.showsCancelButton = true
        searchedBeer = beerData.filter({$0.name!.lowercased().contains(searchText.lowercased())})
        searchActive = true
        self.tableView.reloadData()
     }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        //self.searchBar.resignFirstResponder()
        self.searchBar.endEditing(true)
    }
     
     func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        searchBar.text = ""
        searchBar.showsCancelButton = false
        self.tableView.reloadData()
     }
 }


 class BeersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelBeerName: UILabel!
    @IBOutlet weak var labelBrewery: UILabel!
    @IBOutlet weak var labelBeerType: UILabel!
    
    
    @IBOutlet weak var markWishlist: UIImageView!
    @IBOutlet weak var markCheckin: UIImageView!
    @IBOutlet weak var markChallenge: UIImageView!
    
    func setBeerCell(with beer: Beer){
        self.labelBeerName.text = beer.name
        self.labelBrewery.text = beer.brewery
        self.labelBeerType.text = beer.type
        
        
        if beer.mark == "checkin"{
            self.markCheckin.alpha = 1
        }else if beer.mark == "wish"{
            self.markWishlist.alpha = 1
        }else if beer.mark == "challenge"{
            self.markChallenge.alpha = 1
        }else{
            self.markCheckin.alpha = 0
            self.markWishlist.alpha = 0
            self.markChallenge.alpha = 0
        }
    }
     /*private var lineId : Int?
     
     override func awakeFromNib() {
         super.awakeFromNib()
     }*/
     
     override func setSelected(_ selected: Bool, animated: Bool) {
         super.setSelected(selected, animated: animated)
     }
     /*
     func getId() -> Int{
         return self.lineId!
     }*/
     
}
