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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return namaa.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell")! as! searchCell
        cell.labelCell.text = self.namaa[indexPath.row]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
//        let date = dateFormatter.date(from: self.datee[indexPath.row])
        let date = dateFormatter.string(from: Date())
        cell.labelDesc.text = date
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("------- didSelectRowAt -------")
        
        performSegue(withIdentifier: "seeDetails", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(rowSelected != -1){
            let vc = segue.destination as? SeeDetailsFromSearch
            vc?.typee = tipe[rowSelected]
            vc?.titlee = namaa[rowSelected]
            vc?.datee = datee[rowSelected]
            vc?.contentt = contentt[rowSelected]
            vc?.delegasi = self
        }
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
        if let searchText = sender.text{
            ref.child("notes").observeSingleEvent(of: .value, with: { snapshot in
                // Loop through each user
                var count = 0
                self.namaa = []
                self.datee = []
                self.contentt = []
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
                    }
                    count=count+1
                }
                
                if(searchText != ""){
                    self.namaa = self.namaa.filter{$0.lowercased().contains(searchText.lowercased())}
                    self.datee = self.datee.filter{$0.lowercased().contains(searchText.lowercased())}
                    self.contentt = self.contentt.filter{$0.lowercased().contains(searchText.lowercased())}
                }
                print(self.namaa)
                self.tableview.reloadData()
            }) { error in
                print("Error retrieving data: \(error.localizedDescription)")
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        
        ref = Database.database(url: "https://projekios-6af0f-default-rtdb.asia-southeast1.firebasedatabase.app/").reference()
        
        ref.child("notes").observeSingleEvent(of: .value, with: { snapshot in
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
                }
                count=count+1
            }
            print(self.namaa)
            
            self.tableview.reloadData()
            
        }) { error in
            print("Error retrieving data: \(error.localizedDescription)")
        }
        self.tableview.reloadData()
        
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
