//
//  ViewController2.swift
//  ProyekiOS
//
//  Created by Patrick Giovanno on 28/11/23.
//

import UIKit

protocol KembaliDelegate2 {
    func dari2(nama: String, content: String, new: Int, keberapa: Int)
}

class ViewController2: UIViewController {
    
    var delegasi2: KembaliDelegate2?
    
    var isNew: Int = 1
    var judulIsi: String = ""
    var contentIsi: String = ""
    var keberapaa: Int = -1

    @IBOutlet weak var save: UIButton!
    @IBAction func save(_ sender: UIButton) {
        delegasi2?.dari2(nama: String(judul.text!), content: String(content.text!), new: isNew, keberapa: keberapaa)
        navigationController?.popViewController(animated: true) //back
    }
    @IBOutlet weak var judul: UITextField!
    @IBOutlet weak var content: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let lineView = UIView(frame: CGRect(x: 0, y: 140, width: 1000, height: 1.00))
        lineView.layer.borderWidth = 1.0
        lineView.layer.borderColor = UIColor.gray.cgColor
        self.view.addSubview(lineView)
        
        judul.borderStyle = .none
        content.isEditable = true
        content.isSelectable = true
        
        judul.text = judulIsi
        content.text = contentIsi
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
