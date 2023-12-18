//
//  LoginViewController.swift
//  ProyekiOS
//
//  Created by jodem on 17/12/23.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    var ref : DatabaseReference!
    var list_uname : [String] = []
    var list_pass : [String] = []
    var isFoundName : Bool = false
    var isFoundPass : Bool = false
    var currUid : String = ""

    @IBOutlet weak var GradientView: UIView!
    @IBOutlet weak var loginContainer: UIView!
    @IBOutlet weak var unamefield: UITextField!
    @IBOutlet weak var passfield: UITextField!
    @IBOutlet weak var eyeLb: UIImageView!
    
    @IBAction func toSignUp(_ sender: UIButton) {
        performSegue(withIdentifier: "toSignUp", sender: self)
    }
    
    @IBAction func loginBtn(_ sender: UIButton) {
        self.list_uname = []
        self.list_pass = []
        var idx : Int = -1
        // database
        ref = Database.database(url: "https://projekios-6af0f-default-rtdb.asia-southeast1.firebasedatabase.app/").reference()
        // fetch all uname
        ref.child("user").observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let userData = childSnapshot.value as? [String:Any] {
                    self.list_uname.append(userData["uid"] as! String)
                    self.list_pass.append(userData["pass"] as! String)
                }
            }
            print(self.list_uname)
            print(self.list_uname)
            for data_uname in self.list_uname {
                idx = idx + 1
                if (data_uname == self.unamefield.text) {
                    self.isFoundName = true
                    print("---uid found---")
                    if (self.passfield.text == self.list_pass[idx]) {
                        self.isFoundPass = true
                        print("---pass correct---")
                        break
                    } else {
                        self.isFoundPass = false
                        print("---pass incorrect---")
                    }
                    break
                } else {
                    print("---uid not found---")
                    self.isFoundName = false
                }
                
            }
            
            print(self.isFoundName)
            print(self.isFoundPass)
            if (self.isFoundName == true && self.isFoundPass == true) {
                self.currUid = self.list_uname[idx]
                print("currUid: \(self.currUid)")
                print("---found in db---")
                print("---signed in---")
                self.performSegue(withIdentifier: "already", sender: self)
            } else if (self.isFoundName == false) {
                self.showAlert(message: "Username not registered. Please sign up first.")
            } else if (self.isFoundPass == false) {
                self.showAlert(message: "Wrong password.")
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
        setUpView()
        setUpLoginContainer()
        if (passfield.isSecureTextEntry == true) {
            eyeLb.image = UIImage(systemName: "eye.fill")
        } else {
            eyeLb.image = UIImage(systemName: "eye.slash.fill")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // passing current login uid
        
        if let tabBarController = segue.destination as? UITabBarController {
            if let navigationController = tabBarController.viewControllers?[0] as? UINavigationController {
                if let vc1 = navigationController.viewControllers[0] as? ViewController {
//                    vc1.uidLogin = self.currUid
                }
            }
            if let navigationController = tabBarController.viewControllers?[1] as? UINavigationController {
                if let vc2 = navigationController.viewControllers[0] as? MonthlyViewController {
//                    vc2.uidLogin = self.currUid
                }
            }
            if let navigationController = tabBarController.viewControllers?[2] as? UINavigationController {
                if let vc3 = navigationController.viewControllers[0] as? SearchViewController {
//                    vc3.uidLogin = self.currUid
                }
            }
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
        gradientLayer.colors = [UIColor.black.cgColor, UIColor.white.cgColor]
        gradientLayer.locations = [0.5, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.frame = GradientView.bounds
        GradientView.layer.insertSublayer(gradientLayer, at: 0)
    }

}
