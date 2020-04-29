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
    
    //let db = Firestore.firestore()
    //let uid: String =  Auth.auth().currentUser!.uid
    let userBeersDb = Firestore.firestore().collection("users/\(Auth.auth().currentUser!.uid)/beers")
            
    var wishlistData : [UserBeer] = []
    var searchedWish : [UserBeer] = []
    var searchActive = false

    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.reload()

                         
    }
    
    func reload(){
        self.wishlistData = []
        self.getData()
        self.tableView.reloadData()
    }
    
    //func getData(wishlistData: [UserBeer], handler: @escaping (([UserBeer]) -> ()) ){
    func getData(){
        let group = DispatchGroup()
        var wishlistBeer = UserBeer()
        
        group.enter()
        userBeersDb.whereField("savedAs", isEqualTo: "wish").getDocuments { (snapshot, error) in
            if let error = error {print("getData() error: \(error)")
            }else{
                for doc in snapshot!.documents{
                    wishlistBeer.id = doc.documentID
                    wishlistBeer.name = (doc.data()["name"] as! String)
                    wishlistBeer.brewery = (doc.data()["brewery"] as! String)
                    wishlistBeer.type = (doc.data()["type"] as! String)
                    wishlistBeer.ABV = (doc.data()["ABV"] as! String)
                    
                    self.wishlistData.append(wishlistBeer)
                }
                //self.tableView.reloadData()
            }
            group.leave()
        }
        group.notify(queue: .main) {}
    }
    
    func getBeer(name: String) -> UserBeer{
        var beer = UserBeer()
        for b in self.wishlistData{
            if b.name == name{
                beer = b
            }
        }
        return beer
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
        cell.tableViewController = self
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
    
    var tableViewController : WishlistViewController?
    
    func setWishlistCell(with wishlistBeer: UserBeer){
        self.labelBeerName.text = wishlistBeer.name
        self.labelBrewery.text = wishlistBeer.brewery
        self.labelBeerType.text = wishlistBeer.type
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    @IBAction func checkinButtonTapped(_ sender: AnyObject) {
        print("CHECKIN BUTTON TAPPED for \(self.labelBeerName.text!)")
        let userBeer = self.tableViewController!.getBeer(name: self.labelBeerName.text!)
    
        
        let alert = UIAlertController(title: "Check-in",
                                      message: "If you complete this action, \(self.labelBeerName.text!) will be removed from the wishlist and added to your check-in list",
                                        preferredStyle: .actionSheet)
          
        let saveAction = UIAlertAction(title: "Check-in", style: .default) { _ in
            self.tableViewController?.userBeersDb.document((userBeer.id)!).setData(["savedAs" : "checkin", "date":Timestamp(date: Date())], merge: true)
            self.tableViewController?.reload()
        }
          
        let cancelAction = UIAlertAction(title: "Go back", style: .cancel)
          
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        
        self.tableViewController!.present(alert, animated: true, completion: nil)
    }
}
    

