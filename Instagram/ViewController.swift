//
//  ViewController.swift
//  Instagram
//
//  Created by Sylvester Amponsah on 10/23/18.
//  Copyright © 2018 Sylvester Amponsah. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {
    
    var signupModeActive = true

    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    
    func displayAlert(title: String, message: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            (action) in
            
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func signupOrLogin(_ sender: Any) {
        //More validation required (say for a valid email address)
        //I need to add this component for App  ---> Stackoverflow.com
        if email.text == "" || password.text == "" {
            
            displayAlert(title: "Error in form", message: "Please enter an email and password")
            
        } else{
            
            // Loading spinner
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y:0, width: 50, height:50))
            
            activityIndicator.center = self.view.center
            
            activityIndicator.hidesWhenStopped = true
            
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorView.Style.gray
            
            view.addSubview(activityIndicator)
            
            activityIndicator.startAnimating()
            
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            if (signupModeActive){
            
            let user = PFUser()
            user.username = email.text
            user.password = password.text
            user.email = email.text
            // other fields can be set just like with PFObject
            // user["phone"] = "415-392-0202"
            
            user.signUpInBackground(block: {(success, error) in
                
                 // Loading spinner
                activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                
                if let error = error {
                   // let errorString = error.userInfo["error"] as? NSString
                    // Show the errorString somewhere and let the user try again.
                    self.displayAlert(title: "Could not signed you up", message: error.localizedDescription)
                    print(error)
                } else {
                    // Hooray! Let them use the app now.
                    print("You're all signed up!")
                    self.performSegue(withIdentifier: "showUserTable", sender: self)
                }
                
            })
            
            }else {
                
                PFUser.logInWithUsername(inBackground: email.text!, password: password.text!, block: {(user, error) in
                    
                     // Loading spinner
                    activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if user != nil {
                        
                        print("Login successfully")
                        self.performSegue(withIdentifier: "showUserTable", sender: self)
                        
                    }else {
                        
                        var errorText = "Unknown error: please try again"
                        
                        if let error = error {
                            
                            errorText = error.localizedDescription
                            
                        }
                        
                        self.displayAlert(title: "Could not sign you up", message: errorText)
                        
                    }
                    
                    
                    
                })
                
            }
            
        }

    }
    
    
    @IBOutlet var signupOrLoginButton: UIButton!
    
    
    @IBAction func switchLoginMode(_ sender: Any) {
        if (signupModeActive){
            
            signupModeActive = false
            
            signupOrLoginButton.setTitle("Log In", for: [])
            
            switchLoginModeButton.setTitle("Sign Up", for: [])
            
        } else {
            
            signupModeActive = true
            
            signupOrLoginButton.setTitle("Sign Up", for: [])
            
            switchLoginModeButton.setTitle("Log In", for: [])
            
        }
    }
    
    
    @IBOutlet var switchLoginModeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if PFUser.current() != nil {
            
            self.performSegue(withIdentifier: "showUserTable", sender: self)
        }
        
        self.navigationController?.navigationBar.isHidden = true
    }
        
    


}

