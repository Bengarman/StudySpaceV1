
import UIKit
import CoreData
import ColorSlider
import QuartzCore
import  UserNotifications
import UserNotificationsUI //framework to customize the notification

extension AddTimeTableViewController:UNUserNotificationCenterDelegate{
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("Tapped in notification")
    }
    
    //This is key callback to present notification while the app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("Notification being triggered")
        //You can either present alert ,sound or increase badge while the app is in foreground too with ios 10
        //to distinguish between notifications
        if notification.request.identifier == requestIdentifier{
            
            completionHandler( [.alert,.sound,.badge])
            
        }
    }
}



extension UIColor{
    
    
    var toHex: String? {
        // Extract Components
        guard let components = cgColor.components, components.count >= 3 else {
            return nil
        }
        
        // Helpers
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)
        
        if components.count >= 4 {
            a = Float(components[3])
        }
        
        // Create Hex String
        let hex = String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        
        return hex
    }
}


class AddTimeTableViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var dayPicker: UIPickerView!
    
    let requestIdentifier = "SampleRequest"
    
    
    
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
    
    var dateformatter = DateFormatter()
    
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
        //print(notification)
        UIApplication.shared.scheduleLocalNotification(notification)
        
        
    }
    
    let center = UNUserNotificationCenter.current()
    let dateformattter2 = DateFormatter()
    
    

    @IBAction func savePressed(_ sender: Any) {
        
        toSendToTT.lessonName = ""
        toSendToTT.colour = ""
        toSendToTT.roomNumber = ""
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        //print("here")
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "TimeTable",
                                                in: managedContext)!
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        person.setValue(lessonField.text, forKeyPath: "lessonName")
        person.setValue(roomField.text, forKeyPath: "roomNumber")
        person.setValue(startTimeVariable as Date, forKey: "timeStart")
        person.setValue(finishTimeVariable as Date, forKey: "timeEnds")
        person.setValue(day, forKey: "dayOfWeek")
        person.setValue(colour, forKey: "colour")
        person.setValue(highest, forKey: "id")
        person.setValue(dateformattter2.string(from: startTimeVariable) , forKey: "ampm")
        print(person)
        do {
            try managedContext.save()
            self.view.endEditing(true)
            
            center.getPendingNotificationRequests { (notifications) in
                if notifications.count >= 1{
                    
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
                        //print(self.people)
                        var count = self.people.count - 1
                        while count >= 0 {
                            let game = self.people[count]
                            let name = (game.value(forKeyPath: "lessonName") as? String)!
                            let startTime = (game.value(forKeyPath: "timeStart") as? Date)!
                            let endTime = (game.value(forKeyPath: "timeEnds") as? Date)!
                            let room = (game.value(forKeyPath: "roomNumber") as? String)!
                            let day = (game.value(forKeyPath: "dayOfWeek") as? String)!
                            self.notifyMe(lessonName: name, startTime: startTime, endTime: endTime, room: room, dayofweek: day)
                            count = count - 1
                        }
                        
                        
                        self.center.getPendingNotificationRequests { (notifications) in
                            //print("Count: \(notifications.count)")
                            
                        }
                    }catch let error as NSError {
                        print("Could not save. \(error), \(error.userInfo)")
                    }
                    self.dismiss(animated: true, completion: nil)
                    
                    
                }else{
                    self.dismiss(animated: true, completion: nil)
                    
                }
                
            }
            
            
            
            
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }

        
    }
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    var day = "Monday"
    var components = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
    let dateFormatter = DateFormatter()
    var startTimeVariable = Date()
    var finishTimeVariable = Date()
    var colour = "00FDFFFF"
    @IBOutlet weak var timesLabel: UILabel!
    @IBOutlet weak var roomField: UITextField!
    @IBOutlet weak var lessonField: UITextField!
    @IBOutlet weak var startTime: UIDatePicker!
    @IBOutlet weak var finishTime: UIDatePicker!
    @IBOutlet weak var colourScreen: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    override var prefersStatusBarHidden: Bool {
        return true
    }
   
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    var highest = 0
    var Numbers : [Int] = [0]
    
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    
    func changedColor(_ slider: ColorSlider) {
        let color = slider.color

        colourScreen.backgroundColor = UIColor.init(red: color.cgColor.components![0], green: color.cgColor.components![1], blue: color.cgColor.components![2], alpha: color.cgColor.components![3])
        
        let color2 = slider.color.toHex
        colour = color2!
        
        
    }
    @objc func textFieldDidChange(textField: UITextField){
        
        if let textInput = textField.text {
            //There is a text in your textfield so we get it and put it on the label
            subjectLabel.text = textInput
        } else {
            //textfield is nil so we can't put it on the label
            print("textfield is nil")
        }
    
        
    }
    
    override func viewDidLoad() {
        dateformattter2.dateFormat = "a"
        dayPicker.delegate = self
        dayPicker.dataSource = self
        colourScreen.layer.masksToBounds = true
        colourScreen.layer.cornerRadius = 10
        
        
        lessonField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        
        
        let colrSlider = ColorSlider(orientation: .horizontal, previewSide: .bottom)
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.size.height
        
        if screenHeight == 568 && screenWidth == 320  {
            //iPhone SE
            colrSlider.frame = CGRect(origin: CGPoint(x: 17,y :170), size: CGSize(width: 288, height: 15))
        } else if screenHeight == 667 && screenWidth == 375 {
            //iPhone 6
            colrSlider.frame = CGRect(origin: CGPoint(x: 17,y :181), size: CGSize(width: 340, height: 15))
        } else if screenHeight == 736 && screenWidth == 414 {
            //iPhone 6 Plus
            colrSlider.frame = CGRect(origin: CGPoint(x: 20,y :174), size: CGSize(width: 374, height: 15))
        } else if screenHeight == 812 && screenWidth == 375{
            colrSlider.frame = CGRect(origin: CGPoint(x: 37,y :184), size: CGSize(width: 300, height: 15))
        } else{
            colrSlider.frame = CGRect(origin: CGPoint(x: 20,y :137), size: CGSize(width: 284, height: 15))
        }
        
        
        
        view.addSubview(colrSlider)
        colrSlider.addTarget(self, action: #selector(changedColor(_:)), for: .valueChanged)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "TimeTable")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            var people = try managedContext.fetch(fetchRequest)
            //print(people)
            var count = people.count - 1
            while count >= 0 {
                let game = people[count]
                
                Numbers.append((game.value(forKeyPath: "id") as? Int)!)

                
                
                
                
                
                
                count -= 1
            }
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        highest = Numbers.max()!
        highest = highest + 1
        //print(highest)
        
        if toSendToTT.lessonName != ""{
            if toSendToTT.day != ""{
                cancelButton.isEnabled = false
                cancelButton.tintColor = UIColor.white
                colourScreen.backgroundColor = UIColor.init(hex: toSendToTT.colour)
                subjectLabel.text = toSendToTT.lessonName
                lessonField.text = toSendToTT.lessonName
                roomField.text = toSendToTT.roomNumber
                colour = toSendToTT.colour
                startTime.setDate(toSendToTT.startTime, animated: false)
                finishTime.setDate(toSendToTT.endTime, animated: false)
                
                let stuff = calendar3.dateComponents([.hour, .minute], from: startTime.date)
                if stuff.hour! > 12{
                    startTimeLabel.text = (String(stuff.hour! - 12) + ":" + String(format: "%02d", stuff.minute!) + " pm")
                }else{
                    startTimeLabel.text = (String(stuff.hour!) + ":" + String(format: "%02d", stuff.minute!) + " am")
                }
                
                day = toSendToTT.day
                if toSendToTT.day == "Monday"{
                    dayPicker.selectRow(0, inComponent: 0, animated: true)
                }else if toSendToTT.day == "Tuesday"{
                    dayPicker.selectRow(1, inComponent: 0, animated: true)
                }else if toSendToTT.day == "Wednesday"{
                    dayPicker.selectRow(2, inComponent: 0, animated: true)
                }else if toSendToTT.day == "Thursday"{
                    dayPicker.selectRow(3, inComponent: 0, animated: true)
                }else if toSendToTT.day == "Friday"{
                    dayPicker.selectRow(4, inComponent: 0, animated: true)
                }
                
                
                
            }else{
                lessonField.text = toSendToTT.lessonName
                roomField.text = toSendToTT.roomNumber
                colour = toSendToTT.colour
                colourScreen.backgroundColor = UIColor.init(hex: toSendToTT.colour)
                subjectLabel.text = toSendToTT.lessonName
            }
            
            
            
        }

 
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddTimeTableViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        dateFormatter.dateFormat = "hh:mm a"
        startTimeVariable = startTime.date
        finishTimeVariable = finishTime.date
        finishTime.addTarget(self, action: #selector(datePickertest(_:)), for: .valueChanged)
        startTime.addTarget(self, action: #selector(datePickerChanged(_:)), for: .valueChanged)


        // Do any additional setup after loading the view.
    }
    func roundToTens(x : Double) -> Int {
        return 10 * Int(round(x / 10.0))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        startTimeVariable = startTime.date
        finishTimeVariable = finishTime.date
        
        let stuff = calendar3.dateComponents([.hour, .minute], from: startTime.date)
        if stuff.hour! > 12{
            startTimeLabel.text = (String(stuff.hour! - 12) + ":" + String(format: "%02d", roundToTens(x: Double(stuff.minute!)))  + " pm")
        }else{
            startTimeLabel.text = (String(stuff.hour!) + ":" + String(format: "%02d", roundToTens(x: Double(stuff.minute!))) + " am")
        }

    }
    let calendar3 = NSCalendar.current
    func datePickerChanged(_ datePicker:UIDatePicker) {
        startTimeVariable = startTime.date
        let stuff = calendar3.dateComponents([.hour, .minute], from: startTime.date)
        if stuff.hour! > 12{
            startTimeLabel.text = (String(stuff.hour! - 12) + ":" + String(format: "%02d", stuff.minute!) + " pm")
        }else{
            startTimeLabel.text = (String(stuff.hour!) + ":" + String(format: "%02d", stuff.minute!) + " am")
        }

    }
    func datePickertest(_ datePicker:UIDatePicker) {
        finishTimeVariable = finishTime.date
        //print(finishTimeVariable)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return components.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return components[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        day = components[row]
    }
  



}
