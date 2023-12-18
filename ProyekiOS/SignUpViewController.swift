//
//  SignUpViewController.swift
//  ProyekiOS
//
//  Created by jodem on 17/12/23.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    var ref : DatabaseReference!
    var list_uname : [String] = []
    var isValid : Bool = false

    @IBOutlet weak var GradientView: UIView!
    @IBOutlet weak var loginContainer: UIView!
    @IBOutlet weak var unamefield: UITextField!
    @IBOutlet weak var passfield: UITextField!
    @IBOutlet weak var eyeLb: UIImageView!
    
    @IBAction func toLogin(_ sender: UIButton) {
        performSegue(withIdentifier: "toLogin", sender: self)
    }
    
    @IBAction func signupBtn(_ sender: UIButton) {
        self.list_uname = []
        // database
        ref = Database.database(url: "https://projekios-6af0f-default-rtdb.asia-southeast1.firebasedatabase.app/").reference()
        // fetch all uname
        ref.child("user").observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let userData = childSnapshot.value as? [String:Any] {
                    self.list_uname.append(userData["uid"] as! String)
                }
            }
            print(self.list_uname)
            if (self.list_uname.isEmpty) {
                print("---valid---")
                if let username = self.unamefield.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                   !username.isEmpty,
                   let password = self.passfield.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                   !password.isEmpty {
                    print("Valid input - Username: \(username), Password: \(password)")
                    self.isValid = true
                } else {
                    print("Invalid input")
                    self.isValid = false
                }
            } else {
                for data_uname in self.list_uname {
                    if (data_uname == self.unamefield.text) {
                        self.isValid = false
                        print("---not valid---")
                        break
                    } else {
                        print("---valid---")
                        if let username = self.unamefield.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                           !username.isEmpty,
                           let password = self.passfield.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                           !password.isEmpty {
                            print("Valid input - Username: \(username), Password: \(password)")
                            self.isValid = true
                        } else {
                            print("Invalid input")
                            self.isValid = false
                        }
                    }
                }
            }
            print(self.isValid)
            if (self.isValid == true) {
                let val = [ "uid": self.unamefield.text, "pass": self.passfield.text ]
                self.ref.child("user").childByAutoId().setValue(val)
                print("---added to db---")
                print("---signed up---")
                self.performSegue(withIdentifier: "toLogin", sender: self)
            } else {
                self.showAlert(message: "Username is already taken. Please choose another one.")
            }
        }) { error in
            print("Error retrieving data: \(error.localizedDescription)")
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func showhide(_ sender: UIButton) {
        if (passfield.isSecureTextEntry == true) {
            passfield.isSecureTextEntry = false
            eyeLb.image = UIImage(systemName: "eye.slash.fill")
        } else {
            passfield.isSecureTextEntry = true
            eyeLb.image = UIImage(systemName: "eye.fill")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
        // view
        setUpView()
        setUpLoginContainer()
        if (passfield.isSecureTextEntry == true) {
            eyeLb.image = UIImage(systemName: "eye.fill")
        } else {
            eyeLb.image = UIImage(systemName: "eye.slash.fill")
        }
        
    }
    
    func setUpLoginContainer() {
        loginContainer.layer.cornerRadius = 20
        loginContainer.layer.borderWidth = 4.0
        loginContainer.layer.borderColor = UIColor.black.cgColor
        loginContainer.layer.masksToBounds = true
        loginContainer.layer.shadowColor = UIColor.white.cgColor
        loginContainer.layer.shadowOpacity = 1
        loginContainer.layer.shadowOffset = CGSize(width: 0, height: 0)
        loginContainer.layer.shadowRadius = 30.0
        loginContainer.clipsToBounds = false
        loginContainer.layer.zPosition = 1
        loginContainer.layer.shadowPath = UIBezierPath(rect: loginContainer.bounds).cgPath
        unamefield.layer.opacity = 1
    }
    
    func setUpView() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.white.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.0, 0.5]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.frame = GradientView.bounds
        GradientView.layer.insertSublayer(gradientLayer, at: 0)
    }

}
