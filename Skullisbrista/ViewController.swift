//
//  ViewController.swift
//  Skullisbrista
//
//  Created by Israel3D on 19/07/2018.
//  Copyright © 2018 Israel3D. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imgStreet: UIImageView!
    @IBOutlet weak var imgPlayer: UIImageView!
    @IBOutlet weak var lblInstructions: UILabel!
    @IBOutlet weak var vwGameOver: UIView!
    @IBOutlet weak var lblTimePlayed: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vwGameOver.isHidden = true
    }
    
    @IBAction func playAgain(_ sender: UIButton) {
    }


}

