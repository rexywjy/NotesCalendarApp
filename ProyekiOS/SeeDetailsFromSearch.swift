//
//  SeeDetailsFromSearch.swift
//  ProyekiOS
//
//  Created by Rexy Wijaya Singo Putro on 15/12/23.
//

import UIKit
import Firebase
import Foundation

protocol KembaliDelegatee{
    func deleteNoteRex(title: String, tipenya: String)
    func backHabisEdit(tipenya: String, namalama:String, titlenya: String, contentnya: String, datenya: String)
//    func backMauEditEvent(titlenya: String, contentnya: String, datenya: String)
}
class SeeDetailsFromSearch: UIViewController, KembaliDariNotes, KembaliDariEvents {
    
    func habiseditevents(titleparam: String, contentparam: String, datenya: String) {
        print(">> back to main events")
        if(typee=="events"){
            delegasi?.backHabisEdit(tipenya: "events", namalama: self.titlee ?? "", titlenya: titleparam, contentnya: contentparam, datenya: self.datee ?? "")
            navigationController?.popViewController(animated: true) //back
        }
    }
    
    var delegasi: KembaliDelegatee?
    
    var ref: DatabaseReference!
    
    var typee : String?
    var datee : String!
    var titlee : String?
    var contentt : String?
    
    func habiseditnotes(titleparam: String, contentparam: String){
        
        print(">> back to main notes")
        if(typee=="notes"){
            delegasi?.backHabisEdit(tipenya: "notes",namalama: self.titlee ?? "", titlenya: titleparam, contentnya: contentparam, datenya: self.datee ?? "")
            navigationController?.popViewController(animated: true) //back
        }

    }
    
    @IBAction func editBtn(_ sender: UIBarButtonItem) {
        if(typee=="notes"){
            print("editbtn notes")
            performSegue(withIdentifier: "editSearchNotes", sender: self)
        }
        else{
            performSegue(withIdentifier: "editSearchEvents", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare detail")
        
        let vc = segue.destination as? ViewController2
        vc?.judulIsi = titlee ?? "null"
        vc?.contentIsi = contentt ?? "null"
        vc?.dariRexy = 1
        print("prepare ke page vc 2")
        vc?.delegasiSearch = self
        
        print(datee)
        let vc2 = segue.destination as? EventEditViewController
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy/MM/dd;HH:mm:ss"

        if let dateTime = dateFormatter.date(from: datee) {
            // Extract date and time components
            let date = Calendar.current.startOfDay(for: dateTime) // Date without time component
            let time = Calendar.current.dateComponents([.hour, .minute, .second], from: dateTime)

            vc2?.editingEvent = Event(name: titlee ?? "", date: date, time: time.date ?? Date(), description: contentt ?? "")
            vc2?.dariRexy = 1
            vc2?.delegasiSearch = self
            print("prepare detail")
        } else {
            // Handle the case where the datee string couldn't be parsed
            print("Error parsing datee")
        }
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//
//        let timeFormatter = DateFormatter()
//        timeFormatter.dateFormat = "h:mm a"
//
////
//        let vc2 = segue.destination as? EventEditViewController
//        let dateFormatter = DateFormatter()
//        print(datee)
//        dateFormatter.dateFormat = "yy/MM/dd;hh:mm:ss"
//        vc2?.editingEvent = Event(name: titlee ?? "", date: dateFormatter.date(from: datee)!, time: dateFormatter.date(from: datee)!, description: contentt ?? "")
//        vc2?.dariRexy = 1
//        vc2?.delegasiSearch = self
//        print("prepare detail")
    }
    @IBAction func deleteBtn(_ sender: UIBarButtonItem) {
        print("deletebutton pressed")
        delegasi?.deleteNoteRex(title: titlee ?? "", tipenya: typee ?? "")
        navigationController?.popViewController(animated: true) //back
    }
    
    @IBOutlet weak var tanggal: UILabel!
    @IBOutlet weak var judul: UILabel!
    @IBOutlet weak var konten: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database(url: "https://projekios-6af0f-default-rtdb.asia-southeast1.firebasedatabase.app/").reference()
        
        if(self.typee == "notes"){
            tanggal.text = datee ?? "yy/mm/dd"
        }else{
            let inputString = datee ?? ""
            let separatedArray = inputString.components(separatedBy: ";")
            tanggal.text = separatedArray[0] + "   " + separatedArray[1]
        }
        judul.text = titlee ?? "nill"
        konten.text = contentt ?? "no content"
        // Do any additional setup after loading the view.
//        self.navigationController?.b
        title = self.typee?.uppercased()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
