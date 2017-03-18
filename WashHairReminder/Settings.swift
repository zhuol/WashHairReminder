//
//  Channel.swift
//  SlideOutMenu
//
//  Created by Allen on 16/1/31.
//  Copyright © 2016年 Allen. All rights reserved.
//

import Foundation

class Settings : UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let defaultStartingDate = "2016-10-31"
    
    @IBOutlet weak var frequencyPicker: UIPickerView!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    
    var pickerDataSource = ["1", "2", "3", "4", "5", "6", "7"];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.frequencyPicker.dataSource = self
        self.frequencyPicker.delegate = self
        startDatePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
        // TODO: Handle empty value for the first time
        let currentFrequency = UserDefaults.standard.integer(forKey: "frequency")
        frequencyPicker.selectRow(currentFrequency-1, inComponent: 0, animated: true)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        // TODO: Handle empty value for the first time
        let currentStartDate = UserDefaults.standard.string(forKey: "startDate") ?? defaultStartingDate
        let date = dateFormatter.date(from: currentStartDate)
        startDatePicker.date = date!
        
        UIApplication.shared.isStatusBarHidden = true
        self.navigationController?.isNavigationBarHidden = true
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataSource[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //print(pickerDataSource[row])
        UserDefaults.standard.set(pickerDataSource[row], forKey: "frequency")
    }
    
    func dateChanged(_ sender: UIDatePicker) {
        let componenets = Calendar.current.dateComponents([.year, .month, .day], from: sender.date)
        if let day = componenets.day, let month = componenets.month, let year = componenets.year {
            let currentDate = "\(year)-\(month)-\(day)"
            //print(currentDate)
            UserDefaults.standard.set(currentDate, forKey: "startDate")
        }
    }
    
    @IBAction func datePickerDidSelectNewDate(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        print("Selected date: \(selectedDate)")
        let delegate = UIApplication.shared.delegate as? AppDelegate
        delegate?.scheduleNotification(at: selectedDate)
    }
}
