//
//  TimeTableViewController.swift
//  TaskApplication
//
//  Created by Ben Garman on 11/10/2017.
//  Copyright © 2017 Michael Crump. All rights reserved.
//

import UIKit
import CoreData
import GoogleMobileAds

import UserNotifications
struct toSendToTT {
    static var roomNumber = ""
    static var colour = ""
    static var lessonName = ""
    static var day = ""
    static var startTime = Date()
    static var endTime = Date()
    
}

class TimeTableTableViewCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var nowOrNot: UILabel!
}

extension String {
    
    var length: Int {
        return self.characters.count
    }
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }
    
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}



extension UIColor {
    
    func lighter(by percentage:CGFloat=30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }
    
    func darker(by percentage:CGFloat=30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }
    
    func adjust(by percentage:CGFloat=30.0) -> UIColor? {
        var r:CGFloat=0, g:CGFloat=0, b:CGFloat=0, a:CGFloat=0;
        if(self.getRed(&r, green: &g, blue: &b, alpha: &a)){
            return UIColor(red: min(r + percentage/100, 1.0),
                           green: min(g + percentage/100, 1.0),
                           blue: min(b + percentage/100, 1.0),
                           alpha: a)
        }else{
            return nil
        }
    }
    
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt32 = 0
        
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        
        let length = hexSanitized.characters.count
        
        guard Scanner(string: hexSanitized).scanHexInt32(&rgb) else { return nil }
        
        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
            
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
            
        } else {
            return nil
        }
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
}

class TimeTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate{
    
