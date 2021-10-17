//
//  LoginVC.swift
//  PhoneNumberChanged
//
//  Created by Seunghyeon Kang on 10/18/21.
//

import Foundation
import UIKit
import GoogleSignIn
import FirebaseAuth
import Firebase

class LoginVC :UIViewController{
    
    var userData:GIDProfileData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func OnClickedBtnLogin(_ sender: Any) {
        guard let clientId = FirebaseApp.app()?.options.clientID
        else{ return }
        
        let config = GIDConfiguration(clientID: clientId)
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) {
            [unowned self] user, error in
            if let error = error{
                print(error.localizedDescription)
                return
            }
            
            guard
            let authentication = user?.authentication,
            let idToken = authentication.idToken
            else{
                print("authentication or idtoken is null")
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                guard error == nil else{
                    print("userLogin failed: \(String(describing: error?.localizedDescription))")
                    return
                }
            }
            if let profile = GIDSignIn.sharedInstance.currentUser?.profile{
                userData = profile
                self.performSegue(withIdentifier: "SegueToNotify", sender: self)
            }
            
            
            print("userLogin Success")
        }
                
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let notifyVc = segue.destination as? NotifyVC else { return }
        
        notifyVc.userData = self.userData
    }
    
}
