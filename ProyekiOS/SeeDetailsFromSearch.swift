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
    func backHabisEdit(namalama:String, titlenya: String, contentnya: String, datenya: String)
//    func backMauEditEvent(titlenya: String, contentnya: String, datenya: String)
}
class SeeDetailsFromSearch: UIViewController, KembaliDariNotes {
    var delegasi: KembaliDelegatee?
    
    var ref: DatabaseReference!
    
    var typee : String?
    var datee : String?
    var titlee : String?
    var contentt : String?
    
    func habiseditnotes(titleparam: String, contentparam: String){
        
        print(">> back to main")
        if(typee=="notes"){
            delegasi?.backHabisEdit(namalama: self.titlee ?? "", titlenya: titleparam, contentnya: contentparam, datenya: self.datee ?? "")
            navigationController?.popViewController(animated: true) //back
        }

    }
    
    @IBAction func editBtn(_ sender: UIBarButtonItem) {
        if(typee=="notes"){
            print("editbtn notes")
            performSegue(withIdentifier: "editSearchNotes", sender: self)
        }
//        else{
//            performSegue(withIdentifier: "editSearchEvents", sender: self)
//        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare detail")
        
        let vc = segue.destination as? ViewController2
        vc?.judulIsi = titlee ?? "null"
        vc?.contentIsi = contentt ?? "null"
        vc?.dariRexy = 1
        print("prepare ke page vc 2")
        vc?.delegasiSearch = self
//
//        var vc2 = segue.destination as? EventEditViewController
////        vc2?.fotoItem = thumbnail[indexKe]
////        vc2?.nama = itemName[indexKe]
////        vc2?.jumlah = itemQty[indexKe]
////        vc2?.harga = itemPrice[indexKe]
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
