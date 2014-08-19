//
//  GameScene.swift
//  Anomaly
//
//  Created by Maciej Gad on 19.08.2014.
//  Copyright (c) 2014 Maciej Gad. All rights reserved.
//

import SpriteKit
//import ScalarArithmetic

class GameScene: SKScene {
    let spaceship:SKSpriteNode
    var spaceTarget:CGPoint
    var spaceshpiSpeed:Float = 500 //pix per sec
    var trail:SKEmitterNode?
    var blasterLeft:SKEmitterNode?
    var blasterRight:SKEmitterNode?
    
    required init(coder aDecoder: NSCoder) {
        spaceship = SKSpriteNode(imageNamed: "spaceship")
        spaceTarget = CGPoint(x: 0, y: 0)
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(size: CGSize) {
        spaceship = SKSpriteNode(imageNamed: "spaceship")
        spaceTarget = CGPoint(x: 0, y: 0)
        super.init(size: size)
        setup()
    }
    
    
    func setup() {
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let background = SKSpriteNode(imageNamed: "space_background")
        background.size=CGSize(width: size.height, height: size.width)
        background.zPosition = -2
        addChild(background)
        spaceship.size = CGSize(width: 75, height: 104.5)
        let trailPath = NSBundle.mainBundle().pathForResource("trail", ofType: "sks")
        trail = NSKeyedUnarchiver.unarchiveObjectWithFile(trailPath) as? SKEmitterNode
        
        trail!.position = CGPointMake(0, -30.0)
        trail!.zPosition = 1
        trail!.targetNode = self.scene
        spaceship.addChild(trail!)
        
        let blasterPath = NSBundle.mainBundle().pathForResource("blaster", ofType: "sks")
        blasterLeft = NSKeyedUnarchiver.unarchiveObjectWithFile(blasterPath) as? SKEmitterNode
        blasterLeft!.targetNode = self.scene
        blasterLeft!.zPosition = -10
        blasterLeft!.position = CGPointMake(-25.5, 52)
        spaceship.addChild(blasterLeft)
        
        blasterRight = NSKeyedUnarchiver.unarchiveObjectWithFile(blasterPath) as? SKEmitterNode
        blasterRight!.targetNode = self.scene
        blasterRight!.zPosition = -10
        blasterRight!.position = CGPointMake(25.5, 52)
        spaceship.addChild(blasterRight)
        
        addChild(spaceship)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for anyTouch:AnyObject in touches{
            let touch:UITouch = anyTouch as UITouch
            let location:CGPoint = touch.locationInNode(self)
            NSLog("location %@", NSStringFromCGPoint(location))
            let diff:CGPoint = CGPointMake(location.x - spaceship.position.x, location.y - spaceship.position.y);
            NSLog("diff %@", NSStringFromCGPoint(diff))
            var angle:CGFloat =  atan2(diff.y, diff.x) - M_PI_2;
            var time:Float = sqrtf((Float)(diff.x*diff.x + diff.y*diff.y))/spaceshpiSpeed;
            trail!.emissionAngle = angle - M_PI_2
            let startAngle = blasterLeft!.emissionAngle
            let changeAngle = (angle + M_PI_2) - startAngle
            let moveToAction:SKAction = SKAction.moveTo(location, duration: Double(time))
            let rotateAction:SKAction = SKAction.rotateToAngle(angle, duration: Double(time))
            let changeAttactAngle:SKAction = SKAction.customActionWithDuration(Double(time), actionBlock: { (node, animationTime) -> Void in
                self.blasterLeft!.emissionAngle = startAngle + changeAngle*animationTime/time
                self.blasterRight!.emissionAngle = startAngle + changeAngle*animationTime/time
            })
            spaceship.runAction(
                SKAction.group([moveToAction, rotateAction, changeAttactAngle])
            )
        }
    }
    
//    override func update(currentTime: CFTimeInterval) {
//    }
}