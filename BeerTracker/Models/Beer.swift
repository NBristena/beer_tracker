//
//  Beer.swift
//  BeerTracker
//
//  Created by user166111 on 4/28/20.
//  Copyright © 2020 FMI. All rights reserved.
//

import Foundation
import FirebaseFirestore


struct Beer {
    var name: String?
    var brewery: String?
    var type: String?
    var ABV: String?
    var mark: String?
}

struct UserBeer {
    var id: String?
    var savedAs: String?
    var name: String?
    var brewery: String?
    var type: String?
    var ABV: String?
    //var location: CLLocation?
    var date: Date?
    
    
    /*func getAll(db: Firestore, uid: String, savedAs:String) -> [UserBeer]{
        let group = DispatchGroup()
        var wishlistBeer = UserBeer()
        var userBeers : [UserBeer] = []
        group.enter()
        db.collection("users/"+uid+"/beers").whereField("savedAs", isEqualTo: savedAs).getDocuments { (snapshot, error) in
            if let error = error {print("getData() error: \(error)")
            }else{
                for doc in snapshot!.documents{
                    wishlistBeer.name = (doc.data()["name"] as! String)
                    wishlistBeer.brewery = (doc.data()["brewery"] as! String)
                    wishlistBeer.type = (doc.data()["type"] as! String)
                    wishlistBeer.ABV = (doc.data()["ABV"] as! String)
                    
                    userBeers.append(wishlistBeer)
                }
            }
            group.leave()
        }
        group.notify(queue: .main) {
            return userBeers
        }
    }*/
    
}
