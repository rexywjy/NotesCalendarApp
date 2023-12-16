import UIKit
import Firebase

class EventEditViewController: UIViewController {

    @IBOutlet weak var descriptionTV: UITextView!
//    @IBOutlet weak var descriptionTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var editingEvent: Event?
    var ref: DatabaseReference!
    var selectedDate = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database(url: "https://projekios-6af0f-default-rtdb.asia-southeast1.firebasedatabase.app/").reference()
        
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
        
        if let eventId = editingEvent?.id {
            ref.child("events").child(eventId).updateChildValues(eventDict) { (error, _) in
                if let error = error {
                    print("Error updating event in Firebase: \(error.localizedDescription)")
                } else {
                    print("Event updated in Firebase successfully!")
                    self.navigationController?.popViewController(animated: true)
                }
            }
        } else {
            ref.child("events").child(eventDict["id"] as! String).setValue(eventDict) { (error, _) in
                if let error = error {
                    print("Error saving event to Firebase: \(error.localizedDescription)")
                } else {
                    print("Event saved to Firebase successfully!")
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }


    @IBAction func saveAction(_ sender: Any) {
        saveEvent()
    }
}
