//
//  GameScene.swift
//  FlappyBird
//
//  Created by David Hincapie on 11/27/15.
//  Copyright (c) 2015 David Hincapie. All rights reserved.
//


import SpriteKit
import AVFoundation


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var bird = SKSpriteNode();
    var pipeUpTexture = SKTexture()
    var pipeDownTexture = SKTexture()
    var pipesMoveAndRemove = SKAction()
    let pipeGap = 160.0
    var url = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("flapping", ofType: "wav")!)
    var audioPlayer = AVAudioPlayer()
    
    let birdCategory: UInt32 = 0x1 << 0
    let groundCategory: UInt32 = 0x1 << 1
    let pipeCategory: UInt32 = 0x1 << 2
    
    override func didMoveToView(view: SKView) {
        do{
            audioPlayer = try AVAudioPlayer(contentsOfURL: url)
        }catch{
            print("error with sound")
        }
        /* Setup your scene here */
        
        //Physics
        self.physicsWorld.gravity = CGVectorMake(0.0, -10.0)
        
        
        //Bird
        let birdTexture = SKTexture(imageNamed: "Bird1")
        birdTexture.filteringMode = SKTextureFilteringMode.Nearest
        
        bird = SKSpriteNode(texture: birdTexture)
        bird.setScale(2)
        bird.position = CGPoint(x: self.frame.size.width*0.35, y: self.frame.size.height*0.6)
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.height / 2.0)
        bird.physicsBody?.dynamic = true
        bird.physicsBody?.allowsRotation = false
        bird.physicsBody?.usesPreciseCollisionDetection = true
        bird.physicsBody?.categoryBitMask = birdCategory
        self.addChild(bird)
        
        //Ground
        let groundTexture = SKTexture(imageNamed: "land")
        let sprite = SKSpriteNode(texture: groundTexture)
        sprite.setScale(2)
        sprite.position = CGPointMake(self.size.width / 2, sprite.size.height / 2)
        self.addChild(sprite)
        
        let ground = SKNode()
        ground.position = CGPointMake(0.0, groundTexture.size().height)
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, groundTexture.size().height*2.0))
        ground.physicsBody?.dynamic = false
        ground.physicsBody?.usesPreciseCollisionDetection = true
        ground.physicsBody?.categoryBitMask = groundCategory
        self.addChild(ground)
        
        //Background city
        let bgImage = SKSpriteNode(imageNamed: "sky")
        bgImage.setScale(1.75)
        bgImage.zPosition = -15
        bgImage.position = CGPointMake(self.size.width/2, self.size.height/2.5)
        self.addChild(bgImage)
        
        //background color
        backgroundColor = UIColor.cyanColor()
        
        //Pipes
        //Create the Pipes
        pipeUpTexture = SKTexture(imageNamed: "PipeUp")
        pipeDownTexture = SKTexture(imageNamed: "PipeDown")
        
        //movement of pipes
        let distanceToMove = CGFloat(self.frame.size.width + 2.0 * pipeUpTexture.size().width)
        let movePipes = SKAction.moveByX(-distanceToMove, y: 0.0, duration: NSTimeInterval(0.01 * distanceToMove))
        let removePipes = SKAction.removeFromParent()
        pipesMoveAndRemove = SKAction.sequence([movePipes, removePipes])
        
        //Spawn Pipes
        let spawn = SKAction.runBlock({() in self.spawnPipes()})
        let delay = SKAction.waitForDuration(NSTimeInterval(2.0))
        let spawnThenDelay = SKAction.sequence([spawn,delay])
        let spawnThenDelayForever = SKAction.repeatActionForever(spawnThenDelay)
        self.runAction(spawnThenDelayForever)
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
    }
    
    //spawnPipes function
    func spawnPipes() {
        let pipePair = SKNode()
        pipePair.position = CGPointMake(self.frame.size.width + pipeUpTexture.size().width * 2, 0)
        pipePair.zPosition = -10
        
        let height = UInt32(self.frame.size.height / 4)
        let y = arc4random() % height + height
        
        let pipeDown = SKSpriteNode(texture: pipeDownTexture)
        pipeDown.setScale(2.0)
        pipeDown.position = CGPointMake(0.0, CGFloat(y) + pipeDown.size.height + CGFloat(pipeGap))
        pipeDown.physicsBody = SKPhysicsBody(rectangleOfSize: pipeDown.size)
        pipeDown.physicsBody?.dynamic = false
        pipePair.addChild(pipeDown)
        
        let pipeUp = SKSpriteNode(texture: pipeUpTexture)
        pipeUp.setScale(2.0)
        pipeUp.position = CGPointMake(0.0, CGFloat(y))
        pipeUp.physicsBody = SKPhysicsBody(rectangleOfSize: pipeUp.size)
        pipeUp.physicsBody?.dynamic = false
        pipePair.addChild(pipeUp)
        
        pipePair.runAction(pipesMoveAndRemove)
        self.addChild(pipePair)
        
        
    }
    
    
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
       
        audioPlayer.play()
        for touch in touches {
          audioPlayer.play()
            //let location = touch.locationInNode(self)
            bird.physicsBody?.velocity = CGVectorMake(0, 0)
            bird.physicsBody?.applyImpulse(CGVectorMake(0, 10))
            
            
            
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
