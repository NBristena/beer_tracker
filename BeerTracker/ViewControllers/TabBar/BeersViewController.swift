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
    
    var beerData : [Beer] = []
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
        var beer = Beer()
        //let g = DispatchGroup()
        //g.enter()
        db.collection("beers").getDocuments { (snapshot, error) in
            if let error = error {
                print("getData() error: \(error)")
                //g.leave()
            }
            else{
                for doc in snapshot!.documents{
                    beer.name = (doc.data()["name"] as! String)
                    beer.brewery = (doc.data()["brewery"] as! String)
                    beer.type = (doc.data()["type"] as! String)
                    beer.ABV = (doc.data()["ABV"] as! String)
                    
                    self.beerData.append(beer)
                }
                self.tableView.reloadData()
                //g.leave()
            }
        }
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
         //cell.accessoryType = .disclosureIndicator
         return cell
     }
     
 }

 extension BeersViewController: UISearchBarDelegate{
     
    func textFieldShouldReturn(_ searchTextField: UISearchTextField) -> Bool {
        searchTextField.resignFirstResponder()
      return true
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
         //print("aici")
        searchBar.showsCancelButton = true
        //searchBar.showsSearchResultsButton = true
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
    
    func setBeerCell(with beer: Beer){
        self.labelBeerName.text = beer.name
        self.labelBrewery.text = beer.brewery
        self.labelBeerType.text = beer.type
        
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
