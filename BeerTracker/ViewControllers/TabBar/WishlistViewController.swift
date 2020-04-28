//
//  WishlistViewController.swift
//  BeerTracker
//
//  Created by user166111 on 4/27/20.
//  Copyright © 2020 FMI. All rights reserved.
//

import UIKit
import Firebase

class WishlistViewController: UIViewController {

    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let db = Firestore.firestore()
    let uid: String =  Auth.auth().currentUser!.uid
            
    var wishlistData : [UserBeer] = []
    var searchedWish : [UserBeer] = []
    var searchActive = false

    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.getData(wishlistData: wishlistData){ (wishlistData) in
            print(wishlistData)
        }

                         
    }
            
    func getData(wishlistData: [UserBeer], handler: @escaping (([UserBeer]) -> ()) ){
        var wishlistBeer = UserBeer()

        db.collection("users/"+uid+"/beers").whereField("savedAs", isEqualTo: "wish").getDocuments { (snapshot, error) in
            if let error = error {
                print("getData() error: \(error)")
            }else{
                for doc in snapshot!.documents{
                    wishlistBeer.name = (doc.data()["name"] as! String)
                    wishlistBeer.brewery = (doc.data()["brewery"] as! String)
                    wishlistBeer.type = (doc.data()["type"] as! String)
                    wishlistBeer.ABV = (doc.data()["ABV"] as! String)
                    
                           
                    self.wishlistData.append(wishlistBeer)
                }
                self.tableView.reloadData()
            }
        }
    }
}

/*-----------------------------*
 |         SEARCH BAR          |
 *-----------------------------*/
extension WishlistViewController: UISearchBarDelegate{

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.showsCancelButton = true
        searchedWish = wishlistData.filter({$0.name!.lowercased().contains(searchText.lowercased())})
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



/*-----------------------------*
 |         TABLE VIEW          |
 *-----------------------------*/
extension WishlistViewController: UITableViewDataSource, UITableViewDelegate{
      
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive{
            return searchedWish.count
        }else{
            return wishlistData.count
        }
    }
      
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WishlistCell") as! WishlistTableViewCell
        if searchActive{
            cell.setWishlistCell(with: searchedWish[indexPath.row])
        }else{
            cell.setWishlistCell(with: wishlistData[indexPath.row])
        }
        //cell.accessoryType = .disclosureIndicator
        return cell
    }
}



/*-----------------------------*
 |         CELL CLASS          |
 *-----------------------------*/
class WishlistTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelBeerName: UILabel!
    @IBOutlet weak var labelBrewery: UILabel!
    @IBOutlet weak var labelBeerType: UILabel!
    @IBOutlet weak var checkinButton: UIButton!
    
    func setWishlistCell(with wishlistBeer: UserBeer){
        self.labelBeerName.text = wishlistBeer.name
        self.labelBrewery.text = wishlistBeer.brewery
        self.labelBeerType.text = wishlistBeer.type
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func checkinButtonTapped(_ sender: Any) {
        print("CHECKIN BUTTON TAPPED")
    }
    
}
