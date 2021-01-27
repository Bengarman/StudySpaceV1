//
//  loadingViewController.swift
//  Score Keeper
//
//  Created by Ben Garman on 12/12/2017.
//  Copyright © 2017 Ben Garman. All rights reserved.
//

import UIKit

class loadingViewController: UIViewController {
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func fadeViewInThenOut(view : UIView, delay: TimeInterval) {
        
        UIView.animate(withDuration: delay, delay: 0.5, options: .curveEaseInOut , animations: { () -> Void in
            view.alpha = 1
        },
                                   completion: nil)
        // Fade in the view
        
    }
    @IBOutlet weak var viewanimated: UIView!
    
    @IBOutlet weak var gamesLabel: UIView!
    @IBOutlet weak var garmaniLabel: UIView!
    @IBOutlet weak var gLabel: UIView!
    @IBOutlet weak var colourBlob: UIView!
    override func prefersHomeIndicatorAutoHidden() -> Bool {
        return true
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        gamesLabel.alpha = 0
        garmaniLabel.alpha = 0
        gLabel.alpha = 0
        colourBlob.alpha = 0

        
        UIView.animate(withDuration: 0.5, animations: {
            self.colourBlob.alpha = 1
        }) { _ in
            UIView.animate(withDuration: 1, animations: {
                self.gLabel.alpha = 1
            }) { _ in
                UIView.animate(withDuration: 0.5, animations: {
                    self.garmaniLabel.alpha = 1
                }){ _ in
                    UIView.animate(withDuration: 0.5, animations: {
                        self.gamesLabel.alpha = 1
                    }){ _ in
                        UIView.animate(withDuration: 0.5, animations: {
                            self.performSegue(withIdentifier: "go", sender: nil)
                        })
                    }
                    
                }
            }
            
        }
        
        
        
        
        
        
        
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
