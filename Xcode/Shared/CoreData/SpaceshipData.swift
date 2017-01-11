//
//  SpaceshipData.swift
//  GameVI
//
//  Created by Pablo Henrique Bertaco on 1/11/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import CoreData

extension MemoryCard {
    
    func newSpaceshipData() -> SpaceshipData {
        let spaceshipData: SpaceshipData = self.insertNewObject()
        
        let color  = Spaceship.randomColor().ciColor
        
        spaceshipData.colorRed = Double(color.red)
        spaceshipData.colorGreen = Double(color.green)
        spaceshipData.colorBlue = Double(color.blue)
        spaceshipData.baseDamage = 10
        spaceshipData.level = 1
        spaceshipData.baseLife = 150
        spaceshipData.rarity = Int16(Spaceship.rarity.common.rawValue)
        spaceshipData.skin = Int16(Int.random(Spaceship.skins.count))
        spaceshipData.xp = 0
        
        return spaceshipData
    }
}
