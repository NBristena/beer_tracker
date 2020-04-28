//
//  Check-insViewController.swift
//  BeerTracker
//
//  Created by user166111 on 4/27/20.
//  Copyright © 2020 FMI. All rights reserved.
//

import UIKit
import Firebase

class CheckinsViewController: UIViewController {

    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    let db = Firestore.firestore()
    let uid: String =  Auth.auth().currentUser!.uid
    
    var beerData : [UserBeer] = []
    var searchedBeer : [UserBeer] = []
    var searchActive = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getData(beerData: beerData){ (beerData) in
            print(beerData)
        }

        /*
        let uid: String =  Auth.auth().currentUser!.uid
        let checkinsRef = db.collection("users/"+uid+"/beers")
                
        checkinsRef.whereField("savedAs", isEqualTo: "checkins").getDocuments() { (snapshot, error) in
            if let error = error {
                print("err in checkins: \(error)")
            }
            else{
                for beer in snapshot!.documents {
                        if beer.exists {
                            let beerData = beer.data()
                            print(beerData)
                        }
                }
                
            }
        }*/
    
        /*
        checkinsRef.addDocument(data: ["name":"crud-name", "brewery":"crud-brewery", "type":"crud-type", "ABV":10])
                
        let newDoc = checkinsRef.document()
        newDoc.setData(["name":"crud2-name", "brewery":"crud2-brewery", "type":"crud2-type", "ABV":11, "id": newDoc.documentID])
                
                
        checkinsRef.document("crud3").setData(["name":"crud3-name", "brewery":"crud3-brewery", "type":"crud3-type", "ABV":12])
          */
                
    }
    
    func getData(beerData: [UserBeer], handler: @escaping (([UserBeer]) -> ()) ){
        var beer = UserBeer()
       
        db.collection("users/"+uid+"/beers").whereField("savedAs", isEqualTo: "checkins").getDocuments { (snapshot, error) in
            if let error = error {
                print("getData() error: \(error)")
            }
            else{
                for doc in snapshot!.documents{
                    beer.name = (doc.data()["name"] as! String)
                    beer.brewery = (doc.data()["brewery"] as! String)
                    beer.type = (doc.data()["type"] as! String)
                    beer.ABV = (doc.data()["ABV"] as! String)
                    beer.date = (doc.data()["date"] as! NSDate)
                   
                    self.beerData.append(beer)
               }
               self.tableView.reloadData()
           }
        }
    }
}


 

  /*extension CheckinsViewController: UITableViewDataSource, UITableViewDelegate{
      
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          if searchActive{
              return searchedBeer.count
          }else{
             return beerData.count
          }
      }
      
      /*func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "CheckinsCell") as! CheckinsTableViewCell
          if searchActive{
              cell.setCheckinCell(with: searchedBeer[indexPath.row])
          }else{
              cell.setCheckinCell(with: beerData[indexPath.row])
          }
          //cell.accessoryType = .disclosureIndicator
          return cell
      }*/
      
  }*/

extension CheckinsViewController: UISearchBarDelegate{
     
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.showsCancelButton = true
        searchedBeer = beerData.filter({$0.name!.lowercased().contains(searchText.lowercased())})
        searchActive = true
        self.tableView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        self.searchBar.resignFirstResponder()
    }
      
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        searchBar.text = ""
        searchBar.showsCancelButton = false
        self.tableView.reloadData()
    }
}


/*
class CheckinsTableViewCell: UITableViewCell {
     
     @IBOutlet weak var labelBeerName: UILabel!
     //@IBOutlet weak var labelBrewery: UILabel!
     //@IBOutlet weak var labelBeerType: UILabel!
     
    func setCheckinCell(with beer: Beer){
        self.labelBeerName.text = beer.name
        self.labelBrewery.text = beer.brewery
        self.labelBeerType.text = beer.type
        self.labelDate.text = beer.date
         
    }
      
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
      
}*/
