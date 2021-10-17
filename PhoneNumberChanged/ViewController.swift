//
//  ViewController.swift
//  PhoneNumberChanged
//
//  Created by Seunghyeon Kang on 10/17/21.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

class ViewController: UIViewController {

    @IBOutlet weak var btnLogin: UIButton!
    var userData: GIDProfileData?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    @IBAction func OnClickdBtnLogin(_ sender: Any) {
        
        guard let clientId = FirebaseApp.app()?.options.clientID else { return }
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
            
            // firebase auth
            Auth.auth().signIn(with: credential) { authResult, error in
                guard error == nil else {
                    print("userLogin failed: \(String(describing: error?.localizedDescription))")
                    return
                }
                if let profile = GIDSignIn.sharedInstance.currentUser?.profile{
                    userData = profile
                    self.performSegue(withIdentifier: "NotifyVC", sender: self)
                }
                
                print("userLogin Success")
             
            }
        }
//
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let notifyVc = segue.destination as? NotifyVC else { return }

        notifyVc.userData = self.userData
    }
}
