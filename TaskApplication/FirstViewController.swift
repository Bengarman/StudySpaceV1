

import UIKit
import CoreData
import GoogleMobileAds


struct task {
    static var number = Int()
    static var colour = "black"
}
struct back {
    static var name = ""
    static var subject = ""
    static var date = ""
    static var colour = ""
    static var description = ""
    static var image = Data()
    
}
class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate

{
    
    
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    
    @IBOutlet weak var navigationView: UITabBarItem!
    override var prefersStatusBarHidden: Bool {
        return true
    }
    

    
    @IBOutlet var tblTasks : UITableView!
    var people: [NSManagedObject] = []
    
    var names : [String] = []
    var colour : [String] = []
    var desciption : [String] = []
    var date : [String] = []
    var image : [Data] = []
    var rules : [String] = []
    
    
    //For persisting data
    let defaults = UserDefaults.standard
    
    func longPress(_ longPressGestureRecognizer: UILongPressGestureRecognizer) {
        
        if longPressGestureRecognizer.state == UIGestureRecognizerState.began {
            
            let touchPoint = longPressGestureRecognizer.location(in: self.tblTasks)
            if let indexPath = tblTasks.indexPathForRow(at: touchPoint) {
                
                let alert = UIAlertController(title: "Edit", message: "Are you sure you want to edit this homework?", preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    
                    back.colour = self.colour[indexPath.row]
                    back.name = self.names[indexPath.row]
                    back.subject = self.rules[indexPath.row]
                    back.date = self.date[indexPath.row]
                    back.description = self.desciption[indexPath.row]
                    back.image = self.image[indexPath.row]
                    
                    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                    let managedContext = appDelegate.persistentContainer.viewContext
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
                    fetchRequest.predicate = NSPredicate(format: "name = '" + self.names[indexPath.row] + "'")
                    fetchRequest.predicate = NSPredicate(format: "subject = '" + self.rules[indexPath.row] + "'")
                    fetchRequest.predicate = NSPredicate(format: "date = '" + self.date[indexPath.row] + "'")
                    fetchRequest.returnsObjectsAsFaults = false
                    
                    do
                    {
                        let results = try managedContext.fetch(fetchRequest)
                        for managedObject in results
                        {
                            let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                            managedContext.delete(managedObjectData)
                        }
                        self.performSegue(withIdentifier: "sendWithetail", sender: nil)
                        
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
    
    override func viewDidLoad() {
        
        
        
        
        print("Google Mobile Ads SDK version: \(GADRequest.sdkVersion())")
        bannerView.adUnitID = "ca-app-pub-8791367410557048/3416813791"
        bannerView.adSize = kGADAdSizeBanner
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        testatbe()
        
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(FirstViewController.longPress(_:)))
        longPressGesture.minimumPressDuration = 1.0 // 1 second press
        longPressGesture.delegate = self 
        self.tblTasks.addGestureRecognizer(longPressGesture)
        
        super.viewDidLoad()
        self.tblTasks.reloadData()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        testatbe()
        self.tblTasks.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return names.count
        
    }
    
    
    
    func testatbe(){
        names.removeAll()
        rules.removeAll()
        colour.removeAll()
        desciption.removeAll()
        date.removeAll()
        image.removeAll()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Task")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            people = try managedContext.fetch(fetchRequest)
            print(people)
            var count = people.count - 1
            while count >= 0 {
                let game = people[count]
                
                names.append((game.value(forKeyPath: "name") as? String)!)
                rules.append((game.value(forKeyPath: "subject") as? String)!)
                colour.append((game.value(forKeyPath: "colour") as? String)!)
                desciption.append((game.value(forKeyPath: "desc") as? String)!)
                date.append((game.value(forKeyPath: "date") as? String)!)
                image.append((game.value(forKeyPath: "image") as? Data)!)
                count -= 1
            }
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        tblTasks.reloadData()
    }
    
    //Define how our cells look - 2 lines a heading and a subtitle
    func tableView( _ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultTasks", for: indexPath) as! thingyTableViewCell

        
        var newcolour = colour[indexPath.row]
        if newcolour == "blue" {
            cell.backgroundColor = UIColor.blue.lighter()
            
            
        } else if newcolour == "cyan" {
            cell.colourTag.backgroundColor = UIColor.cyan.lighter()
            
            
        } else if newcolour == "brown" {
            cell.colourTag.backgroundColor = UIColor.brown.lighter()
            
            
        } else if newcolour == "black" {
            cell.colourTag.backgroundColor = UIColor.black
            
            
        } else if newcolour == "magenta" {
            cell.colourTag.backgroundColor = UIColor.magenta.lighter()
            
            
        } else if newcolour == "red" {
            cell.colourTag.backgroundColor = UIColor.red.lighter()
            
            
        } else if newcolour == "green" {
            cell.colourTag.backgroundColor = UIColor.green.lighter()
            
            
        } else if newcolour == "orange" {
            cell.colourTag.backgroundColor = UIColor.orange.lighter()
            
            
        } else if newcolour.count == 8 {
            cell.colourTag.backgroundColor = UIColor.init(hex: newcolour)
            
        }else{
            cell.colourTag.backgroundColor = UIColor.white
            
            
            
        }
        
        //Assign the contents of our var "items" to the textLabel of each cell
        cell.topLabel!.text = names[indexPath.row]
        cell.bottomLabel!.text = rules[indexPath.row]
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        task.number = names.count
        print(task.number)
        task.number = task.number - 1
        task.number = task.number - indexPath.row
        tableView.deselectRow(at: indexPath, animated: true)
        print(task.number)
        
        performSegue(withIdentifier: "detail", sender: nil)
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        
        let delete = UITableViewRowAction(style: .destructive, title: "Done") { (action, indexPath) in
            
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Task")
            fetchRequest.predicate = NSPredicate(format: "name = '" + self.names[indexPath.row] + "'")
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
            self.names.remove(at: indexPath.row)
            self.rules.remove(at: indexPath.row)
            self.colour.remove(at: indexPath.row)
            
            self.tblTasks.reloadData()
            
        }
        delete.backgroundColor = UIColor.red
        
        return [delete]
    }
    
 
    
    
        
}



