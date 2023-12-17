//
//  SearchViewController.swift
//  ProyekiOS
//
//  Created by Rexy Wijaya Singo Putro on 15/12/23.
//

import UIKit
import Firebase
import Foundation

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, KembaliDelegatee {
    func deleteNoteRex(title: String, tipenya: String) {
        self.rowSelected = -1
        if(tipenya == "notes"){
            ref.child("notes").queryOrdered(byChild: "nama").queryEqual(toValue: title).observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dictionary = snapshot.value as? [String:Any] else {return}
                dictionary.forEach({ (key , _) in
                    self.ref.child("notes/\(key)").removeValue()
                })
                
                
                var ref2: DatabaseReference!
                ref2 = Database.database(url: "https://projekios-6af0f-default-rtdb.asia-southeast1.firebasedatabase.app/").reference()
                ref2.child("notes").observeSingleEvent(of: .value, with: { snapshot in
                    // Loop through each user
                    var count = 0
                    self.namaa = []
                    self.datee = []
                    self.contentt = []
                    self.tipe = []
                    for child in snapshot.children {
                        if let childSnapshot = child as? DataSnapshot,
                           let userData = childSnapshot.value as? [String: Any] {
                            // Print the data
                            let nama = userData["nama"] ?? ""
                            let date = userData["date"] ?? ""
                            let cont = userData["content"] ?? ""
                            self.namaa.append(nama as! String)
                            self.datee.append(date as! String)
                            self.contentt.append(cont as! String)
                            self.tipe.append("notes")
                        }
                        count=count+1
                    }
                    print(self.namaa)
                    
                    var ref3: DatabaseReference!
                    ref3 = Database.database(url: "https://projekios-6af0f-default-rtdb.asia-southeast1.firebasedatabase.app/").reference()
                    ref3.child("events").observeSingleEvent(of: .value, with: { snapshot in
                        // Loop through each user
                        var count = 0
                        for child in snapshot.children {
                            if let childSnapshot = child as? DataSnapshot,
                               let userData = childSnapshot.value as? [String: Any] {
                                
                                let timeInterval = userData["time"] ?? ""
                                
                                let date = Date(timeIntervalSince1970: timeInterval as! TimeInterval)
                                
                                // Create a date formatter for the date
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yy/MM/dd" // Customize the date format as needed
                                let dateString = dateFormatter.string(from: date)

                                // Create a date formatter for the time
                                let timeFormatter = DateFormatter()
                                timeFormatter.dateFormat = "HH:mm:ss" // Customize the time format as needed
                                let timeString = timeFormatter.string(from: date)
                                
                                // Print the data
                                let nama = userData["name"] ?? ""
                                let datee = dateString + ";" + timeString
                                let cont = userData["description"] ?? ""
                                self.namaa.append(nama as! String)
                                self.datee.append(datee)
                                self.contentt.append(cont as! String)
                                self.tipe.append("events")
                            }
                            count=count+1
                        }
                        print(self.namaa)
                        self.tableview.reloadData()
                        
                    }) { error in
                        print("Error retrieving data: \(error.localizedDescription)")
                    }
                    
                    
                    self.tableview.reloadData()
                }) { error in
                    print("Error retrieving data: \(error.localizedDescription)")
                }
                
                self.tableview.reloadData()
            }) { (Error) in
                print("Failed to fetch: ", Error)
            }
            
            
        } else if(tipenya == "events"){
            ref.child("events").queryOrdered(byChild: "name").queryEqual(toValue: title).observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dictionary = snapshot.value as? [String:Any] else {return}
                dictionary.forEach({ (key , _) in
                    self.ref.child("events/\(key)").removeValue()
                })
                
                
                var ref2: DatabaseReference!
                ref2 = Database.database(url: "https://projekios-6af0f-default-rtdb.asia-southeast1.firebasedatabase.app/").reference()
                ref2.child("notes").observeSingleEvent(of: .value, with: { snapshot in
                    // Loop through each user
                    var count = 0
                    self.namaa = []
                    self.datee = []
                    self.contentt = []
                    self.tipe = []
                    for child in snapshot.children {
                        if let childSnapshot = child as? DataSnapshot,
                           let userData = childSnapshot.value as? [String: Any] {
                            // Print the data
                            let nama = userData["nama"] ?? ""
                            let date = userData["date"] ?? ""
                            let cont = userData["content"] ?? ""
                            self.namaa.append(nama as! String)
                            self.datee.append(date as! String)
                            self.contentt.append(cont as! String)
                            self.tipe.append("notes")
                        }
                        count=count+1
                    }
                    print(self.namaa)
                    
                    var ref3: DatabaseReference!
                    ref3 = Database.database(url: "https://projekios-6af0f-default-rtdb.asia-southeast1.firebasedatabase.app/").reference()
                    // load events
                    ref3.child("events").observeSingleEvent(of: .value, with: { snapshot in
                        // Loop through each user
                        var count = 0
                        for child in snapshot.children {
                            if let childSnapshot = child as? DataSnapshot,
                               let userData = childSnapshot.value as? [String: Any] {
                                
                                let timeInterval = userData["time"] ?? ""
                                
                                let date = Date(timeIntervalSince1970: timeInterval as! TimeInterval)
                                
                                // Create a date formatter for the date
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yy/MM/dd" // Customize the date format as needed
                                let dateString = dateFormatter.string(from: date)

                                // Create a date formatter for the time
                                let timeFormatter = DateFormatter()
                                timeFormatter.dateFormat = "HH:mm:ss" // Customize the time format as needed
                                let timeString = timeFormatter.string(from: date)
                                
                                // Print the data
                                let nama = userData["name"] ?? ""
                                let datee = dateString + ";" + timeString
                                let cont = userData["description"] ?? ""
                                self.namaa.append(nama as! String)
                                self.datee.append(datee)
                                self.contentt.append(cont as! String)
                                self.tipe.append("events")
                            }
                            count=count+1
                        }
                        print(self.namaa)
                        self.tableview.reloadData()
                        
                    }) { error in
                        print("Error retrieving data: \(error.localizedDescription)")
                    }
                    
                    self.tableview.reloadData()
                }) { error in
                    print("Error retrieving data: \(error.localizedDescription)")
                }
                
                self.tableview.reloadData()
            }) { (Error) in
                print("Failed to fetch: ", Error)
            }
            
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return namaa.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell")! as! searchCell
        cell.labelCell.text = self.namaa[indexPath.row]
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd/MM/yyyy"
////        let date = dateFormatter.date(from: self.datee[indexPath.row])
//        let date = dateFormatter.string(from: Date()
        
        if(self.tipe[indexPath.row] == "notes"){
            cell.labelDesc.text = self.datee[indexPath.row]
        }else{
            let inputString = self.datee[indexPath.row]
            let separatedArray = inputString.components(separatedBy: ";")
            cell.labelDesc.text = separatedArray[0]
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("------- didSelectRowAt -------")
        self.rowSelected = indexPath.row
        performSegue(withIdentifier: "seeDetails", sender: self)
        print("------- didSelectRowAt -------")
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare")
        print(self.rowSelected)
        if(self.rowSelected != -1){
            print(namaa[self.rowSelected])
            let vc = segue.destination as? SeeDetailsFromSearch
            vc?.typee = tipe[self.rowSelected]
            vc?.titlee = namaa[self.rowSelected]
            vc?.datee = datee[self.rowSelected]
            vc?.contentt = contentt[self.rowSelected]
            vc?.delegasi = self
        }
        print("prepare")
    }
    
