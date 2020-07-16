//
//  ViewController.swift
//  Skullisbrista
//
//  Created by Israel3D on 19/07/2018.
//  Copyright © 2018 Israel3D. All rights reserved.
//

import UIKit
import CoreMotion

final class ViewController: UIViewController {

    @IBOutlet weak var imgStreet: UIImageView!
    @IBOutlet weak var imgPlayer: UIImageView!
    @IBOutlet weak var lblInstructions: UILabel!
    @IBOutlet weak var vwGameOver: UIView!
    @IBOutlet weak var lblTimePlayed: UILabel!
    
    var isMoving = false
    lazy var motionManager = CMMotionManager()
    var gameTimer: Timer!
    var startDate: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupFrames()
        setupImageAnimations()
    }
    
    private func setupView() {
        vwGameOver.isHidden = true
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
    }
    
    private func setupFrames() {
        imgStreet.frame.size.width = view.frame.size.width * 2
        imgStreet.frame.size.height = imgStreet.frame.size.width * 2
        imgStreet.center = view.center
        imgPlayer.center = view.center
    }
    
    private func setupImageAnimations() {
        imgPlayer.animationImages = []
        addImagesPlayer()
        imgPlayer.animationDuration = 0.5
        imgPlayer.startAnimating()
        Timer.scheduledTimer(withTimeInterval: 6.0, repeats: false) { (timer) in
            self.start()
        }
    }
    
    private func addImagesPlayer() {
        for i in 0...7 {
            let imagem = UIImage(named:"player\(i)")!
            imgPlayer.animationImages?.append(imagem)
        }
    }
    
    private func start(){
        lblInstructions.isHidden = true
        vwGameOver.isHidden = true
        isMoving = false
        startDate = Date()
        
        imgStreet.transform = CGAffineTransform(rotationAngle: 0)
        imgPlayer.transform = CGAffineTransform(rotationAngle: 0)
        
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
    
    private func rotateWorld() {
        let randomAngle = Double(arc4random_uniform(120))/100 - 0.6
        isMoving = true
        UIView.animate(withDuration: 1.0, animations: {
            self.imgStreet.transform = CGAffineTransform(rotationAngle: CGFloat(randomAngle))
        }) { _ in
           self.isMoving = false
        }
    }
    
    private func checkGameOver() {
        let worldAngle = atan2(Double(imgStreet.transform.a), Double(imgStreet.transform.b))
        let playerAngle = atan2(Double(imgPlayer.transform.a), Double(imgPlayer.transform.b))
        let difference = abs(worldAngle - playerAngle)
        if difference > 0.26 {
            gameOver()
        }
    }
    
    private func gameOver() {
        gameTimer.invalidate()
        vwGameOver.isHidden = false
        motionManager.stopDeviceMotionUpdates()
        let secondsPlayed = round(Date().timeIntervalSince(startDate))
        lblTimePlayed.text = "Você jogou durante \(secondsPlayed) longos segundos!"
    }
    
    @IBAction private func playAgain(_ sender: UIButton) {
        start()
    }
}
