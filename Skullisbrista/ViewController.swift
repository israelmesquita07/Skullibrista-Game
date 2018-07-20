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
    var gameTimer:Timer!
    var startDate:Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vwGameOver.isHidden = true
        
        imgStreet.frame.size.width = view.frame.size.width * 2
        imgStreet.frame.size.height = imgStreet.frame.size.width * 2
        
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
        startDate = Date()
        
        self.imgStreet.transform = CGAffineTransform(rotationAngle: 0)
        self.imgPlayer.transform = CGAffineTransform(rotationAngle: 0)
        
        if motionManager.isDeviceMotionAvailable {
            motionManager.startDeviceMotionUpdates(to: OperationQueue.main, withHandler: { (data, error) in
                
                if error == nil {
                    if let data = data {
                        let angle = atan2(data.gravity.x, data.gravity.y) - .pi
                        self.imgPlayer.transform = CGAffineTransform(rotationAngle: CGFloat(angle))
                        if !self.isMoving{
                            self.checkGameOver()
                        }
                    }
                }
            })
        }
        gameTimer = Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true, block: { (timer) in
            self.rotateWorld()
        })
    }
    
    func rotateWorld(){
        let randomAngle = Double(arc4random_uniform(120))/100 - 0.6
        isMoving = true
        UIView.animate(withDuration: 0.75, animations: {
            self.imgStreet.transform = CGAffineTransform(rotationAngle: CGFloat(randomAngle))
        }){(success) in
           self.isMoving = false
        }
    }
    
    func checkGameOver(){
        let worldAngle = atan2(Double(imgStreet.transform.a), Double(imgStreet.transform.b))
        let playerAngle = atan2(Double(imgPlayer.transform.a), Double(imgPlayer.transform.b))
        let difference = abs(worldAngle - playerAngle)
        if difference > 0.25 {
            gameTimer.invalidate()
            vwGameOver.isHidden = false
            motionManager.stopDeviceMotionUpdates()
            let secondsPlayed = round(Date().timeIntervalSince(startDate))
            lblTimePlayed.text = "Você jogou durante \(secondsPlayed) segundos."
        }
    }
    
    @IBAction func playAgain(_ sender: UIButton) {
        start()
    }


}

