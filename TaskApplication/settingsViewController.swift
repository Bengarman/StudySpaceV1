//
//  settingsViewController.swift
//  TaskApplication
//
//  Created by Ben Garman on 15/10/2017.
//  Copyright © 2017 Michael Crump. All rights reserved.
//

import UIKit
import UserNotifications
import CoreData

struct timeDetai {
    static var period = 5
}

class settingsViewController: UIViewController {
    var people: [NSManagedObject] = []

    
    func getWeekDaysInEnglish() -> [String] {
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        calendar.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        return calendar.weekdaySymbols
    }
    
    enum SearchDirection {
        case Next
        case Previous
        
        var calendarOptions: NSCalendar.Options {
            switch self {
            case .Next:
                return .matchNextTime
            case .Previous:
                return [.searchBackwards, .matchNextTime]
            }
        }
    }
    
    func get(direction: SearchDirection, _ dayName: String, considerToday consider: Bool = false) -> NSDate {
        let weekdaysName = getWeekDaysInEnglish()
        
        assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")
        
        let nextWeekDayIndex = weekdaysName.index(of: dayName)! + 1 // weekday is in form 1 ... 7 where as index is 0 ... 6
        
        let today = NSDate()
        
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        
        if consider && calendar.component(.weekday, from: today as Date) == nextWeekDayIndex {
            return today
        }
        
        let nextDateComponent = NSDateComponents()
        nextDateComponent.weekday = nextWeekDayIndex
        
        
        let date = calendar.nextDate(after: today as Date, matching: nextDateComponent as DateComponents, options: direction.calendarOptions)
        return date! as NSDate
    }
    
    var dateformatter5 = DateFormatter()
    
    func notifyMe (lessonName : String, startTime : Date, endTime : Date, room :String, dayofweek:String){
        
        
        let calendar = NSCalendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: get(direction: .Previous, dayofweek, considerToday: true) as Date)
        var seperatecomponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from:startTime)
        // Change the time to 9:30:00 in your locale
        components.hour = seperatecomponents.hour
        components.minute = seperatecomponents.minute
        components.minute = components.minute! - timeDetai.period
        components.second = 0
        let newDate = calendar.date(from: components)
        var datematter = DateFormatter()
        datematter.dateFormat = "HH:mm"
        let notification = UILocalNotification()
        notification.alertBody = "Room: " + room + "\nStart Time: " + datematter.string(from: startTime) + "\nEnd Time: " + datematter.string(from: endTime)
        notification.alertTitle = lessonName
        notification.repeatInterval = NSCalendar.Unit.weekOfYear
        notification.fireDate = newDate
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.category = "Events"
        print(notification)
        UIApplication.shared.scheduleLocalNotification(notification)
        
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    @IBOutlet weak var timeReadOut: UILabel!
    @IBOutlet weak var lowerLimit: UILabel!
    @IBOutlet weak var upperLimmit: UILabel!
    @IBOutlet weak var timeBeforeLesson: UILabel!
    @IBOutlet weak var sliderThing: UISlider!
    @IBAction func sliderChanged(_ sender: UISlider) {
        var currentValue = Int(sender.value)
        timeReadOut.text = "\(currentValue)" + " Mins"
        timeDetai.period = currentValue
        
        UIApplication.shared.cancelAllLocalNotifications()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "TimeTable")
        let sectionSortDescriptor = NSSortDescriptor(key: "timeStart", ascending: false)
        let sortDescriptors = [sectionSortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            people = try managedContext.fetch(fetchRequest)
            var count = people.count - 1
            while count >= 0 {
                let game = people[count]
                var name = (game.value(forKeyPath: "lessonName") as? String)!
                var startTime = (game.value(forKeyPath: "timeStart") as? Date)!
                var endTime = (game.value(forKeyPath: "timeEnds") as? Date)!
                var room = (game.value(forKeyPath: "roomNumber") as? String)!
                var day = (game.value(forKeyPath: "dayOfWeek") as? String)!
                notifyMe(lessonName: name, startTime: startTime, endTime: endTime, room: room, dayofweek: day)
                count = count - 1
            }
        }catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        
        center.getPendingNotificationRequests { (notifications) in
            print("Count: \(notifications.count)")
            for item in notifications {
                print(item.content)
            }
        }
        
    }
    
    func stateChanged(_ switchState: UISwitch) {
        if switchState.isOn {
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedContext = appDelegate.persistentContainer.viewContext
            
            sliderThing.isEnabled = true
            timeReadOut.isEnabled = true
            timeBeforeLesson.isEnabled = true
            upperLimmit.isEnabled = true
            lowerLimit.isEnabled = true
            
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "TimeTable")
            let sectionSortDescriptor = NSSortDescriptor(key: "timeStart", ascending: false)
            let sortDescriptors = [sectionSortDescriptor]
            fetchRequest.sortDescriptors = sortDescriptors
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                people = try managedContext.fetch(fetchRequest)
                var count = people.count - 1
                while count >= 0 {
                    let game = people[count]
                    var name = (game.value(forKeyPath: "lessonName") as? String)!
                    var startTime = (game.value(forKeyPath: "timeStart") as? Date)!
                    var endTime = (game.value(forKeyPath: "timeEnds") as? Date)!
                    var room = (game.value(forKeyPath: "roomNumber") as? String)!
                    var day = (game.value(forKeyPath: "dayOfWeek") as? String)!
                    notifyMe(lessonName: name, startTime: startTime, endTime: endTime, room: room, dayofweek: day)
                    count = count - 1
                }
            }catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            
            
            center.getPendingNotificationRequests { (notifications) in
                print("Count: \(notifications.count)")
                for item in notifications {
                    print(item.content)
                }
            }
            
            
            
            print("on")
        } else {
            
            UIApplication.shared.cancelAllLocalNotifications()
            sliderThing.isEnabled = false
            timeReadOut.isEnabled = false
            timeBeforeLesson.isEnabled = false
            upperLimmit.isEnabled = false
            lowerLimit.isEnabled = false
            
            center.getPendingNotificationRequests { (notifications) in
                print("Count: \(notifications.count)")
                for item in notifications {
                    print(item.content)
                }
            }
            
            print("off")
        }
    }
    
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
    let center = UNUserNotificationCenter.current()
    var x = 0
    @IBOutlet weak var notificationsIcon: UISwitch!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        center.getPendingNotificationRequests { (notifications) in
            print("Count: \(notifications.count)")
            for item in notifications {
                self.x = 1
            }
            
            
            if self.x == 1{
                self.notificationsIcon.setOn(true, animated: true)
            }else{
                self.notificationsIcon.setOn(false, animated: true)
            }
            
        }
        
        notificationsIcon.addTarget(self, action: #selector(settingsViewController.stateChanged(_:)), for: UIControlEvents.valueChanged)
        // Do any additional setup after loading the view.
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
