//
//  Statistic.swift
//  ProyekiOS
//
//  Created by acto on 17/12/23.
//

import UIKit
import FirebaseDatabase

class StatisticsViewController: UIViewController {
    @IBOutlet weak var eventCountLabel: UILabel!
    @IBOutlet weak var notesCountLabel: UILabel!
    
    @IBOutlet weak var NotesImageV: UIImageView!
    @IBOutlet weak var EventImageV: UIImageView!
    var imgEvent: UIImage = UIImage()
    var imgNotes: UIImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchEventData()
        fetchNotesData()
        // Do any additional setup after loading the view.
    }
    func fetchEventData() {
//        var ref3: DatabaseReference!
//        ref3 = Database.database(url: "https://projekios-6af0f-default-rtdb.asia-southeast1.firebasedatabase.app/").reference()
//        ref3.child("events").observeSingleEvent(of: .value, with: { snapshot in
            var databaseReference: DatabaseReference!
        databaseReference = Database.database(url:  "https://projekios-6af0f-default-rtdb.asia-southeast1.firebasedatabase.app/").reference()

        databaseReference.child("events").observeSingleEvent(of: .value) { [self] (snapshot) in
            // Menghitung jumlah event
//            let eventCount = snapshot.childrenCount
//            print("haloooooo", eventCount)
//            // Menampilkan jumlah event pada label
//            self.eventCountLabel.text = "Jumlah Event: \(eventCount)"
                var count = 0
                for _ in snapshot.children {
                    print("hallo")
                    count=count+1
                }
            if (count <= 10) {
                imgEvent = UIImage(named: "sad-2-2") ?? UIImage()
            } else if (count > 10 && count <= 20) {
                imgEvent = UIImage(named: "happy-2") ?? UIImage()
            } else {
                imgEvent = UIImage(named: "cool-2") ?? UIImage()
            }
            self.eventCountLabel.text = "Jumlah Event: \(count)"
            self.EventImageV.image = imgEvent
        }
    }
    
    func fetchNotesData() {
//        var ref3: DatabaseReference!
//        ref3 = Database.database(url: "https://projekios-6af0f-default-rtdb.asia-southeast1.firebasedatabase.app/").reference()
//        ref3.child("events").observeSingleEvent(of: .value, with: { snapshot in
            var databaseReference: DatabaseReference!
        databaseReference = Database.database(url:  "https://projekios-6af0f-default-rtdb.asia-southeast1.firebasedatabase.app/").reference()

        databaseReference.child("notes").observeSingleEvent(of: .value) { [self] (snapshot) in
            // Menghitung jumlah event
                var count = 0
                for _ in snapshot.children {
                    print("hallo")
                    count=count+1
                }
            if (count <= 10) {
                imgNotes = UIImage(named: "sad-2-2") ?? UIImage()
            } else if (count > 10 && count <= 20) {
                imgNotes = UIImage(named: "happy-2") ?? UIImage()
            } else {
                imgNotes = UIImage(named: "cool-2") ?? UIImage()
            }
            self.notesCountLabel.text = "Jumlah Notes: \(count)"
            self.NotesImageV.image = imgNotes
        }
    }
}
