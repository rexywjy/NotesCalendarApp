//
//  ViewController.swift
//  ProyekiOS
//
//  Created by Kelvin Sidharta Sie on 23/11/23.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    var ref: DatabaseReference!
       
   @IBOutlet weak var nama: UITextField!
   @IBOutlet weak var email: UITextField!

   @IBAction func keFirebase(_ sender: UIButton) {
       let val = [ "nama": nama.text, "email": email.text ]
       ref.child("detail").childByAutoId().setValue(val)
   }
    
    @IBAction func deleteData(_ sender: UIButton) {
        ref.child("detail").queryOrdered(byChild: "nama").queryEqual(toValue: nama.text).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String:Any] else {return}
            dictionary.forEach({ (key , _) in
                self.ref.child("detail/\(key)").removeValue()
            })
        }) { (Error) in
            print("Failed to fetch: ", Error)
        }
    }
    
    
       override func viewDidLoad() {
           super.viewDidLoad()
           ref = Database.database(url: "https://projekios-6af0f-default-rtdb.asia-southeast1.firebasedatabase.app/").reference()
       }



}

