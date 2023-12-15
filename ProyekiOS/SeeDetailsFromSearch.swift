//
//  SeeDetailsFromSearch.swift
//  ProyekiOS
//
//  Created by Rexy Wijaya Singo Putro on 15/12/23.
//

import UIKit

protocol KembaliDelegatee{
}

class SeeDetailsFromSearch: UIViewController {
    var delegasi: KembaliDelegatee?
    
    var typee = ""
    var datee = ""
    var titlee = ""
    var contentt = ""
    
    @IBOutlet weak var tipe: UILabel!
    @IBOutlet weak var tanggal: UILabel!
    @IBOutlet weak var judul: UILabel!
    
    @IBOutlet weak var konten: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