    @IBAction func rightButtonPressed(_ sender: Any) {
        
        
        
        let fadeTransition = CATransition()
        fadeTransition.duration = 0.2
        
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            
            if self.middleField.text == "Monday"{
                self.daySelected = "Friday"
                self.testatbe()
                self.leftField.text = "Thursday"
                self.middleField.text = "Friday"
                self.rightField.text = "Monday"
            } else if self.middleField.text == "Tuesday"{
                self.daySelected = "Monday"
                self.testatbe()
                self.leftField.text = "Friday"
                self.middleField.text = "Monday"
                self.rightField.text = "Tuesday"
            } else if self.middleField.text == "Wednesday"{
                self.daySelected = "Tuesday"
                self.testatbe()
                self.leftField.text = "Monday"
                self.middleField.text = "Tuesday"
                self.rightField.text = "Wednesday"
            } else if self.middleField.text == "Thursday"{
                self.daySelected = "Wednesday"
                self.testatbe()
                self.leftField.text = "Tuesday"
                self.middleField.text = "Wednesday"
                self.rightField.text = "Thursday"
            } else if self.middleField.text == "Friday"{
                self.daySelected = "Thursday"
                self.testatbe()
                self.leftField.text = "Wednesday"
                self.middleField.text = "Thursday"
                self.rightField.text = "Friday"
            }
            self.leftField.layer.add(fadeTransition, forKey: kCATransition)
            self.middleField.layer.add(fadeTransition, forKey: kCATransition)
            self.rightField.layer.add(fadeTransition, forKey: kCATransition)
        })
        
        leftField.layer.add(fadeTransition, forKey: kCATransition)
        middleField.layer.add(fadeTransition, forKey: kCATransition)
        rightField.layer.add(fadeTransition, forKey: kCATransition)
        
        CATransaction.commit()
        
    }
    
    @IBOutlet weak var leftButtonPressed: UIButton!
    @IBAction func leftButtonPress(_ sender: Any) {
        let fadeTransition = CATransition()
        fadeTransition.duration = 0.2
        
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            
            if self.middleField.text == "Monday"{
                self.daySelected = "Tuesday"
                self.testatbe()
                self.leftField.text = "Monday"
                self.middleField.text = "Tuesday"
                self.rightField.text = "Wednesday"
            } else if self.middleField.text == "Tuesday"{
                self.daySelected = "Wednesday"
                self.testatbe()
                self.leftField.text = "Tuesday"
                self.middleField.text = "Wednesday"
                self.rightField.text = "Thursday"
            } else if self.middleField.text == "Wednesday"{
                self.daySelected = "Thursday"
                self.testatbe()
                self.leftField.text = "Wednesday"
                self.middleField.text = "Thursday"
                self.rightField.text = "Friday"
            } else if self.middleField.text == "Thursday"{
                self.daySelected = "Friday"
                self.testatbe()
                self.leftField.text = "Thursday"
                self.middleField.text = "Friday"
                self.rightField.text = "Monday"
            } else if self.middleField.text == "Friday"{
                self.daySelected = "Monday"
                self.testatbe()
                self.leftField.text = "Friday"
                self.middleField.text = "Monday"
                self.rightField.text = "Tuesday"
            }
            self.leftField.layer.add(fadeTransition, forKey: kCATransition)
            self.middleField.layer.add(fadeTransition, forKey: kCATransition)
            self.rightField.layer.add(fadeTransition, forKey: kCATransition)
        })
        
        leftField.layer.add(fadeTransition, forKey: kCATransition)
        middleField.layer.add(fadeTransition, forKey: kCATransition)
        rightField.layer.add(fadeTransition, forKey: kCATransition)
        
        CATransaction.commit()
        
    }
    
    //@IBOutlet weak var segmentControl: UISegmentedControl!
    var people: [NSManagedObject] = []  
    var id :[Int] = []
    var lessonName : [String] = []
    var nowornot : [String] = []
    var startTime : [Date] = []
    var endTime : [Date] = []
    var colour : [String] = []
    var day: [String] = []
    var roomNumber : [String] = []
    var daySelected = "Monday"
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func longPress(_ longPressGestureRecognizer: UILongPressGestureRecognizer) {
        
        if longPressGestureRecognizer.state == UIGestureRecognizerState.began {
            
            let touchPoint = longPressGestureRecognizer.location(in: self.tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                
                let alert = UIAlertController(title: "Edit", message: "Are you sure you want to edit this lesson?", preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    let person = self.lessonName[indexPath.row]
                    let room = self.roomNumber[indexPath.row]
                    let colourThing = self.colour[indexPath.row]
                    //print(person)
                    toSendToTT.lessonName = person
                    toSendToTT.roomNumber = room
                    toSendToTT.colour = colourThing
                    toSendToTT.day = self.day[indexPath.row]
                    toSendToTT.startTime = self.startTime[indexPath.row]
                    toSendToTT.endTime = self.endTime[indexPath.row]
                    
                    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                    let managedContext = appDelegate.persistentContainer.viewContext
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TimeTable")
                    fetchRequest.predicate = NSPredicate(format: "id = '" + String(self.id[indexPath.row]) + "'")
                    fetchRequest.returnsObjectsAsFaults = false
                    
                    do
                    {
                        let results = try managedContext.fetch(fetchRequest)
                        for managedObject in results
                        {
                            let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                            managedContext.delete(managedObjectData)
                        }
                        self.performSegue(withIdentifier: "sendWithDetail", sender: nil)

                    } catch let error as NSError {
                        print("Detele all data in  error : \(error) \(error.userInfo)")
                    }
                                    })
                // add an action (button)
                alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel) {
                    UIAlertAction in
                    
                })
                
                
                // show the alert
                self.present(alert, animated: true, completion: nil)

                ///////works but erratic responses//////////
            }
        }
    }
    let date = Date()
    let calendar = Calendar.current
    let center = UNUserNotificationCenter.current()
    var v = 0
    
    
    var dateformatter = DateFormatter()
    
    func notifyMe2 (lessonName : String, startTime : Date, endTime : Date, room :String, dayofweek:String){
        
        
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
        //print(notification)
        UIApplication.shared.scheduleLocalNotification(notification)
        
        
    }
    
    @IBOutlet weak var rightField: UILabel!
    @IBOutlet weak var middleField: UILabel!
    @IBOutlet weak var leftField: UILabel!
    
    @IBOutlet weak var naviBar: UINavigationBar!
    override func viewDidLoad() {
        
        
        
        
        
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter2.dateFormat = "HH:mm"
        dayFormatter.dateFormat = "EEEE"
        
        center.getPendingNotificationRequests { (notifications) in
            //print("Count: \(notifications.count)")
            for item in notifications {
                self.v = 1
            }
            
            if self.v == 1{
                UIApplication.shared.cancelAllLocalNotifications()
                
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                let managedContext = appDelegate.persistentContainer.viewContext
                
                
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "TimeTable")
                let sectionSortDescriptor = NSSortDescriptor(key: "timeStart", ascending: false)
                let sortDescriptors = [sectionSortDescriptor]
                fetchRequest.sortDescriptors = sortDescriptors
                fetchRequest.returnsObjectsAsFaults = false
                
                do {
                    self.people = try managedContext.fetch(fetchRequest)
                    var count = self.people.count - 1
                    while count >= 0 {
                        let game = self.people[count]
                        var name = (game.value(forKeyPath: "lessonName") as? String)!
                        var startTime = (game.value(forKeyPath: "timeStart") as? Date)!
                        var endTime = (game.value(forKeyPath: "timeEnds") as? Date)!
                        var room = (game.value(forKeyPath: "roomNumber") as? String)!
                        var day = (game.value(forKeyPath: "dayOfWeek") as? String)!
                        self.notifyMe2(lessonName: name, startTime: startTime, endTime: endTime, room: room, dayofweek: day)
                        count = count - 1
                    }
                }catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
                
                
                
                
            }else{
                
                
                
            }
            
            
        }
        
        
        
        //print("Google Mobile Ads SDK version: \(GADRequest.sdkVersion())")
        bannerView.adUnitID = "ca-app-pub-8791367410557048/3416813791"
        bannerView.adSize = kGADAdSizeBanner
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        
        let hour = calendar.component(.weekday , from: date)
        if hour == 1{
            self.daySelected = "Monday"
            self.leftField.text = "Friday"
            self.middleField.text = "Monday"
            self.rightField.text = "Tuesday"
        } else if hour == 2{
            self.daySelected = "Monday"
            self.leftField.text = "Friday"
            self.middleField.text = "Monday"
            self.rightField.text = "Tuesday"
        } else if hour == 3{
            self.daySelected = "Tuesday"
            self.leftField.text = "Monday"
            self.middleField.text = "Tuesday"
            self.rightField.text = "Wednesday"
        } else if hour == 4{
            self.daySelected = "Wednesday"
            self.leftField.text = "Tuesday"
            self.middleField.text = "Wednesday"
            self.rightField.text = "Thursday"
        } else if hour == 5{
            self.daySelected = "Thursday"
            self.leftField.text = "Wednesday"
            self.middleField.text = "Thursday"
            self.rightField.text = "Friday"
        } else if hour == 6{
            self.daySelected = "Friday"
            self.leftField.text = "Thursday"
            self.middleField.text = "Friday"
            self.rightField.text = "Monday"
        } else if hour == 7{
            self.daySelected = "Monday"
            self.leftField.text = "Friday"
            self.middleField.text = "Monday"
            self.rightField.text = "Tuesday"
        }
        toSendToTT.lessonName = ""
        toSendToTT.colour = ""
        toSendToTT.roomNumber = ""
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(TimeTableViewController.longPress(_:)))
        longPressGesture.minimumPressDuration = 1.0 // 1 second press
        longPressGesture.delegate = self
        self.tableView.addGestureRecognizer(longPressGesture)
        
        panRec = UIPanGestureRecognizer(target: self, action: #selector(TimeTableViewController.handlePan(recognizer:)))
        self.view.addGestureRecognizer(panRec)
        
        super.viewDidLoad()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter2.dateFormat = "HH:mm"
        dayFormatter.dateFormat = "EEEE"
        
        
        

        // Do any additional setup after loading the view.
    }
    
    private var panRec: UIPanGestureRecognizer!
    private var lastSwipeBeginningPoint: CGPoint?
    
    
    
    
    @objc func handlePan(recognizer: UISwipeGestureRecognizer) {
        if recognizer.state == .began {
            lastSwipeBeginningPoint = recognizer.location(in: recognizer.view)
        } else if recognizer.state == .ended {
            guard let beginPoint = lastSwipeBeginningPoint else {
                return
            }
            let endPoint = recognizer.location(in: recognizer.view)
            // TODO: use the x and y coordinates of endPoint and beginPoint to determine which direction the swipe occurred.
            
            
            if beginPoint.x < endPoint.x && beginPoint.y > endPoint.y && beginPoint.y - endPoint.y < 100  || beginPoint.x < endPoint.x && beginPoint.y < endPoint.y && endPoint.y - beginPoint.y < 100 {
                
                
                
                let fadeTransition = CATransition()
                fadeTransition.duration = 0.2
                
                CATransaction.begin()
                CATransaction.setCompletionBlock({
                    
                    if self.middleField.text == "Monday"{
                        self.daySelected = "Friday"
                        self.testatbe()
                        self.leftField.text = "Thursday"
                        self.middleField.text = "Friday"
                        self.rightField.text = "Monday"
                    } else if self.middleField.text == "Tuesday"{
                        self.daySelected = "Monday"
                        self.testatbe()
                        self.leftField.text = "Friday"
                        self.middleField.text = "Monday"
                        self.rightField.text = "Tuesday"
                    } else if self.middleField.text == "Wednesday"{
                        self.daySelected = "Tuesday"
                        self.testatbe()
                        self.leftField.text = "Monday"
                        self.middleField.text = "Tuesday"
                        self.rightField.text = "Wednesday"
                    } else if self.middleField.text == "Thursday"{
                        self.daySelected = "Wednesday"
                        self.testatbe()
                        self.leftField.text = "Tuesday"
                        self.middleField.text = "Wednesday"
                        self.rightField.text = "Thursday"
                    } else if self.middleField.text == "Friday"{
                        self.daySelected = "Thursday"
                        self.testatbe()
                        self.leftField.text = "Wednesday"
                        self.middleField.text = "Thursday"
                        self.rightField.text = "Friday"
                    }
                    self.leftField.layer.add(fadeTransition, forKey: kCATransition)
                    self.middleField.layer.add(fadeTransition, forKey: kCATransition)
                    self.rightField.layer.add(fadeTransition, forKey: kCATransition)
                })
                
                leftField.layer.add(fadeTransition, forKey: kCATransition)
                middleField.layer.add(fadeTransition, forKey: kCATransition)
                rightField.layer.add(fadeTransition, forKey: kCATransition)
                
                CATransaction.commit()
                
                
                
                
                print("Right")   // Friday To Monday
            }else if beginPoint.x > endPoint.x && beginPoint.y < endPoint.y && endPoint.y - beginPoint.y < 100 || beginPoint.x > endPoint.x && beginPoint.y > endPoint.y && beginPoint.y - endPoint.y < 100 {
                
                
                let fadeTransition = CATransition()
                fadeTransition.duration = 0.2
                
                CATransaction.begin()
                CATransaction.setCompletionBlock({
                    
                    if self.middleField.text == "Monday"{
                        self.daySelected = "Tuesday"
                        self.testatbe()
                        self.leftField.text = "Monday"
                        self.middleField.text = "Tuesday"
                        self.rightField.text = "Wednesday"
                    } else if self.middleField.text == "Tuesday"{
                        self.daySelected = "Wednesday"
                        self.testatbe()
                        self.leftField.text = "Tuesday"
                        self.middleField.text = "Wednesday"
                        self.rightField.text = "Thursday"
                    } else if self.middleField.text == "Wednesday"{
                        self.daySelected = "Thursday"
                        self.testatbe()
                        self.leftField.text = "Wednesday"
                        self.middleField.text = "Thursday"
                        self.rightField.text = "Friday"
                    } else if self.middleField.text == "Thursday"{
                        self.daySelected = "Friday"
                        self.testatbe()
                        self.leftField.text = "Thursday"
                        self.middleField.text = "Friday"
                        self.rightField.text = "Monday"
                    } else if self.middleField.text == "Friday"{
                        self.daySelected = "Monday"
                        self.testatbe()
                        self.leftField.text = "Friday"
                        self.middleField.text = "Monday"
                        self.rightField.text = "Tuesday"
                    }
                    self.leftField.layer.add(fadeTransition, forKey: kCATransition)
                    self.middleField.layer.add(fadeTransition, forKey: kCATransition)
                    self.rightField.layer.add(fadeTransition, forKey: kCATransition)
                })
                
                leftField.layer.add(fadeTransition, forKey: kCATransition)
                middleField.layer.add(fadeTransition, forKey: kCATransition)
                rightField.layer.add(fadeTransition, forKey: kCATransition)
                
                CATransaction.commit()
                
                
                print("Left")      // Friday To Monday
            }
            
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        toSendToTT.lessonName = ""
        toSendToTT.colour = ""
        toSendToTT.roomNumber = ""
        toSendToTT.day = ""
        toSendToTT.endTime = Date()
        toSendToTT.startTime = Date()
        
        testatbe()
    }
    /*
    //Called, when long press occurred
    func longPress(_ longPressGestureRecognizer: UILongPressGestureRecognizer) {
        
        if longPressGestureRecognizer.state == UIGestureRecognizerState.began {
            
            let touchPoint = longPressGestureRecognizer.location(in: self.tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                let person = lessonName[indexPath.row]
                let room = roomNumber[indexPath.row]
                let startDate = dateFormatter.string(from: startTime[indexPath.row])
                let finishDate = dateFormatter.string(from: endTime[indexPath.row])
                let alert = UIAlertController(title: person, message: "Please enter a table number.", preferredStyle: UIAlertControllerStyle.alert)
                
                alert.message = "Room: " + room + "\nStart Time: " + startDate + "\nEnd Time: " + finishDate
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
                
                print(person)
                ///////works but erratic responses//////////
            }
        }
    }
    */
    var toSendName :[String] = []
    var toSendSTime :[Date] = []
    var toSendFTime :[Date] = []
    var toSendColour :[String] = []
    var toSendDay :[String] = []

    
    func testatbe(){
        
        lessonName.removeAll()
        startTime.removeAll()
        endTime.removeAll()
        colour.removeAll()
        day.removeAll()
        roomNumber.removeAll()
        nowornot.removeAll()
        id.removeAll()
        toSendColour.removeAll()
        toSendDay.removeAll()
        toSendSTime.removeAll()
        toSendFTime.removeAll()
        toSendName.removeAll()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "TimeTable")
        let sectionSortDescriptor = NSSortDescriptor(key: "timeStart", ascending: false)
        let sortDescriptors = [sectionSortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            people = try managedContext.fetch(fetchRequest)
            
            print(people)
            var count = people.count - 1
            while count >= 0 {
                let game = people[count]
                toSendName.append((game.value(forKeyPath: "lessonName") as? String)!)
                toSendSTime.append((game.value(forKeyPath: "timeStart") as? Date)!)
                toSendFTime.append((game.value(forKeyPath: "timeEnds") as? Date)!)
                toSendColour.append((game.value(forKeyPath: "colour") as? String)!)
                toSendDay.append((game.value(forKeyPath: "dayOfWeek") as? String)!)
                if((game.value(forKeyPath: "ampm") as? String)!) == "am" || ((game.value(forKeyPath: "ampm") as? String)!) == "AM"{
                    if ((game.value(forKeyPath: "dayOfWeek") as? String)!) == daySelected{
                        lessonName.append((game.value(forKeyPath: "lessonName") as? String)!)
                        startTime.append((game.value(forKeyPath: "timeStart") as? Date)!)
                        endTime.append((game.value(forKeyPath: "timeEnds") as? Date)!)
                        colour.append((game.value(forKeyPath: "colour") as? String)!)
                        day.append((game.value(forKeyPath: "dayOfWeek") as? String)!)
                        roomNumber.append((game.value(forKeyPath: "roomNumber") as? String)!)
                        id.append((game.value(forKeyPath: "id") as? Int)!)
                        var dateformat = DateFormatter()
                        dateformat.dateFormat = "a"
                        var today = Date()
                        if dateFormatter.string(from: ((game.value(forKeyPath: "timeStart") as? Date)!)) < dateFormatter.string(from: today ) && dateFormatter.string(from: ((game.value(forKeyPath: "timeEnds") as? Date)!)) > dateFormatter.string(from: today ) && ((game.value(forKeyPath: "dayOfWeek") as? String)!) == dayFormatter.string(from: today ) && dateformat.string(from: ((game.value(forKeyPath: "timeStart") as? Date)!)) == dateformat.string(from: today ){
                            nowornot.append("now")
                            
                        }else{
                            nowornot.append("not")
                            
                        }
                    }
                }
                
                
                tableView.reloadData()
                
                
                
                
                count -= 1
            }
            
            
            
            
            UserDefaults.init(suiteName: "group.tosendtotoday")?.setValue(toSendName, forKey: "lessonName")
            UserDefaults.init(suiteName: "group.tosendtotoday")?.setValue(toSendSTime, forKey: "startTime")
            UserDefaults.init(suiteName: "group.tosendtotoday")?.setValue(toSendFTime, forKey: "finishTime")
            UserDefaults.init(suiteName: "group.tosendtotoday")?.setValue(toSendDay, forKey: "day")
            UserDefaults.init(suiteName: "group.tosendtotoday")?.setValue(toSendColour, forKey: "colour")
            
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        guard let appDelegate2 = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext2 = appDelegate2.persistentContainer.viewContext
        
        
        let fetchRequest2 = NSFetchRequest<NSManagedObject>(entityName: "TimeTable")
        let sectionSortDescriptor2 = NSSortDescriptor(key: "timeStart", ascending: false)
        let sortDescriptors2 = [sectionSortDescriptor2]
        fetchRequest2.sortDescriptors = sortDescriptors2

        fetchRequest2.returnsObjectsAsFaults = false
        
        do {
            people = try managedContext2.fetch(fetchRequest2)
            //print(people)
            var count = people.count - 1
            while count >= 0 {
                let game = people[count]
                toSendName.append((game.value(forKeyPath: "lessonName") as? String)!)
                toSendSTime.append((game.value(forKeyPath: "timeStart") as? Date)!)
                toSendFTime.append((game.value(forKeyPath: "timeEnds") as? Date)!)
                toSendColour.append((game.value(forKeyPath: "colour") as? String)!)
                toSendDay.append((game.value(forKeyPath: "dayOfWeek") as? String)!)
                if((game.value(forKeyPath: "ampm") as? String)!) == "pm" || ((game.value(forKeyPath: "ampm") as? String)!) == "PM"{
                    if ((game.value(forKeyPath: "dayOfWeek") as? String)!) == daySelected{
                        lessonName.append((game.value(forKeyPath: "lessonName") as? String)!)
                        startTime.append((game.value(forKeyPath: "timeStart") as? Date)!)
                        endTime.append((game.value(forKeyPath: "timeEnds") as? Date)!)
                        colour.append((game.value(forKeyPath: "colour") as? String)!)
                        day.append((game.value(forKeyPath: "dayOfWeek") as? String)!)
                        roomNumber.append((game.value(forKeyPath: "roomNumber") as? String)!)
                        id.append((game.value(forKeyPath: "id") as? Int)!)
                        var dateformat = DateFormatter()
                        dateformat.dateFormat = "a"
                        var today = Date()
                        if dateFormatter.string(from: ((game.value(forKeyPath: "timeStart") as? Date)!)) < dateFormatter.string(from: today ) && dateFormatter.string(from: ((game.value(forKeyPath: "timeEnds") as? Date)!)) > dateFormatter.string(from: today ) && ((game.value(forKeyPath: "dayOfWeek") as? String)!) == dayFormatter.string(from: today ) && dateformat.string(from: ((game.value(forKeyPath: "timeStart") as? Date)!)) == dateformat.string(from: today ){
                            nowornot.append("now")
                            
                        }else{
                            nowornot.append("not")
                            
                        }
                    }
                    
                }
                    
                
                
                tableView.reloadData()
                
                
                
                
                count -= 1
            }
            
            
            
            
            UserDefaults.init(suiteName: "group.tosendtotoday")?.setValue(toSendName, forKey: "lessonName")
            UserDefaults.init(suiteName: "group.tosendtotoday")?.setValue(toSendSTime, forKey: "startTime")
            UserDefaults.init(suiteName: "group.tosendtotoday")?.setValue(toSendFTime, forKey: "finishTime")
            UserDefaults.init(suiteName: "group.tosendtotoday")?.setValue(toSendDay, forKey: "day")
            UserDefaults.init(suiteName: "group.tosendtotoday")?.setValue(toSendColour, forKey: "colour")
            
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }

        
        
        
    }

    let dateFormatter = DateFormatter()
    
    let dateFormatter2 = DateFormatter()
    let dayFormatter = DateFormatter()
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return lessonName.count
        
    }
    
    @IBAction func noNotify(_ sender: Any) {
        
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let person = lessonName[indexPath.row]
        dateformatter.dateFormat = "hh:mm a"
        let room = roomNumber[indexPath.row]
        let startDate = dateformatter.string(from: startTime[indexPath.row])
        let finishDate = dateformatter.string(from: endTime[indexPath.row])
        let alert = UIAlertController(title: person, message: "To Be Changed", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.message = "Room: " + room + "\nStart Time: " + startDate + "\nEnd Time: " + finishDate
        // add an action (button)
        
        
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.default, handler: { (nil) in
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "TimeTable")
            fetchRequest.predicate = NSPredicate(format: "id = '" + String(self.id[indexPath.row]) + "'")
            
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                self.people = try managedContext.fetch(fetchRequest)
                for item in self.people{
                    let managedObjectData:NSManagedObject = item as! NSManagedObject
                    managedContext.delete(managedObjectData)
                }
                
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            
            
            do {
                try managedContext.save()
                self.view.endEditing(true)
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            
            self.lessonName.remove(at: indexPath.row)
            self.startTime.remove(at: indexPath.row)
            self.endTime.remove(at: indexPath.row)
            self.colour.remove(at: indexPath.row)
            self.day.remove(at: indexPath.row)
            self.roomNumber.remove(at: indexPath.row)
            self.nowornot.remove(at: indexPath.row)
            self.toSendColour.remove(at: indexPath.row)
            self.toSendDay.remove(at: indexPath.row)
            self.toSendSTime.remove(at: indexPath.row)
            self.toSendFTime.remove(at: indexPath.row)
            self.toSendName.remove(at: indexPath.row)
            self.tableView.reloadData()
            
            self.center.getPendingNotificationRequests { (notifications) in
                if notifications.count >= 1{
                    
                    UIApplication.shared.cancelAllLocalNotifications()
                    
                    guard let appDelegate2 = UIApplication.shared.delegate as? AppDelegate else { return }
                    let managedContext2 = appDelegate2.persistentContainer.viewContext
                    
                    
                    let fetchRequest2 = NSFetchRequest<NSManagedObject>(entityName: "TimeTable")
                    let sectionSortDescriptor = NSSortDescriptor(key: "timeStart", ascending: false)
                    let sortDescriptors = [sectionSortDescriptor]
                    fetchRequest2.sortDescriptors = sortDescriptors
                    fetchRequest2.returnsObjectsAsFaults = false
                    
                    do {
                        self.people = try managedContext2.fetch(fetchRequest2)
                        var count = self.people.count - 1
                        while count >= 0 {
                            let game = self.people[count]
                            let name = (game.value(forKeyPath: "lessonName") as? String)!
                            let startTime = (game.value(forKeyPath: "timeStart") as? Date)!
                            let endTime = (game.value(forKeyPath: "timeEnds") as? Date)!
                            let room = (game.value(forKeyPath: "roomNumber") as? String)!
                            let day = (game.value(forKeyPath: "dayOfWeek") as? String)!
                            self.notifyMe2(lessonName: name, startTime: startTime, endTime: endTime, room: room, dayofweek: day)
                            count = count - 1
                        }
                    }catch let error as NSError {
                        print("Could not save. \(error), \(error.userInfo)")
                    }
                    
                }
                self.center.getPendingNotificationRequests { (notifications) in
                    print("Count: \(notifications.count)")
                }
                
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Duplicate", style: UIAlertActionStyle.default, handler: { (nil) in
            let person = self.lessonName[indexPath.row]
            let room = self.roomNumber[indexPath.row]
            let colourThing = self.colour[indexPath.row]
            //print(person)
            toSendToTT.lessonName = person
            toSendToTT.roomNumber = room
            toSendToTT.colour = colourThing
            self.performSegue(withIdentifier: "sendWithDetail", sender: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: nil))
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
        //print(person)
    }
    func tableView( _ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Timetable", for: indexPath) as! TimeTableTableViewCell
        
        cell.nowOrNot.isHidden = true
        cell.nowOrNot.textColor = UIColor.black
        cell.nowOrNot.backgroundColor = UIColor.white
        cell.nowOrNot.layer.cornerRadius = 8
        cell.nowOrNot.layer.masksToBounds = true
        let newcolour = colour[indexPath.row]
        if newcolour == "blue" {
            cell.backgroundColor = UIColor.blue.lighter()
            cell.name.textColor = UIColor.black
            cell.startTime.textColor = UIColor.black
            
        } else if newcolour == "cyan" {
            cell.backgroundColor = UIColor.cyan.lighter()
            cell.name.textColor = UIColor.black
            cell.startTime.textColor = UIColor.black
            
        } else if newcolour == "brown" {
            cell.backgroundColor = UIColor.brown.lighter()
            cell.name.textColor = UIColor.black
            cell.startTime.textColor = UIColor.black
            
        } else if newcolour == "black" {
            cell.backgroundColor = UIColor.black
            cell.name.textColor = UIColor.white
            cell.startTime.textColor = UIColor.white
            
        } else if newcolour == "magenta" {
            cell.backgroundColor = UIColor.magenta.lighter()
            cell.name.textColor = UIColor.black
            cell.startTime.textColor = UIColor.black
            
        } else if newcolour == "red" {
            cell.backgroundColor = UIColor.red.lighter()
            cell.name.textColor = UIColor.black
            cell.startTime.textColor = UIColor.black
            
        } else if newcolour == "green" {
            cell.backgroundColor = UIColor.green.lighter()
            cell.name.textColor = UIColor.black
            cell.startTime.textColor = UIColor.black
            
        } else if newcolour == "orange" {
            cell.backgroundColor = UIColor.orange.lighter()
            cell.name.textColor = UIColor.black
            cell.startTime.textColor = UIColor.black
            
        }else if newcolour.count == 8 {
            
            
            cell.backgroundColor = UIColor.init(hex: newcolour)
            cell.name.textColor = UIColor.black
            cell.startTime.textColor = UIColor.black
            
        }else{
            cell.backgroundColor = UIColor.white
            cell.name.textColor = UIColor.black
            cell.startTime.textColor = UIColor.black
            
            
        }
        //print(nowornot[indexPath.row])
        
        if nowornot[indexPath.row] == "now"{
            
            cell.nowOrNot.text = "Now"
            cell.nowOrNot.isHidden = false
            
        }else {
            
            cell.nowOrNot.text = ""
            
        }
        cell.name.text = lessonName[indexPath.row]
        cell.startTime.text = dateFormatter.string(from: startTime[indexPath.row])
        return cell
    }

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
    
        
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
