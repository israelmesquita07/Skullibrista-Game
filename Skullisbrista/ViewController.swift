//
//  ViewController.swift
//  Skullisbrista
//
//  Created by Israel3D on 19/07/2018.
//  Copyright © 2018 Israel3D. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {

    @IBOutlet weak var imgStreet: UIImageView!
    @IBOutlet weak var imgPlayer: UIImageView!
    @IBOutlet weak var lblInstructions: UILabel!
    @IBOutlet weak var vwGameOver: UIView!
    @IBOutlet weak var lblTimePlayed: UILabel!
    
    var isMoving = false
    lazy var motionManager = CMMotionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vwGameOver.isHidden = true
        
        imgStreet.frame.size.height = view.frame.size.height * 2
        imgStreet.frame.size.width = view.frame.size.width * 2
        imgStreet.center = view.center
        
        imgPlayer.center = view.center
        imgPlayer.animationImages = []
        for i in 0...7 {
            let imagem = UIImage(named:"player\(i)")!
            imgPlayer.animationImages?.append(imagem)
        }
        imgPlayer.animationDuration = 0.5
        imgPlayer.startAnimating()
        Timer.scheduledTimer(withTimeInterval: 6.0, repeats: false) { (timer) in
            self.start()
        }
    }
    
    func start(){
        lblInstructions.isHidden = true
        vwGameOver.isHidden = true
        isMoving = false
        
        if motionManager.isDeviceMotionAvailable {
            motionManager.startDeviceMotionUpdates(to: OperationQueue.main, withHandler: { (data, error) in
                
                if error == nil {
                    if let data = data {
                        let angle = atan2(data.gravity.x, data.gravity.y) - .pi
                        self.imgPlayer.transform = CGAffineTransform(rotationAngle: CGFloat(angle))
                    }
                }
            })
        }
    }
    
    @IBAction func playAgain(_ sender: UIButton) {
    }


}

