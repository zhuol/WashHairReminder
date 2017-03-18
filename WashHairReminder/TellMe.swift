//
//  FriendRead.swift
//  SlideOutMenu
//
//  Created by Allen on 16/1/31.
//  Copyright © 2016年 Allen. All rights reserved.
//

import Foundation

class TellMe : UIViewController {
    
    let defaultStartingDate = "2016-10-31"
    let defaultFrequency = 1
    
    @IBOutlet weak var TellMeWashHairOrNot: UIButton!
    @IBOutlet weak var currentDate: UILabel!
    @IBOutlet weak var frequency: UILabel!
    @IBOutlet weak var todayValue: UILabel!
    @IBOutlet weak var washAnswer: UILabel!
    @IBOutlet weak var currentFrequencyValue: UILabel!
    
    override func viewDidLoad() {
        UIApplication.shared.isStatusBarHidden = true
        self.navigationController?.isNavigationBarHidden = true
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        // Current date
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date as Date)
        todayValue.text = dateString
        
        // Current Frequency
        // TODO: Handle empty value for the first time
        currentFrequencyValue.text = "Every " + "\(Int(UserDefaults.standard.integer(forKey: "frequency")))" + "day(s)"
        
        // Test push notification
        let calendar = Calendar.current
        let localTime = calendar.date(byAdding: .hour, value: -7, to: date as Date)
        let notificationTime = calendar.date(byAdding: .minute, value: 1, to: localTime! as Date)
        print("Notification date: \(notificationTime)")
        let delegate = UIApplication.shared.delegate as? AppDelegate
        delegate?.scheduleNotification(at: notificationTime!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func daysBetweenDates(startDate: NSDate, endDate: NSDate) -> Int {
        let calendar = NSCalendar.current as NSCalendar
        
        // Replace the hour (time) of both dates with 00:00
        let start = calendar.startOfDay(for: startDate as Date)
        let end = calendar.startOfDay(for: endDate as Date)
        
        let flags = NSCalendar.Unit.day
        let components = calendar.components(flags, from: start, to: end, options: [])
        
        return components.day!
    }
    
    @IBAction func TellMeWashHairOrNot(_ sender: AnyObject) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let currentStartDate = UserDefaults.standard.string(forKey: "startDate") ?? defaultStartingDate
        let startDate = dateFormatter.date(from: currentStartDate)!
        
        let daysDiff = daysBetweenDates(startDate: startDate as NSDate, endDate: Date() as NSDate)
        
        var currentFrequency = UserDefaults.standard.integer(forKey: "frequency")
        if(currentFrequency <= 0){
            currentFrequency = 1
        }
        if(daysDiff % currentFrequency == 0){
            washAnswer.text = "Wash Hair Today"
        }
        else{
            washAnswer.text = "Wash Hair Tomorrow"
        }
    }
}
