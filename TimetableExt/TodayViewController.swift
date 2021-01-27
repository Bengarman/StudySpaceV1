//
//  TodayViewController.swift
//  TimetableExt
//
//  Created by Ben Garman on 14/10/2017.
//  Copyright © 2017 Michael Crump. All rights reserved.
//

import UIKit
import NotificationCenter
import CoreData

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
}

class TodayViewController: UIViewController, NCWidgetProviding {


    @IBOutlet weak var lessonNow: UILabel!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var nowNext: UILabel!
    @IBOutlet weak var colourLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        dateFormatter.dateFormat = "hh:mm a"
        date2Formatter.dateFormat = "a"
        dayFormatter.dateFormat = "EEEE"
        super.viewDidLoad()
        
        // Do any additional setup after loading the view from its nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    let defaults = UserDefaults.standard
    let dateFormatter = DateFormatter()
    let date2Formatter = DateFormatter()
    let dayFormatter = DateFormatter()
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        let lessonNameDU = UserDefaults.init(suiteName: "group.tosendtotoday")?.value(forKey: "lessonName")
        var lessonName = lessonNameDU as! [String]
        
        let startTimeDU = UserDefaults.init(suiteName: "group.tosendtotoday")?.value(forKey: "startTime")
        var startTime2 = startTimeDU as! [Date]
        
        let endTimeDU = UserDefaults.init(suiteName: "group.tosendtotoday")?.value(forKey: "finishTime")
        var endTime = endTimeDU as! [Date]
        
        let dayDU = UserDefaults.init(suiteName: "group.tosendtotoday")?.value(forKey: "day")
        var day = dayDU as! [String]
        
        let colourDU = UserDefaults.init(suiteName: "group.tosendtotoday")?.value(forKey: "colour")
        var colour = colourDU as! [String]
        
        var today = Date()

        var count = startTime2.count
        
        count = count - 1
        
        while count >= 0{
            print("here")
            if dateFormatter.string(from: startTime2[count]) < dateFormatter.string(from: today ) && dateFormatter.string(from: endTime[count]) > dateFormatter.string(from: today ) && (day[count]) == dayFormatter.string(from: today ) && date2Formatter.string(from: startTime2[count]) == date2Formatter.string(from: today ){
                print("test")
                lessonNow.text = lessonName[count]
                startTime.text = dateFormatter.string(from: startTime2[count])
                colourLabel.layer.cornerRadius = 20
                colourLabel.layer.masksToBounds = true
                colourLabel.isHidden = false
                lessonNow.isHidden = false
                startTime.isHidden = false
                nowNext.textAlignment = .center
                nowNext.text = "Now:"
                
                let newcolour = colour[count]
                if newcolour == "blue" {
                    colourLabel.backgroundColor = UIColor.blue.lighter()
                } else if newcolour == "cyan" {
                    colourLabel.backgroundColor = UIColor.cyan.lighter()
                } else if newcolour == "brown" {
                    colourLabel.backgroundColor = UIColor.brown
                } else if newcolour == "black" {
                    colourLabel.backgroundColor = UIColor.white.lighter()
                } else if newcolour == "magenta" {
                    colourLabel.backgroundColor = UIColor.magenta.lighter()
                } else if newcolour == "red" {
                    colourLabel.backgroundColor = UIColor.red.lighter()
                } else if newcolour == "green" {
                    colourLabel.backgroundColor = UIColor.green.lighter()
                } else if newcolour == "orange" {
                    colourLabel.backgroundColor = UIColor.orange.lighter()
                }else{
                    colourLabel.backgroundColor = UIColor.white
                    
                }
                
                count = -1
                
            }else{
                
                colourLabel.isHidden = true
                lessonNow.isHidden = true
                startTime.isHidden = true
                nowNext.textAlignment = .center
                nowNext.text = "No current Lessons"
                
            }
            
            count = count - 1
            
        }
        
        
        //lessonNow.text = quoteFromApp[quoteFromApp.count]
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
