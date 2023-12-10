import UIKit
import Firebase

var selectedDate = Date()

class WeeklyViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,
                            UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedDateEvents: [Event] = []
    var ref: DatabaseReference!
    
    var totalSquares = [Date]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        ref = Database.database(url: "https://projekios-6af0f-default-rtdb.asia-southeast1.firebasedatabase.app/").reference()
        
        setCellsView()
        setWeekView()
        fetchEvents()
    }
    
    func fetchEvents() {
        ref.child("events").observe(.value, with: { snapshot in
            self.selectedDateEvents.removeAll()

            if let snapshotValue = snapshot.value as? [String: Any] {
                for (_, value) in snapshotValue {
                    if let eventDict = value as? [String: Any],
                       let eventName = eventDict["name"] as? String,
                       let timestamp = eventDict["date"] as? TimeInterval,
                       let eventId = eventDict["id"] as? String {

                        let event = Event(name: eventName, date: Date(timeIntervalSince1970: timestamp))
                        event.id = eventId

                        if Calendar.current.isDate(event.date, inSameDayAs: selectedDate) {
                            self.selectedDateEvents.append(event)
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        })
    }

    func deleteEvent(at indexPath: IndexPath) {
        let deletedEvent = selectedDateEvents.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)

        let eventId = deletedEvent.id
        ref.child("events").child(eventId).removeValue()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteEvent(at: indexPath)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        editEvent(at: indexPath)
    }

    func editEvent(at indexPath: IndexPath) {
        let editEventVC = storyboard?.instantiateViewController(withIdentifier: "EventEditViewController") as! EventEditViewController
        editEventVC.editingEvent = selectedDateEvents[indexPath.row]
        navigationController?.pushViewController(editEventVC, animated: true)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] (_, _, completionHandler) in
            self?.editEvent(at: indexPath)
            completionHandler(true)
        }
        editAction.backgroundColor = .blue

        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
            self?.deleteEvent(at: indexPath)
            completionHandler(true)
        }

        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }

    
    func setCellsView()
    {
        let width = (collectionView.frame.size.width - 2) / 8
        let height = (collectionView.frame.size.height - 2)
        
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.itemSize = CGSize(width: width, height: height)
    }
    
    func setWeekView()
    {
        totalSquares.removeAll()
        
        var current = CalendarHelper().sundayForDate(date: selectedDate)
        let nextSunday = CalendarHelper().addDays(date: current, days: 7)
        
        while (current < nextSunday)
        {
            totalSquares.append(current)
            current = CalendarHelper().addDays(date: current, days: 1)
        }
        
        monthLabel.text = CalendarHelper().monthString(date: selectedDate)
            + " " + CalendarHelper().yearString(date: selectedDate)
        collectionView.reloadData()
        tableView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        totalSquares.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calCell", for: indexPath) as! CalendarCell
        
        let date = totalSquares[indexPath.item]
        cell.dayOfMonth.text = String(CalendarHelper().dayOfMonth(date: date))
        
        if(date == selectedDate)
        {
            cell.backgroundColor = UIColor.systemGreen
        }
        else
        {
            cell.backgroundColor = UIColor.white
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        selectedDate = totalSquares[indexPath.item]
        setWeekView()
        fetchEvents()
        collectionView.reloadData()
        tableView.reloadData()
    }
    
    @IBAction func previousWeek(_ sender: Any)
    {
        selectedDate = CalendarHelper().addDays(date: selectedDate, days: -7)
        setWeekView()
    }
    
    @IBAction func nextWeek(_ sender: Any)
    {
        selectedDate = CalendarHelper().addDays(date: selectedDate, days: 7)
        setWeekView()
    }
    
    override open var shouldAutorotate: Bool
    {
        return false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return selectedDateEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as! EventCell
           if indexPath.row < selectedDateEvents.count {
               let event = selectedDateEvents[indexPath.row]
               cell.eventLabel.text = event.name + " " + CalendarHelper().timeString(date: event.date)
           } else {
               cell.eventLabel.text = "Invalid Index"
           }

        return cell
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
}
