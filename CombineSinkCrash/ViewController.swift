//
//  ViewController.swift
//  CombineSinkCrash
//
//  Created by Fabian Mücke on 29.11.21.
//

import Cocoa

class ViewController: NSViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear() {
        super.viewDidAppear()

        crashMe()
    }

    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
}
