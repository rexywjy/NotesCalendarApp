import UIKit
import Firebase

class EventEditViewController: UIViewController {

    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!

    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database(url: "https://projekios-6af0f-default-rtdb.asia-southeast1.firebasedatabase.app/").reference()
        datePicker.date = selectedDate
    }

    @IBAction func saveAction(_ sender: Any) {
        guard let eventName = nameTF.text else { return }

        // Firebase Realtime Database
        let eventDict: [String: Any] = [
            "name": eventName,
            "date": datePicker.date.timeIntervalSince1970 // Store date as a timestamp
        ]

        let newEventRef = ref.child("events").childByAutoId()

        newEventRef.setValue(eventDict) { (error, _) in
            if let error = error {
                print("Error saving event to Firebase: \(error.localizedDescription)")
            } else {
                print("Event saved to Firebase successfully!")

                // Local array
                let newEvent = Event()
                newEvent.id = eventsList.count
                newEvent.name = eventName
                newEvent.date = self.datePicker.date
                eventsList.append(newEvent)

                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
