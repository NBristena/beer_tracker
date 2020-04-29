//
//  ProfileViewController.swift
//  BeerTracker
//
//  Created by user166111 on 4/27/20.
//  Copyright © 2020 FMI. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class ProfileViewController: UIViewController {

    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.logoutButton.layer.cornerRadius = 7
        
        let db = Firestore.firestore()
        let uid: String =  Auth.auth().currentUser!.uid
        db.collection("users").document(uid).getDocument { (user, error) in
            if let error = error {
                let alert = UIAlertController(title: "Getting user data failed",
                                               message: error.localizedDescription,
                                               preferredStyle: .alert)
                 
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
            }
            else{
                let userName = user!.data()!["name"] as! String
                self.title = userName
            }
        }
        
        
    }
    
    /*
     db.collection("users").whereField("uid", isEqualTo: uid).getDocuments {(querySnapshot, error) in
         if let error = error {
             let alert = UIAlertController(title: "Getting user data failed",
                                            message: error.localizedDescription,
                                            preferredStyle: .alert)
              
             alert.addAction(UIAlertAction(title: "OK", style: .default))
             self.present(alert, animated: true, completion: nil)
         }
         else{
             let userName = querySnapshot!.documents[0].data()["name"] as! String
             self.title = userName
         }
     }
     
     
     
     //let data = db.collection("users/"+uid).document().dictionaryWithValues(forKeys: ["name"])
     //let name = data["name"] as! String
     //self.title = name
     ------------------------------------------------------
    func  getCurrentUsername(_ uid: String,userName: String){
        //var userName = "error"
        db.collection("users").whereField("uid", isEqualTo: uid).getDocuments {(querySnapshot, error) in
            if let error = error {
                let alert = UIAlertController(title: "Getting user data failed",
                                               message: error.localizedDescription,
                                               preferredStyle: .alert)
                 
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
                userName = "error"
            }
            else{
                userName = querySnapshot!.documents[0].data()["name"] as! String
            }
        }
        //return userName
    }*/

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