//    func isSearchMode(_ searchController: UISearchController) -> Bool{
//        let isActive = searchController.isActive
//        let searchText = searchController.searchBar.text ?? ""
//
//        return isActive && !searchText.isEmpty
//    }
//    func updateSearchController(searchBarText: String?) {
//        <#code#>
//    }
//
//    let searchController = UISearchController(searchResultsController: nil)
    var ref: DatabaseReference!
    var namaatemp: [String] = []
    var rowSelected = -1
    var uids: [String] = []
    
    var tipe: [String] = []
    var namaa: [String] = []
    var datee: [String] = []
    var contentt: [String] = []
    var labels: [String] = []
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var searchBar: UITextField!
    
    @IBAction func searchHandler(_ sender: UITextField) {
        print()
        print("cari di database buat search")
//        var uidstemp: [String] = []
        var namatemp: [String] = []
        var datetemp: [String] = []
        var contenttemp: [String] = []
//        var _labelstemp: [String] = []
        var tipetemp: [String] = []
        if let searchText = sender.text{
            print(searchText)
//            if(searchText == ""){
//                self.viewDidLoad()
//            }
            if(true){
                ref = Database.database(url: "https://projekios-6af0f-default-rtdb.asia-southeast1.firebasedatabase.app/").reference()
                
                // load notes
                ref.child("notes").observeSingleEvent(of: .value, with: { snapshot in
                    self.namaa = []
                    self.datee = []
                    self.contentt = []
                    self.tipe = []
                    // Loop through each user
                    var count = 0
                    for child in snapshot.children {
                        if let childSnapshot = child as? DataSnapshot,
                           let userData = childSnapshot.value as? [String: Any] {
                            // Print the data
                            let nama = userData["nama"] ?? ""
                            let date = userData["date"] ?? ""
                            let cont = userData["content"] ?? ""
                            self.namaa.append(nama as! String)
                            self.datee.append(date as! String)
                            self.contentt.append(cont as! String)
                            self.tipe.append("notes")
                        }
                        count=count+1
                    }
                    print(self.namaa)
                    
                    // load events
                    var ref11: DatabaseReference!
                    ref11 = Database.database(url: "https://projekios-6af0f-default-rtdb.asia-southeast1.firebasedatabase.app/").reference()
                    ref11.child("events").observeSingleEvent(of: .value, with: { snapshot in
                        // Loop through each user
                        var count = 0
                        for child in snapshot.children {
                            if let childSnapshot = child as? DataSnapshot,
                               let userData = childSnapshot.value as? [String: Any] {
                                
                                let timeInterval = userData["time"] ?? ""
                                
                                let date = Date(timeIntervalSince1970: timeInterval as! TimeInterval)
                                
                                // Create a date formatter for the date
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yy/MM/dd" // Customize the date format as needed
                                let dateString = dateFormatter.string(from: date)

                                // Create a date formatter for the time
                                let timeFormatter = DateFormatter()
                                timeFormatter.dateFormat = "HH:mm:ss" // Customize the time format as needed
                                let timeString = timeFormatter.string(from: date)
            //                    let dateFormatter = DateFormatter()
            //                    dateFormatter.dateFormat = "yyyy-MM-dd HH :mm:ss"
            //                    let dateString = dateFormatter.string(from: date)
            //                    print(dateString) // Output : "2023-12-11 06:07:20"
            //
            //
            //                    let datee = userData["date"] ?? ""
                                
                                
            //                    let inputString = "apple;orange;banana;grape"
            //                    let separatedArray = inputString.components(separatedBy: ";")
            //
            //                    for item in separatedArray {
            //                        print(item)
            //                    }
                                
                                
                                // Print the data
                                let nama = userData["name"] ?? ""
                                let datee = dateString + ";" + timeString
                                let cont = userData["description"] ?? ""
                                self.namaa.append(nama as! String)
                                self.datee.append(datee)
                                self.contentt.append(cont as! String)
                                self.tipe.append("events")
                            }
                            count=count+1
                        }
                        print(self.namaa)
                        
                        self.tableview.reloadData()
                        
                        
                        // FILTERING SEARCH TEXT
                        var ref10: DatabaseReference!
                        ref10 = Database.database(url: "https://projekios-6af0f-default-rtdb.asia-southeast1.firebasedatabase.app/").reference()
                        ref10.child("notes").observeSingleEvent(of: .value, with: { snapshot in
                            // Loop through each user
                            var count = 0
        //                self.namaa = []
        //                self.datee = []
        //                self.contentt = []
        //                self.tipe = []
                            for child in snapshot.children {
                                if let childSnapshot = child as? DataSnapshot,
                                   let userData = childSnapshot.value as? [String: Any] {
                                    // Print the data
                                    let nama = userData["nama"] ?? ""
                                    let date = userData["date"] ?? ""
                                    let cont = userData["content"] ?? ""
                                    namatemp.append(nama as! String)
                                    datetemp.append(date as! String)
                                    contenttemp.append(cont as! String)
                                    tipetemp.append("notes")
                                }
                                count=count+1
                            }
                            
                            if(searchText != ""){
                                //                    namatemp = self.namaa
                                print("copy an")
                                print(namatemp)
                                namatemp = namatemp.filter{$0.lowercased().contains(searchText.lowercased())}
                                print("filter an")
                                print(namatemp)
                                //                    self.datee = self.datee.filter{$0.lowercased().contains(searchText.lowercased())}
                                //                    self.contentt = self.contentt.filter{$0.lowercased().contains(searchText.lowercased())}
                            }
                            //                print(self.datee)
                            //                self.tableview.reloadData()
                            
                            // load events
                            var ref2: DatabaseReference!
                            ref2 = Database.database(url: "https://projekios-6af0f-default-rtdb.asia-southeast1.firebasedatabase.app/").reference()
                            ref2.child("events").observeSingleEvent(of: .value, with: { snapshot in
                                // Loop through each user
                                var count = 0
                                for child in snapshot.children {
                                    if let childSnapshot = child as? DataSnapshot,
                                       let userData = childSnapshot.value as? [String: Any] {
                                        
                                        let timeInterval = userData["time"] ?? ""
                                        
                                        let date = Date(timeIntervalSince1970: timeInterval as! TimeInterval)
                                        
                                        // Create a date formatter for the date
                                        let dateFormatter = DateFormatter()
                                        dateFormatter.dateFormat = "yy/MM/dd" // Customize the date format as needed
                                        let dateString = dateFormatter.string(from: date)
                                        
                                        // Create a date formatter for the time
                                        let timeFormatter = DateFormatter()
                                        timeFormatter.dateFormat = "HH:mm:ss" // Customize the time format as needed
                                        let timeString = timeFormatter.string(from: date)
                                        
                                        // Print the data
                                        let nama = userData["name"] ?? ""
                                        let datee = dateString + ";" + timeString
                                        let cont = userData["description"] ?? ""
                                        namatemp.append(nama as! String)
                                        datetemp.append(datee)
                                        contenttemp.append(cont as! String)
                                        tipetemp.append("events")
                                    }
                                    count=count+1
                                }
                                
                                if(searchText != ""){
                                    //                    namatemp = self.namaa
                                    print("copy an")
                                    print(namatemp)
                                    namatemp = namatemp.filter{$0.lowercased().contains(searchText.lowercased())}
                                    print("filter an")
                                    print(namatemp)
                                    //                    self.datee = self.datee.filter{$0.lowercased().contains(searchText.lowercased())}
                                    //                    self.contentt = self.contentt.filter{$0.lowercased().contains(searchText.lowercased())}
                                }
                                //                print(self.datee)
                                //                self.tableview.reloadData()
                                
                                print("nama temp notes")
                                print(namatemp)
                                
                                
                                print("array lama")
                                print(self.namaa)
                                var filteredname:[String] = []
                                var filtereddate:[String] = []
                                var filteredcontent:[String] = []
                                var filteredtipe:[String] = []
                                print(namatemp)
                                // cek filtered sm ori
                                for i in 0..<self.namaa.count {
                                    for j in 0..<namatemp.count{
                                        if(namatemp[j] == self.namaa[i]){
                                            filteredname.append(self.namaa[i])
                                            filtereddate.append(self.datee[i])
                                            filteredcontent.append(self.contentt[i])
                                            filteredtipe.append(self.tipe[i])
                                        }
                                    }
                                }
                                
                                self.namaa = filteredname
                                self.datee = filtereddate
                                self.contentt = filteredcontent
                                self.tipe = filteredtipe
                                print("array baru")
                                print(self.namaa)
                                self.tableview.reloadData()
                                
                            }) { error in
                                print("Error retrieving data: \(error.localizedDescription)")
                            }
                            
                            
                            
                            
                        }) { error in
                            print("Error retrieving data: \(error.localizedDescription)")
                        }
                        
                        self.tableview.reloadData()
                        
                        
                        
                        // END FILTERING SEARCH TEXT
                        
                    }) { error in
                        print("Error retrieving data: \(error.localizedDescription)")
                    }
                    
                    
                    self.tableview.reloadData()
                    
                }) { error in
                    print("Error retrieving data: \(error.localizedDescription)")
                }
                
                
                
                
                self.tableview.reloadData()
                
                
                
                
                
                
                
                
                
                
            }
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        
        ref = Database.database(url: "https://projekios-6af0f-default-rtdb.asia-southeast1.firebasedatabase.app/").reference()
        
        // load notes
        ref.child("notes").observeSingleEvent(of: .value, with: { snapshot in
            self.namaa = []
            self.datee = []
            self.contentt = []
            self.tipe = []
            // Loop through each user
            var count = 0
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let userData = childSnapshot.value as? [String: Any] {
                    // Print the data
                    let nama = userData["nama"] ?? ""
                    let date = userData["date"] ?? ""
                    let cont = userData["content"] ?? ""
                    self.namaa.append(nama as! String)
                    self.datee.append(date as! String)
                    self.contentt.append(cont as! String)
                    self.tipe.append("notes")
                }
                count=count+1
            }
            print(self.namaa)
            
            self.tableview.reloadData()
            
        }) { error in
            print("Error retrieving data: \(error.localizedDescription)")
        }
        
        
        // load events
        ref.child("events").observeSingleEvent(of: .value, with: { snapshot in
            // Loop through each user
            var count = 0
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let userData = childSnapshot.value as? [String: Any] {
                    
                    let timeInterval = userData["time"] ?? ""
                    
                    let date = Date(timeIntervalSince1970: timeInterval as! TimeInterval)
                    
                    // Create a date formatter for the date
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yy/MM/dd" // Customize the date format as needed
                    let dateString = dateFormatter.string(from: date)

                    // Create a date formatter for the time
                    let timeFormatter = DateFormatter()
                    timeFormatter.dateFormat = "HH:mm:ss" // Customize the time format as needed
                    let timeString = timeFormatter.string(from: date)
//                    let dateFormatter = DateFormatter()
//                    dateFormatter.dateFormat = "yyyy-MM-dd HH :mm:ss"
//                    let dateString = dateFormatter.string(from: date)
//                    print(dateString) // Output : "2023-12-11 06:07:20"
//
//
//                    let datee = userData["date"] ?? ""
                    
                    
//                    let inputString = "apple;orange;banana;grape"
//                    let separatedArray = inputString.components(separatedBy: ";")
//
//                    for item in separatedArray {
//                        print(item)
//                    }
                    
                    
                    // Print the data
                    let nama = userData["name"] ?? ""
                    let datee = dateString + ";" + timeString
                    let cont = userData["description"] ?? ""
                    self.namaa.append(nama as! String)
                    self.datee.append(datee)
                    self.contentt.append(cont as! String)
                    self.tipe.append("events")
                }
                count=count+1
            }
            print(self.namaa)
            
            self.tableview.reloadData()
            
        }) { error in
            print("Error retrieving data: \(error.localizedDescription)")
        }
        
        
        self.tableview.reloadData()
        
        
        
        
        // load event
//        ref.child("events").observeSingleEvent(of: .value, with: { snapshot in
//            // Loop through each user
//            var count = 0
//            for child in snapshot.children {
//                if let childSnapshot = child as? DataSnapshot,
//                   let userData = childSnapshot.value as? [String: Any] {
//                    // Print the data
//                    let nama = userData["name"] ?? ""
//                    let date = userData["date"] ?? ""
//                    self.namaa.append(nama as! String)
//                    self.datee.append(date as! String)
//                    self.contentt.append("")
//                    self.tipe.append("event")
//                }
//                count=count+1
//            }
//            print(self.namaa)
//
//            self.tableview.reloadData()
//
//        }) { error in
//            print("Error retrieving data: \(error.localizedDescription)")
//        }
        
    }
    
//    func setupSearchController(){
//        self.searchController.searchResultsUpdater = self
//        self.searchController.obscuresBackgroundDuringPresentation = false
//        self.searchController.hidesNavigationBarDuringPresentation = false
//        self.searchController.searchBar.placeholder = "Search"
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
//extension SearchViewController: UISearchResultsUpdating {
//  func updateSearchResults(for searchController: UISearchController) {
//    // TODO
//  }
//}
