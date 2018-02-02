//
//  ViewController.swift
//  Example
//
//  Created by David Walter on 02.02.18.
//  Copyright © 2018 David Walter. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func authenticate(_ sender: AnyObject?) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.passcode.authenticate(on: self, animated: true)
    }
    
    @IBAction func askCode(_ sender: AnyObject?) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.passcode.askCode(on: self, animated: true)
    }
    
    @IBAction func changeCode(_ sender: AnyObject?) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.passcode.changeCode(on: self, animated: true)
    }
    
}

