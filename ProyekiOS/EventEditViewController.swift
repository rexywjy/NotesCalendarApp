import UIKit
import Firebase

protocol KembaliDariEvents{
    func habiseditevents(titleparam: String, contentparam: String, datenya: String)
}


class EventEditViewController: UIViewController {

    @IBOutlet weak var descriptionTV: UITextView!
//    @IBOutlet weak var descriptionTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var delegasiSearch : KembaliDariEvents?
    
    var editingEvent: Event?
    var ref: DatabaseReference!
    var selectedDate = Date()
    var dariRexy = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database(url: "https://projekios-6af0f-default-rtdb.asia-southeast1.firebasedatabase.app/").reference()
        print(editingEvent ?? "")
        setupForEditing()
    }
    
    private func setupForEditing() {
        if let event = editingEvent {
            descriptionTV.text = event.description
            nameTF.text = event.name
            datePicker.date = event.date
        }
    }
    
    private func saveEvent() {
        guard let eventName = nameTF.text else { return }
        guard let eventDescription = descriptionTV.text else { return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        let eventDict: [String: Any] = [
            "name": eventName,
            "date": dateFormatter.string(from: datePicker.date),
            "id": editingEvent?.id ?? UUID().uuidString,
            "description": eventDescription,
            "time": datePicker.date.timeIntervalSince1970,
        ]
        print(datePicker.date)
        
        if let eventId = editingEvent?.id {
//            if(self.dariRexy==1){
//                // Create a date formatter for the time
//                let timeFormatter = DateFormatter()
//                timeFormatter.dateFormat = "HH:mm:ss" // Customize the time format as needed
//                let timeString = timeFormatter.string(from: (self.editingEvent?.time)!)
//                self.delegasiSearch?.habiseditevents(
//                    titleparam: self.editingEvent?.name ?? "",
//                    contentparam: self.editingEvent?.description ?? "",
//                    datenya: timeString)
//                self.navigationController?.popViewController(animated: true)
//            }
            if(self.dariRexy==0){
                ref.child("events").child(eventId).updateChildValues(eventDict) { (error, _) in
                    if let error = error {
                        print("Error updating event in Firebase: \(error.localizedDescription)")
                    } else {
                        print("Event updated in Firebase successfully!")
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
            else{
                ref.child("events").child(eventId).updateChildValues(eventDict) { (error, _) in
                    if let error = error {
                        print("Error updating event in Firebase: \(error.localizedDescription)")
                    } else {
                        print("Event added in Firebase successfully!")
                        self.ref.child("events").queryOrdered(byChild: "name").queryEqual(toValue: self.editingEvent?.name).observeSingleEvent(of: .value, with: { (snapshot) in
                                        guard let dictionary = snapshot.value as? [String:Any] else {return}
                                        dictionary.forEach({ (key , _) in
                                            self.ref.child("events/\(key)").removeValue()
                                        })
                            print("Event removed in Firebase successfully!")
                            // Create a date formatter for the time
                            let timeFormatter = DateFormatter()
                            timeFormatter.dateFormat = "HH:mm:ss" // Customize the time format as needed
                            let timeString = timeFormatter.string(from: (self.editingEvent?.time)!)
                            self.delegasiSearch?.habiseditevents(
                                titleparam: self.editingEvent?.name ?? "",
                                contentparam: self.editingEvent?.description ?? "",
                                datenya: timeString)
                            self.navigationController?.popViewController(animated: true)
                                    }) { (Error) in
                                        print("Failed to fetch: ", Error)
                                    }
                        
                    }
                }
            }
        } else {
            if(self.dariRexy==0){
                ref.child("events").child(eventDict["id"] as! String).setValue(eventDict) { (error, _) in
                    if let error = error {
                        print("Error saving event to Firebase: \(error.localizedDescription)")
                    } else {
                        print("Event saved to Firebase successfully!")
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
            else{
                print("Event updated in Firebase successfully!")
                // Create a date formatter for the time
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "HH:mm:ss" // Customize the time format as needed
                let timeString = timeFormatter.string(from: (self.editingEvent?.time)!)
                self.delegasiSearch?.habiseditevents(
                    titleparam: self.editingEvent?.name ?? "",
                    contentparam: self.editingEvent?.description ?? "",
                    datenya: timeString)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }


    @IBAction func saveAction(_ sender: Any) {
        saveEvent()
    }
}
