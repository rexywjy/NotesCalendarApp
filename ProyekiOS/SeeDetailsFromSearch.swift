//
//  SeeDetailsFromSearch.swift
//  ProyekiOS
//
//  Created by Rexy Wijaya Singo Putro on 15/12/23.
//

import UIKit

protocol KembaliDelegatee{
    func deleteNoteRex(title: String, tipenya: String)
}

class SeeDetailsFromSearch: UIViewController {
    var delegasi: KembaliDelegatee?
    
    var typee : String?
    var datee : String?
    var titlee : String?
    var contentt : String?
    
    @IBAction func editBtn(_ sender: UIBarButtonItem) {
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
