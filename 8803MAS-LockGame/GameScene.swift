//
//  GameScene.swift
//  8803MAS-LockGame
//
//  Created by yxue on 8/31/19.
//  Copyright © 2019 yxue. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var lock = SKShapeNode()
    var needle = SKShapeNode()
    var dot = SKShapeNode()
    var path = UIBezierPath()
    
    let zeroAngle: CGFloat = 0.0
    
    var clockwise = Bool()
    var continueMode = Bool()
    var maxLevel = UserDefaults.standard.integer(forKey: "maxLevel")
    
    var started = false
    var touches = false
    
    var level = 1
    var dots = 0
    
    var levelLabel = SKLabelNode()
    var currentScoreLabel = SKLabelNode()
    
    override func didMove(to view: SKView){
        if continueMode {
            level = maxLevel
        }
        layoutGame()
    }
    
    func layoutGame(){
        backgroundColor = SKColor(red: 89.0/255.0, green: 172.0/255.0, blue: 194.0/255.0, alpha: 1.0)
        
        if level > maxLevel {
            UserDefaults.standard.set(level, forKey: "maxLevel")
        }
        // Create the circle
        path = UIBezierPath(arcCenter: CGPoint(x: self.frame.width/2, y: self.frame.height/2), radius:120,  startAngle: zeroAngle, endAngle: zeroAngle + CGFloat(M_PI * 2), clockwise: true)
        lock = SKShapeNode(path: path.cgPath)
        lock.strokeColor = SKColor(red: 195.0/255.0, green: 208.0/255.0, blue: 218.0/255.0, alpha: 1.0)
        lock.lineWidth = 40.0
        self.addChild(lock)
        
        // Create the needle
        needle = SKShapeNode(rectOf: CGSize(width: 40.0 - 7.0, height: 7.0), cornerRadius: 3.5)
        needle.fillColor = SKColor.white
        needle.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2 + 120.0)
        needle.zRotation = 3.14 / 2
        needle.zPosition = 2.0
        self.addChild(needle)
        
        // Level indicator
        levelLabel.fontSize = 32
        levelLabel.fontName = "AvenirNext-Bold"
        levelLabel.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2 + self.frame.height/3)
        levelLabel.fontColor = SKColor(red: 236.0/255.0, green: 240.0/255.0, blue: 241.0/255.0, alpha: 1.0)
        levelLabel.text = "Level \(level)"
        
        // Indicate the number of taps
        currentScoreLabel.fontSize = 18
        currentScoreLabel.fontName = "AvenirNext-Bold"
        currentScoreLabel.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        currentScoreLabel.fontColor = SKColor(red: 236.0/255.0, green: 240.0/255.0, blue: 241.0/255.0, alpha: 1.0)
        currentScoreLabel.text = "Tap to start"
        
        self.addChild(levelLabel)
        self.addChild(currentScoreLabel)
        
        newDot()
        isUserInteractionEnabled = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Called when a touch begins
        if !started {
            currentScoreLabel.text = "\(level - dots) tap(s) left"
            runClockwise()
            started = true
            clockwise = true
        } else {
            dotTouched()
        }
    }
    
    func runClockwise() {
        let dx = needle.position.x - self.frame.width / 2
        let dy = needle.position.y - self.frame.height / 2
        
        let radian = atan2(dy, dx)
        
        path = UIBezierPath(arcCenter: CGPoint(x: self.frame.width / 2, y: self.frame.height / 2), radius: 120, startAngle: radian, endAngle: radian + CGFloat(M_PI * 2), clockwise: true)
        let run = SKAction.follow(path.cgPath, asOffset: false, orientToPath:true, speed: 200)
        needle.run(SKAction.repeatForever(run).reversed())
    }
    
    func runCounterClockwise() {
        let dx = needle.position.x - self.frame.width / 2
        let dy = needle.position.y - self.frame.height / 2
        
        let radian = atan2(dy, dx)
        
        path = UIBezierPath(arcCenter: CGPoint(x: self.frame.width / 2, y: self.frame.height / 2), radius: 120, startAngle: radian, endAngle: radian + CGFloat(M_PI * 2), clockwise: true)
        let run = SKAction.follow(path.cgPath, asOffset: false, orientToPath:true, speed: 200)
        needle.run(SKAction.repeatForever(run))
    }
    
    func dotTouched() {
        if touches == true {
            touches = false
            dots+=1
            updateLabel()
            if dots >= level {
                started = false
                completed()
                return
            }
            dot.removeFromParent()
            newDot()
            if clockwise {
                runCounterClockwise()
                clockwise = false
            } else {
                runClockwise()
                clockwise = true
            }
        } else {
            started = false
            touches = false
            gameOver()
        }
    }
    func updateLabel(){
        currentScoreLabel.text = "\(level - dots) tap(s) left"
    }
    
    func newDot() {
        dot = SKShapeNode(circleOfRadius: 15.0)
        dot.fillColor = SKColor(red: 31.0/255.0, green : 150.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        dot.strokeColor = SKColor.clear
        
        let dx = needle.position.x - self.frame.width / 2
        let dy = needle.position.y - self.frame.height / 2
        
        let radian = atan2(dy, dx)
        
        if clockwise{
            let tempAngle = CGFloat.random(min: radian + 1.0, max: radian + 2.5)
            let tempPath = UIBezierPath(arcCenter: CGPoint(x: self.frame.width / 2, y: self.frame.height / 2),  radius: 120, startAngle: tempAngle, endAngle: tempAngle + CGFloat(M_PI * 2), clockwise: true)
            dot.position = tempPath.currentPoint
            
        } else {
            let tempAngle = CGFloat.random(min: radian - 1.0, max: radian - 2.5)
            let tempPath = UIBezierPath(arcCenter: CGPoint(x: self.frame.width / 2, y: self.frame.height / 2),  radius: 120, startAngle: tempAngle, endAngle: tempAngle + CGFloat(M_PI * 2), clockwise: true)
            dot.position = tempPath.currentPoint
            
        }
        
        self.addChild(dot)
    }
    
    func gameOver(){
        isUserInteractionEnabled = false
        needle.removeFromParent()
        currentScoreLabel.text = "Oh no..."
        let actionRed = SKAction.colorize(with: UIColor(red: 149.0/255.0, green: 165.0/255.0, blue: 166.0/255.0, alpha: 1.0), colorBlendFactor: 1.0, duration: 0.25)
        let actionBack = SKAction.wait(forDuration: 1.0)
        
        self.scene?.run(SKAction.sequence([actionRed, actionBack]), completion: { () -> Void in self.removeAllChildren()
            self.clockwise = false
            self.dots = 0
            self.layoutGame()
        })
        
        }
    
    func completed(){
        isUserInteractionEnabled = false
        needle.removeFromParent()
        currentScoreLabel.text = "You won!"
        let actionRed = SKAction.colorize(with: UIColor(red: 46.0/255.0, green: 204.0/255.0, blue: 113.0/255.0, alpha: 1.0), colorBlendFactor: 1.0, duration: 0.25)
        let actionBack = SKAction.wait(forDuration: 0.5)
        self.scene?.run(SKAction.sequence([actionRed, actionBack]), completion: { () -> Void in self.removeAllChildren()
            self.clockwise = false
            self.dots = 0
            self.level+=1
            self.layoutGame()
        })
        
    }
    
    override func update(_ currentTime: CFTimeInterval){
        // Called before each frame is rendered
        if started {
            if needle.intersects(dot) {
                touches = true
            } else {
                if touches == true {
                    if !needle.intersects(dot) {
                        started = false
                        touches = false
                        gameOver()
                    }
                }
            }
            
        }
    }
}

//class GameScene: SKScene {
//
//    private var label : SKLabelNode?
//    private var spinnyNode : SKShapeNode?
//
//    override func didMove(to view: SKView) {
//
//        // Get label node from scene and store it for use later
//        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
//        if let label = self.label {
//            label.alpha = 0.0
//            label.run(SKAction.fadeIn(withDuration: 2.0))
//        }
//
//        // Create shape node to use during mouse interaction
//        let w = (self.size.width + self.size.height) * 0.05
//        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
//
//        if let spinnyNode = self.spinnyNode {
//            spinnyNode.lineWidth = 2.5
//
//            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
//            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
//                                              SKAction.fadeOut(withDuration: 0.5),
//                                              SKAction.removeFromParent()]))
//        }
//    }
//
//
//    func touchDown(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.green
//            self.addChild(n)
//        }
//    }
//
//    func touchMoved(toPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.blue
//            self.addChild(n)
//        }
//    }
//
//    func touchUp(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.red
//            self.addChild(n)
//        }
//    }
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let label = self.label {
//            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
//        }
//
//        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
//    }
//
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
//    }
//
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
//    }
//
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
//    }
//
//
//    override func update(_ currentTime: TimeInterval) {
//        // Called before each frame is rendered
//    }
//}
