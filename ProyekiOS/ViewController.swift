//
//  ViewController.swift
//  ProyekiOS
//
//  Created by Kelvin Sidharta Sie on 23/11/23.
//

import UIKit
import Firebase

class ViewController: UIViewController, KembaliDelegate2, UICollectionViewDelegate, UICollectionViewDataSource {

    var ref: DatabaseReference!
    var vc2: ViewController2?
    
    var keberapa: Int = -1
       
    @IBOutlet weak var collectionView: UICollectionView!
    //@IBOutlet weak var addBtn: UIButton!
    @IBAction func addBtn(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "draw", sender: self)
    }
    @IBAction func reverse(_ sender: UIBarButtonItem) {
        judulNotes.reverse()
        contentNotes.reverse()
        tanggalNotes.reverse()
        collectionView.reloadData()
    }
    //@IBAction func addBtn(_ sender: UIButton) {
    //    performSegue(withIdentifier: "draw", sender: self)
    //}
    var colors: [UIColor] = [.systemIndigo, .systemGreen, .systemBlue, .systemTeal,
                             .systemOrange, .systemPurple,
                             .systemYellow, .systemPink]
    
    var judulNotes: [String] = []
    var tanggalNotes: [String] = []
    var contentNotes: [String] = []

   @IBAction func keFirebase(_ sender: UIButton) {
       // Create Date
       let date = Date()

       // Create Date Formatter
       let dateFormatter = DateFormatter()

       // Set Date Format
       dateFormatter.dateFormat = "YY/MM/dd HH:mm"

       // Convert Date to String
       let datenoww = dateFormatter.string(from: date)
       let val = [ "nama": "nama", "date": datenoww, "content": "content" ]
       ref.child("notes").childByAutoId().setValue(val)
       
   }
    
    @IBAction func newNote(_ sender: UIButton) {
        //ref.child("detail").queryOrdered(byChild: "nama").queryEqual(toValue: nama.text).observeSingleEvent(of: .value, with: { (snapshot) in
        //    guard let dictionary = snapshot.value as? [String:Any] else {return}
        //    dictionary.forEach({ (key , _) in
        //        self.ref.child("detail/\(key)").removeValue()
        //    })
        //}) { (Error) in
        //    print("Failed to fetch: ", Error)
        //}
        keberapa = -1
        performSegue(withIdentifier: "newNote", sender: self)
        //Kelvin
    }
    
    
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       vc2 = segue.destination as? ViewController2
       
       if (keberapa == -1) {
           vc2?.judulIsi = ""
           vc2?.contentIsi = ""
       } else {
           vc2?.judulIsi = judulNotes[keberapa]
           vc2?.contentIsi = contentNotes[keberapa]
           vc2?.isNew = 0
           vc2?.keberapaa = keberapa
       }
       vc2?.delegasi2 = self
   }
    
   override func viewDidLoad() {
       super.viewDidLoad()
       ref = Database.database(url: "https://projekios-6af0f-default-rtdb.asia-southeast1.firebasedatabase.app/").reference()
       
       collectionView?.delegate = self
       collectionView?.dataSource = self
       
       //addBtn.setImage(
       //    UIImage(systemName: "paintbrush.pointed.fill", withConfiguration: //UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: //.large))
       //                , for: .normal
       //)
       //addBtn.tintColor = UIColor.label
       
       ref.child("notes").observe(.value, with: { (snapshot) in
           for child in snapshot.children {
               let child = child as! DataSnapshot
               if let childVal = child.value as? [String: AnyObject] {
                   self.judulNotes.append(childVal["nama"] as! String)
                   self.contentNotes.append(childVal["content"] as! String)
                   self.tanggalNotes.append(childVal["date"] as! String)
                   
               }
               self.collectionView.reloadData()
           }
       }){ (error) in
           print(error.localizedDescription)
       }
       
       let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
       collectionView?.addGestureRecognizer(gesture)
       
   }
    
    @objc func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
            guard let collectionView = collectionView else {
                return
            }
            switch gesture.state {
            case .began:
                guard let targetIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else {
                    return
                }
                collectionView.beginInteractiveMovementForItem(at: targetIndexPath)
            case .changed:
                collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: collectionView))
            case .ended:
                collectionView.endInteractiveMovement()
            default:
                collectionView.cancelInteractiveMovement()
            }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return judulNotes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        //cell.backgroundColor = colors[Int.random(in: 0..<colors.count)]
        cell.judul.text = judulNotes[indexPath.row]
        cell.tanggal.text = tanggalNotes[indexPath.row]
        cell.viewnya.layer.borderWidth = 2 // design main card
        cell.viewnya.layer.borderColor = UIColor.black.cgColor
        cell.viewnya.layer.shadowColor = UIColor.black.cgColor
        cell.viewnya.layer.shadowOffset = CGSize(width: 7.0, height: 7.0)
        cell.viewnya.layer.shadowOpacity = 1.0
        cell.viewnya.layer.shadowRadius = 0.0
        cell.viewnya.layer.masksToBounds = false
        cell.viewnya.layer.cornerRadius = 12.0
        cell.viewnya.backgroundColor = colors[Int.random(in: 0..<colors.count)]
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        keberapa = indexPath.row
        print(keberapa)
        print(judulNotes[keberapa])
        performSegue(withIdentifier: "newNote", sender: self)
    }

    //Reorder
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    }
    
    func dari2(nama: String, content: String, new: Int, keberapa: Int) {
        if (new == 1) {
            // Create Date
            let date = Date()
            
            // Create Date Formatter
            let dateFormatter = DateFormatter()
            
            // Set Date Format
            dateFormatter.dateFormat = "YY/MM/dd"
            
            // Convert Date to String
            let datenoww = dateFormatter.string(from: date)
            let val = [ "nama": nama, "date": datenoww, "content": content ]
            ref.child("notes").childByAutoId().setValue(val)
        } else {
            let post = [ "nama": nama, "date": tanggalNotes[keberapa], "content": content]
            ref.child("notes").queryOrdered(byChild: "nama").queryEqual(toValue: judulNotes[keberapa]).observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dictionary = snapshot.value as? [String:Any] else {return}
                dictionary.forEach({ (key , _) in
                    let childUpdates = [ key: post ]
                    self.ref.child("notes").updateChildValues(childUpdates)
                })
            }) { (Error) in
                print("Failed to fetch: ", Error)
            }

        }
        
        judulNotes = []
        tanggalNotes = []
        contentNotes = []
        collectionView.reloadData()
        
    }

}

