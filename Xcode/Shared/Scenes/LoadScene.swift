//
//  LoadScene.swift
//  CommandersWar
//
//  Created by Pablo Henrique Bertaco on 1/10/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import SpriteKit
import GameKit

class LoadScene: GameScene {
    
    var spaceships = [Spaceship]()
    weak var gameWorld: GameWorld!
    weak var gameCamera: GameCamera!
    
    init() {
        GameScene.defaultSize = CGSize(width: 375, height: 667)
        //GameScene.defaultFilteringMode = .nearest
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func load() {
        super.load()
        
        #if DEBUG
        self.view?.showsFPS = true
        //            self.view?.showsDrawCount = true
        //            self.view?.showsNodeCount = true
        //            self.view?.showsPhysics = true
        //
        //            MemoryCard.sharedInstance.reset()
        //            let playerData = MemoryCard.sharedInstance.playerData!
        //            playerData.points = 9999999
        //            playerData.premiumPoints = 999999
        //            playerData.maxBotLevel = Int16(Mission.types.count)
        //            print(playerData.maxBotLevel)
        //            playerData.maxSpaceshipLevel = 10
        //
        //            if let spaceships = playerData.spaceships {
        //                if spaceships.count < 100 {
        //                    for _ in spaceships.count...100 {
        //                        let rarity = Spaceship.randomRarity()
        //                        let spaceship = Spaceship(level: 1, rarity: rarity)
        //                        let spaceshipData = MemoryCard.sharedInstance.newSpaceshipData(spaceship: spaceship)
        //                        playerData.addToSpaceships(spaceshipData)
        //                    }
        //                }
        //            }
        #endif
        
        Label.defaultFontName = .kenPixel
        Label.defaultColor = GameColors.fontWhite
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        self.backgroundColor = GameColors.backgroundColor
        
        let gameWorld = GameWorld()
        gameWorld.zPosition = -1000000
        self.addChild(gameWorld)
        self.physicsWorld.contactDelegate = gameWorld
        
        let gameCamera = GameCamera()
        let gameCameraNode = SKNode()
        gameCamera.node = gameCameraNode
        gameWorld.addChild(gameCamera)
        gameWorld.addChild(gameCameraNode)
        gameCamera.update()
        
        gameWorld.explosionSoundEffect = nil
        gameWorld.shotSoundEffect = nil
        
        self.gameWorld = gameWorld
        self.gameCamera = gameCamera
        
        let title = Control(imageNamed: "title", x: 9, y: 281, horizontalAlignment: .center, verticalAlignment: .center)
        title.set(color: .white, blendMode: .add)
        self.addChild(title)
        
        self.addChild(Label(text: "TOUCH TO START", x: 187, y: 620, horizontalAlignment: .center, verticalAlignment: .center))
        
        let bundleShortVersionString = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0.0"
        let bundleVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "1"
        
        self.addChild(Label(text: "v\(bundleShortVersionString)(\(bundleVersion))", horizontalAlignmentMode: .right, verticalAlignmentMode: .baseline, fontName: .kenPixel, fontSize: .fontSize8, x: 370, y: 646, horizontalAlignment: .center, verticalAlignment: .center))
        
        self.afterDelay(60) { [weak self] in
            guard let `self` = self else { return }
            self.view?.presentScene(LoadScene(), transition: GameScene.defaultTransition)
        }
    }
    
    override func updateSize() {
        super.updateSize()
        self.gameCamera.update()
        self.gameWorld.updateSize()
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        for spaceship in self.spaceships {
            spaceship.update(enemyMothership: nil, enemySpaceships: self.spaceships)
            if spaceship.health <= 0 {
                spaceship.destroy()
                spaceship.healthBar?.destroy()
            }
        }
    }
    
    override func fpsCountUpdate(fps: Int) {
        
        if fps >= 30 {
            if self.needMusic {
                self.needMusic = false
                Music.sharedInstance.playMusic(withType: .battle)
            }
        }
        
        self.spaceships = self.spaceships.filter({ $0.health > 0 })
        
        if self.spaceships.count < 3 && fps >= 60 {
            let spaceship = Spaceship(level: 1 + Int.random(10), rarity: Spaceship.randomRarity(), loadPhysics: true, team: .none)
            spaceship.setBitMasksToSpaceship()
            spaceship.physicsBody?.isDynamic = true
            spaceship.position = CGPoint(
                x: CGFloat.random(min: -GameScene.sketchSize.width/2, max: GameScene.sketchSize.width/2),
                y: CGFloat.random(min: -GameScene.sketchSize.height/2, max: GameScene.sketchSize.height/2))
            spaceship.destination = CGPoint(
                x: CGFloat.random(min: -GameScene.sketchSize.width/2, max: GameScene.sketchSize.width/2),
                y: CGFloat.random(min: -GameScene.sketchSize.height/2, max: GameScene.sketchSize.height/2))
            spaceship.canRespawn = false
            self.gameWorld.addChild(spaceship)
            self.spaceships.append(spaceship)
            
            spaceship.loadHealthBar(gameWorld: gameWorld)
            spaceship.loadJetEffect(gameWorld: gameWorld)
            
            spaceship.updateHealthBarPosition()
            
            let action = SKAction.fadeAlpha(to: 1, duration: 1)
            spaceship.alpha = 0
            spaceship.run(action)
            spaceship.healthBar?.alpha = 0
            spaceship.healthBar?.run(action)
            spaceship.zRotation = CGFloat.random(min: -π, max: +π)
        }
        
        if self.spaceships.count > 0 {
            let spaceship = self.spaceships[Int.random(self.spaceships.count)]
            let newTargetNode = self.spaceships[Int.random(self.spaceships.count)]
            if newTargetNode != spaceship {
                spaceship.destination = nil
                spaceship.targetNode = newTargetNode
            } else {
                spaceship.destination = CGPoint(
                    x: CGFloat.random(min: -GameScene.sketchSize.width/2, max: GameScene.sketchSize.width/2),
                    y: CGFloat.random(min: -GameScene.sketchSize.height/2, max: GameScene.sketchSize.height/2))
            }
        }
    }
    
    override func didSimulatePhysics() {
        super.didSimulatePhysics()
        
        
        Shot.update()
        
        for spaceship in self.spaceships {
            spaceship.didSimulatePhysics()
        }
    }
    
    override func touchUp(touch: UITouch) {
        super.touchUp(touch: touch)
        Music.sharedInstance.stop()
        self.view?.presentScene(MainMenuScene(), transition: GameScene.defaultTransition)
        #if os(iOS)
        let playerData = MemoryCard.sharedInstance.playerData
        GameViewController.sharedInstance()?.authenticateLocalPlayer { [weak playerData] in
            let alias = GKLocalPlayer.local.alias
            playerData?.name = alias
//            Metrics.configure()
        }
        #endif
    }
}
