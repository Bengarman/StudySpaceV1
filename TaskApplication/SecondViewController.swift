
import UIKit
import CoreData
import ColorSlider

class thingyTableViewCell: UITableViewCell {
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var colourTag: UILabel!
}

class SecondViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {

    @IBOutlet weak var notificationsSwitch: UISwitch!
    @IBOutlet weak var backPressed: UIBarButtonItem!

    
    @IBAction func sendBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBOutlet var txtTask: UITextField!
    @IBOutlet var txtDesc: UITextField!
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    var imagedata = UIImage()
    var imagestuff = Data()
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var date = "12/07/2017"
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if txtDescription.textColor == UIColor.lightGray {
            txtDescription.text = nil
            txtDescription.textColor = UIColor.black
        }
    }
    
    
    var x = 0
    
    
    func notifyMe (day : Date){
        let calendar = NSCalendar.current
        var seperatecomponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: day)
        seperatecomponents.day = seperatecomponents.day! - 1
        let newDate = calendar.date(from: seperatecomponents)
        let notification = UILocalNotification()
        notification.alertBody = "You have homework tommorow. Check Study Space for more details."
        notification.alertTitle = "Homework"
        
        notification.fireDate = newDate
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.category = "Homework"
        print(notification)
        UIApplication.shared.scheduleLocalNotification(notification)
        
        
    }
    var p = 1
    func stateChanged(_ switchState: UISwitch) {
        if switchState.isOn {
            self.p = 1
            
        }else{
            self.p = 0
        }
    }
    
    func changedColor(_ slider: ColorSlider) {
        colourScreen.isHidden = false
        let color = slider.color
        
        colourScreen.backgroundColor = UIColor.init(red: color.cgColor.components![0], green: color.cgColor.components![1], blue: color.cgColor.components![2], alpha: color.cgColor.components![3])
        
        let color2 = slider.color.toHex
        task.colour = color2!
        
        
        
    }
    
    @IBOutlet weak var colourScreen: UILabel!
    
    
    
    override func viewDidLoad() {
        
        
        
        colourScreen.isHidden = true
        colourScreen.layer.masksToBounds = true
        colourScreen.layer.cornerRadius = 7
        
        let colrSlider = ColorSlider(orientation: .horizontal, previewSide: .bottom)
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.size.height
        
        if screenHeight == 568 && screenWidth == 320  {
            //iPhone SE
            colrSlider.frame = CGRect(origin: CGPoint(x: 10,y :386), size: CGSize(width: 300, height: 15))
        } else if screenHeight == 667 && screenWidth == 375 {
            //iPhone 6
            colrSlider.frame = CGRect(origin: CGPoint(x: 16,y :479), size: CGSize(width: 343, height: 15))
        } else if screenHeight == 736 && screenWidth == 414 {
            //iPhone 6 Plus
            colrSlider.frame = CGRect(origin: CGPoint(x: 20,y :534), size: CGSize(width: 374, height: 15))
        } else if screenHeight == 812 && screenWidth == 375 {
            colrSlider.frame = CGRect(origin: CGPoint(x: 37,y :567), size: CGSize(width: 300, height: 15))
        }else{
            colrSlider.frame = CGRect(origin: CGPoint(x: 19,y :280), size: CGSize(width: 284, height: 15))
        }
        
        
        
        view.addSubview(colrSlider)
        colrSlider.addTarget(self, action: #selector(changedColor(_:)), for: .valueChanged)
        

        
        if back.name != "" || back.subject != "" || back.description != ""{
            
            
            backPressed.isEnabled = false
            backPressed.tintColor = UIColor.white
            txtTask.text = back.name
            txtDesc.text = back.subject
            txtDescription.text = back.description
            task.colour = back.colour
            imagestuff = back.image
            
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy hh:mm"
            let date2 = dateFormatter.date(from: back.date)
            datePicker.date = date2!
            date = back.date
            x = 1
            
        }
        
        
        
        notificationsSwitch.addTarget(self, action: #selector(SecondViewController.stateChanged(_:)), for: UIControlEvents.valueChanged)
        
        super.viewDidLoad()

        if x == 0{
            txtDescription.text = "Description"
            txtDescription.textColor = UIColor.lightGray
            x = x+1
        }

        txtDescription.delegate = self

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        

        view.addGestureRecognizer(tap)
        datePicker.addTarget(self, action: #selector(datePickerChanged(_:)), for: .valueChanged)

        // Do any additional setup after loading the view, typically from a nib.
    }
    var imagePicker: UIImagePickerController!

    @IBAction func saveWithPhoto(_ sender: Any) {
        
        
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        
        present(imagePicker, animated: true, completion: nil)
        
    
        
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [AnyHashable: Any]) {
        print("are you here yet")
        imagePicker.dismiss(animated: true, completion: nil)
        imagestuff = UIImageJPEGRepresentation(info[UIImagePickerControllerOriginalImage] as! UIImage, 1)!
        print((info[UIImagePickerControllerOriginalImage] as! UIImage, 1))
        print(imagestuff)
    }

    func datePickerChanged(_ datePicker:UIDatePicker) {
        
      
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm"

        
        let strDate = dateFormatter.string(from: datePicker.date)
        date = strDate
        print(date)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Button Clicked
    @IBAction func btnAddTask(_ sender : UIButton){
        

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Task",
                                                in: managedContext)!
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        person.setValue(txtTask.text, forKeyPath: "name")
        person.setValue(txtDesc.text, forKeyPath: "subject")
        person.setValue(txtDescription.text, forKey: "desc")
        person.setValue(date, forKey: "date")
        print(imagestuff)
        person.setValue(imagestuff, forKey: "image")
        print(task.colour)
        person.setValue(task.colour, forKey: "colour")
        

        
        do {
            try managedContext.save()
            if p == 1{
                notifyMe(day: datePicker.date)
            }
            self.view.endEditing(true)
            txtTask.text = nil
            txtDesc.text = nil
            self.dismiss(animated: true, completion: nil)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
        


}

