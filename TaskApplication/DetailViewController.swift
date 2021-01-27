//
//  DetailViewController.swift
//  TaskApplication
//
//  Created by Ben Garman on 03/10/2017.
//  Copyright © 2017 Michael Crump. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController, UITextViewDelegate{
    var people: [NSManagedObject] = []
    var names : [String] = []
    var rules : [String] = []
    var image = true
    
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var taskSubject: UILabel!
    @IBOutlet weak var taskDescription: UILabel!
    @IBOutlet weak var taskDueDate: UILabel!
    @IBOutlet weak var imageview: UIImageView!
    
    @IBOutlet weak var ColourBlock: UILabel!
    @IBOutlet weak var buttonOutlet: UIButton!
    @IBAction func buttonPressed(_ sender: Any) {
        ColourBlock.isHidden = true
        imageview.isHidden = true
        buttonOutlet.isHidden = true
        buttonOutlet.isEnabled = false
        
    }

    @IBAction func taskPhoto(_ sender: Any) {
        if image == true{
            ColourBlock.isHidden = false
            imageview.isHidden = false
            buttonOutlet.isHidden = false
            buttonOutlet.isEnabled = true
            
            
        }else{
            ColourBlock.isHidden = true
            imageview.isHidden = true
            buttonOutlet.isHidden = true
            buttonOutlet.isEnabled = false
            let alert = UIAlertController(title: "Oops", message: "You didnt take a photo.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            }))
            self.present(alert, animated: true, completion: nil)
            
        }
        
        
        
    }
    
    @IBOutlet weak var dueinTag: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        thing()
        taskName.layer.borderWidth = 2.0
        taskName.layer.cornerRadius = 8
        taskName.layer.masksToBounds = true
        taskSubject.layer.borderWidth = 2.0
        taskSubject.layer.cornerRadius = 8
        taskSubject.layer.masksToBounds = true
        taskDescription.layer.borderWidth = 2.0
        taskDescription.layer.cornerRadius = 8
        taskDescription.layer.masksToBounds = true
        taskDueDate.layer.borderWidth = 2.0
        taskDueDate.layer.cornerRadius = 8
        taskDueDate.layer.masksToBounds = true
        dueinTag.layer.borderWidth = 2.0
        dueinTag.layer.cornerRadius = 8
        dueinTag.layer.masksToBounds = true
        

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        thing()
    }
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    var newcolour = ""
    func thing(){
        
        
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Task")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            people = try managedContext.fetch(fetchRequest)
            print(people[task.number])
            let game = people[task.number]
            taskName.text = game.value(forKeyPath: "name") as! String
            taskSubject.text = game.value(forKeyPath: "subject") as! String
            taskDescription.text = game.value(forKeyPath: "desc") as! String
            taskDueDate.text = game.value(forKeyPath: "date") as! String
            newcolour = game.value(forKeyPath: "colour") as! String
            var imagearound = game.value(forKey: "image") as? Data
            print(imagearound?.count)
            if imagearound?.count == 0 {
                image = false
            }else{
                image = true
            }
            
            if let imageData = game.value(forKey: "image") as? Data {
                print("here")
                print(imageData)
                if let imaged = UIImage(data:imageData) {
                    imageview.image = imaged
                    print("done")
                }
            }
            
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        if newcolour == "blue" {
            taskName.backgroundColor = UIColor.blue.lighter()
            taskName.textColor = UIColor.black
            taskDueDate.backgroundColor = UIColor.blue.lighter()
            taskDueDate.textColor = UIColor.black
            taskSubject.backgroundColor = UIColor.blue.lighter()
            taskSubject.textColor = UIColor.black
            taskDescription.backgroundColor = UIColor.blue.lighter()
            taskDescription.textColor = UIColor.black
            dueinTag.backgroundColor = UIColor.blue.lighter()
            dueinTag.textColor = UIColor.black
        } else if newcolour == "cyan" {
            taskName.backgroundColor = UIColor.cyan.lighter()
            taskName.textColor = UIColor.black
            taskDueDate.backgroundColor = UIColor.cyan.lighter()
            taskDueDate.textColor = UIColor.black
            taskSubject.backgroundColor = UIColor.cyan.lighter()
            taskSubject.textColor = UIColor.black
            taskDescription.backgroundColor = UIColor.cyan.lighter()
            taskDescription.textColor = UIColor.black
            dueinTag.backgroundColor = UIColor.cyan.lighter()
            dueinTag.textColor = UIColor.black
        } else if newcolour == "brown" {
            taskName.backgroundColor = UIColor.brown.lighter()
            taskName.textColor = UIColor.black
            taskDueDate.backgroundColor = UIColor.brown.lighter()
            taskDueDate.textColor = UIColor.black
            taskSubject.backgroundColor = UIColor.brown.lighter()
            taskSubject.textColor = UIColor.black
            taskDescription.backgroundColor = UIColor.brown.lighter()
            taskDescription.textColor = UIColor.black
            dueinTag.backgroundColor = UIColor.brown.lighter()
            dueinTag.textColor = UIColor.black
        } else if newcolour == "black" {
            taskName.backgroundColor = UIColor.white
            taskName.textColor = UIColor.black
            taskDueDate.backgroundColor = UIColor.white
            taskDueDate.textColor = UIColor.black
            taskSubject.backgroundColor = UIColor.white
            taskSubject.textColor = UIColor.black
            taskDescription.backgroundColor = UIColor.white
            taskDescription.textColor = UIColor.black
            dueinTag.backgroundColor = UIColor.white
            dueinTag.textColor = UIColor.black
        } else if newcolour == "magenta" {
            taskName.backgroundColor = UIColor.magenta.lighter()
            taskName.textColor = UIColor.black
            taskDueDate.backgroundColor = UIColor.magenta.lighter()
            taskDueDate.textColor = UIColor.black
            taskSubject.backgroundColor = UIColor.magenta.lighter()
            taskSubject.textColor = UIColor.black
            taskDescription.backgroundColor = UIColor.magenta.lighter()
            taskDescription.textColor = UIColor.black
            dueinTag.backgroundColor = UIColor.magenta.lighter()
            dueinTag.textColor = UIColor.black
        } else if newcolour == "red" {
            taskName.backgroundColor = UIColor.red.lighter()
            taskName.textColor = UIColor.black
            taskDueDate.backgroundColor = UIColor.red.lighter()
            taskDueDate.textColor = UIColor.black
            taskSubject.backgroundColor = UIColor.red.lighter()
            taskSubject.textColor = UIColor.black
            taskDescription.backgroundColor = UIColor.red.lighter()
            taskDescription.textColor = UIColor.black
            dueinTag.backgroundColor = UIColor.red.lighter()
            dueinTag.textColor = UIColor.black
        } else if newcolour == "green" {
            taskName.backgroundColor = UIColor.green.lighter()
            taskName.textColor = UIColor.black
            taskDueDate.backgroundColor = UIColor.green.lighter()
            taskDueDate.textColor = UIColor.black
            taskSubject.backgroundColor = UIColor.green.lighter()
            taskSubject.textColor = UIColor.black
            taskDescription.backgroundColor = UIColor.green.lighter()
            taskDescription.textColor = UIColor.black
            dueinTag.backgroundColor = UIColor.green.lighter()
            dueinTag.textColor = UIColor.black
        } else if newcolour == "orange" {
            taskName.backgroundColor = UIColor.orange.lighter()
            taskName.textColor = UIColor.black
            taskDueDate.backgroundColor = UIColor.orange.lighter()
            taskDueDate.textColor = UIColor.black
            taskSubject.backgroundColor = UIColor.orange.lighter()
            taskSubject.textColor = UIColor.black
            taskDescription.backgroundColor = UIColor.orange.lighter()
            taskDescription.textColor = UIColor.black
            dueinTag.backgroundColor = UIColor.orange.lighter()
            dueinTag.textColor = UIColor.black
        } else{
            taskName.backgroundColor = UIColor.white
            taskName.textColor = UIColor.black
            taskDueDate.backgroundColor = UIColor.white
            taskDueDate.textColor = UIColor.black
            taskSubject.backgroundColor = UIColor.white
            taskSubject.textColor = UIColor.black
            taskDescription.backgroundColor = UIColor.white
            taskDescription.textColor = UIColor.black
            dueinTag.backgroundColor = UIColor.white
            dueinTag.textColor = UIColor.black
            
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override var prefersStatusBarHidden: Bool {
        return true
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
