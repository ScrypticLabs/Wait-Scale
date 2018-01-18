//
//  LoginViewController.swift
//  PatientOccupancy
//
//  Created by Abhi Gupta on 2015-08-15.
//  Copyright (c) 2015 AbhiGupta. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var userID: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let backgroundImage = UIImage(named: "loginBackground")
    var imageView: UIImageView!
    
    var errorMessage = ""
    
    @IBAction func logIn() {
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        
        var UserID = userID.text
        var userPassword = password.text
        
        PFUser.logInWithUsernameInBackground(UserID, password:userPassword) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                dispatch_async(dispatch_get_main_queue()) {
                    self.performSegueWithIdentifier("logInToNavigation", sender: self)
                }
            } else {
                self.activityIndicator.stopAnimating()
                
                if let message: AnyObject = error!.userInfo!["error"] {
                    self.errorMessage = "\(message)"
                    print(self.errorMessage)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator.hidden = true
        activityIndicator.hidesWhenStopped = true
        
        // Background Image
        imageView = UIImageView(frame: UIScreen.mainScreen().nativeBounds)
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = backgroundImage
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
        // Background Image
        
        //Looks for single or multiple taps.
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        
    }
    
    //Calls this function when the tap is recognized.
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField.returnKeyType==UIReturnKeyType.Go) {
            logIn()
        } else if (textField.returnKeyType == UIReturnKeyType.Next) {
            password.becomeFirstResponder()
        }
        return true
    }
    
//    override func shouldAutorotate() -> Bool {
//        return false
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
