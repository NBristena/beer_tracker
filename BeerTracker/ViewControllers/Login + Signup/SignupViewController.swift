//
//  SignupViewController.swift
//  BeerTracker
//
//  Created by user166111 on 4/15/20.
//  Copyright © 2020 FMI. All rights reserved.
//

import UIKit
import Firebase
//import FirebaseAuth
//import FirebaseFirestore

class SignupViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signupButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
      return true
    }
    
    
    func validateFields() -> String? {
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill ALL fields."
        }
        return nil
    }
    
    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func goHome() {
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.tabBarViewController) as? TabBarViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }

    @IBAction func signupButtonTapped(_ sender: Any) {
        //Validate
        let error = validateFields()
        if error != nil {
            showError(error!)
        }
        else{
        //Create refs to the data
            let name = nameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
        //Create the user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                
                //Check for errors
                if err != nil {
                    self.showError("Error creating user")
                }
                else{
                
                //Store user
                    
                    let db = Firestore.firestore()
                    
                    db.collection("users").document(result!.user.uid).setData(["name":name, "email": email])
                    db.collection("users").document(result!.user.uid).collection("beers").document("test")
                        .setData(["savedAs":"test"])
                    db.collection("users").document(result!.user.uid).collection("challenges").document("test")
                        .setData(["id":"test","isCompleted":true])
                    
                    
                //Go home
                    self.goHome()
                }
            }
        }
    }
}


