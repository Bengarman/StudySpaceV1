//
//  xxxxxxxxx.swift
//  Study Space
//
//  Created by Ben Garman on 31/10/2017.
//  Copyright © 2017 Ben Garman. All rights reserved.
//

import UIKit

class xxxxxxxxx: UITabBarController {

    override func viewDidLoad() {
        let modelName = UIDevice.current.modelName
        if modelName == "iPhone X"{
            self.title = ""
        }
        
        
        if which.controller == 0 {
            
            self.selectedIndex = 0
            
        }else if which.controller == 1{
            self.selectedIndex = 1
        }
        super.viewDidLoad()

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
