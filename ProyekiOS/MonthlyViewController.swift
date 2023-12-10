//
//  MonthlyViewController.swift
//  ProyekiOS
//
//  Created by Kelvin Sidharta Sie on 10/12/23.
//

import UIKit
import Firebase

class MonthlyViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource
{
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var totalSquares = [String]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setCellsView()
        setMonthView()
    }
    
    func setCellsView()
    {
        let width = (collectionView.frame.size.width - 2) / 8
        let height = (collectionView.frame.size.height - 2) / 8
        
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.itemSize = CGSize(width: width, height: height)
    }
    
    func setMonthView()
    {
        totalSquares.removeAll()
        
        let daysInMonth = CalendarHelper().daysInMonth(date: selectedDate)
        let firstDayOfMonth = CalendarHelper().firstOfMonth(date: selectedDate)
        let startingSpaces = CalendarHelper().weekDay(date: firstDayOfMonth)
        
        var count: Int = 1
        
        while(count <= 42)
        {
            if(count <= startingSpaces || count - startingSpaces > daysInMonth)
            {
                totalSquares.append("")
            }
            else
            {
                totalSquares.append(String(count - startingSpaces))
            }
            count += 1
        }
        
        monthLabel.text = CalendarHelper().monthString(date: selectedDate)
            + " " + CalendarHelper().yearString(date: selectedDate)
        collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        totalSquares.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calCell", for: indexPath) as! CalendarCell
        
        cell.dayOfMonth.text = totalSquares[indexPath.item]
        
        return cell
    }
    
    @IBAction func previousMonth(_ sender: Any)
    {
        selectedDate = CalendarHelper().minusMonth(date: selectedDate)
        setMonthView()
    }
    
    @IBAction func nextMonth(_ sender: Any)
    {
        selectedDate = CalendarHelper().plusMonth(date: selectedDate)
        setMonthView()
    }
    
    override open var shouldAutorotate: Bool
    {
        return false
    }
    
    //   @IBOutlet weak var nama: UITextField!
    //   @IBOutlet weak var email: UITextField!
    //
    //   @IBAction func keFirebase(_ sender: UIButton) {
    //       let val = [ "nama": nama.text, "email": email.text ]
    //       ref.child("detail").childByAutoId().setValue(val)
    //   }
    //
    //    @IBAction func deleteData(_ sender: UIButton) {
    //        ref.child("detail").queryOrdered(byChild: "nama").queryEqual(toValue: nama.text).observeSingleEvent(of: .value, with: { (snapshot) in
    //            guard let dictionary = snapshot.value as? [String:Any] else {return}
    //            dictionary.forEach({ (key , _) in
    //                self.ref.child("detail/\(key)").removeValue()
    //            })
    //        }) { (Error) in
    //            print("Failed to fetch: ", Error)
    //        }
    //    }
}

