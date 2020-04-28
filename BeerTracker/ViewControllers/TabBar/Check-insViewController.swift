//
//  Check-insViewController.swift
//  BeerTracker
//
//  Created by user166111 on 4/27/20.
//  Copyright © 2020 FMI. All rights reserved.
//

import UIKit
import Firebase

class Check_insViewController: UIViewController {

        
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let db = Firestore.firestore()
    let uid: String =  Auth.auth().currentUser!.uid
        
    var checkinData : [UserBeer] = []
    var searchedCheckin : [UserBeer] = []
    var searchActive = false

    override func viewDidLoad() {
        super.viewDidLoad()
            
        self.getData(checkinData: checkinData){ (checkinData) in
            print(checkinData)
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
                                let checkinData = beer.data()
                                print(checkinData)
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
        
    func getData(checkinData: [UserBeer], handler: @escaping (([UserBeer]) -> ()) ){
        var checkinBeer = UserBeer()
           
        db.collection("users/"+uid+"/beers").whereField("savedAs", isEqualTo: "checkin").getDocuments { (snapshot, error) in
            if let error = error {
                print("getData() error: \(error)")
            }
            else{
                for doc in snapshot!.documents{
                    checkinBeer.name = (doc.data()["name"] as! String)
                    checkinBeer.brewery = (doc.data()["brewery"] as! String)
                    checkinBeer.type = (doc.data()["type"] as! String)
                    checkinBeer.ABV = (doc.data()["ABV"] as! String)
                    //beer.location = (doc.data()["ABV"] as! String)
                    checkinBeer.date = (doc.data()["date"] as! Date)
                       
                    self.checkinData.append(checkinBeer)
                }
                self.tableView.reloadData()
            }
        }
    }
}



/*-----------------------------*
 |         SEARCH BAR          |
 *-----------------------------*/
extension Check_insViewController: UISearchBarDelegate{

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.showsCancelButton = true
        searchedCheckin = checkinData.filter({$0.name!.lowercased().contains(searchText.lowercased())})
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
extension Check_insViewController: UITableViewDataSource, UITableViewDelegate{
      
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive{
            return searchedCheckin.count
        }else{
            return checkinData.count
        }
    }
      
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckinCell") as! CheckinsTableViewCell
        if searchActive{
            cell.setCheckinCell(with: searchedCheckin[indexPath.row])
        }else{
            cell.setCheckinCell(with: checkinData[indexPath.row])
        }
        //cell.accessoryType = .disclosureIndicator
        return cell
    }
}



/*-----------------------------*
 |         CELL CLASS          |
 *-----------------------------*/
class CheckinsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelBeerName: UILabel!
    @IBOutlet weak var labelBrewery: UILabel!
    @IBOutlet weak var labelBeerType: UILabel!
    @IBOutlet weak var labelCheckinDate: UILabel!
 
    func setCheckinCell(with checkinBeer: UserBeer){
        let df = DateFormatter()
        df.dateFormat = "MMM d, YYYY"
        
        self.labelBeerName.text = checkinBeer.name
        self.labelBrewery.text = checkinBeer.brewery
        self.labelBeerType.text = checkinBeer.type
        self.labelCheckinDate.text = df.string(from: checkinBeer.date!)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}











/*          OLD ----------------------------------------------------------
    
 override func viewDidLoad() {
        super.viewDidLoad()
        
        let db = Firestore.firestore()

        let uid: String =  Auth.auth().currentUser!.uid
        let checkinsRef = db.collection("users/"+uid+"/beers")
                
        checkinsRef.whereField("savedAs", isEqualTo: "checkins").getDocuments() { (snapshot, error) in
            if let error = error {
                print("err in checkins: \(error)")
            }
            else{
                for beer in snapshot!.documents {
                        if beer.exists {
                            let checkinData = beer.data()
                            print(checkinData)
                        }
                }
                
            }
        }
    
        /*
        checkinsRef.addDocument(data: ["name":"crud-name", "brewery":"crud-brewery", "type":"crud-type", "ABV":10])
                
        let newDoc = checkinsRef.document()
        newDoc.setData(["name":"crud2-name", "brewery":"crud2-brewery", "type":"crud2-type", "ABV":11, "id": newDoc.documentID])
                
                
        checkinsRef.document("crud3").setData(["name":"crud3-name", "brewery":"crud3-brewery", "type":"crud3-type", "ABV":12])
          */
                
    }
}*/




    /*
     let uid: String =  Auth.auth().currentUser!.uid
     db.collection("users").whereField("uid", isEqualTo: uid).getDocuments { (querySnapshot, error) in
         if let error = error {
           let alert = UIAlertController(title: "Getting user data failed",
                                         message: error.localizedDescription,
                                         preferredStyle: .alert)
           
           alert.addAction(UIAlertAction(title: "OK", style: .default))
           self.present(alert, animated: true, completion: nil)
         }
         else{
             let currentUser = querySnapshot!.documents[0].documentID
             let checkinsRef = db.collection("users/"+uid+"/checkins")
             
             
             
              checkinsRef.addDocument(data: ["name":"crud-name", "brewery":"crud-brewery", "type":"crud-type", "ABV":10])
             
             let newDoc = checkinsRef.document()
             newDoc.setData(["name":"crud2-name", "brewery":"crud2-brewery", "type":"crud2-type", "ABV":11, "id": newDoc.documentID])
             
             
             checkinsRef.document("crud3").setData(["name":"crud3-name", "brewery":"crud3-brewery", "type":"crud3-type", "ABV":12])
         
         }
     }
    --------------------------------------------
     func getUserId(_ uid: String) -> String{
        var user = "error"
        db.collection("users").whereField("uid", isEqualTo: uid).getDocuments { (querySnapshot, error) in
            if let error = error {
              let alert = UIAlertController(title: "Getting user data failed",
                                            message: error.localizedDescription,
                                            preferredStyle: .alert)
              
              alert.addAction(UIAlertAction(title: "OK", style: .default))
              self.present(alert, animated: true, completion: nil)
            }
            else{
                user = querySnapshot!.documents[0].documentID
                print("userFunc: \(user)")
            }
        }
        print("userFuncRet: \(user)")
        return "error"
    }*/
