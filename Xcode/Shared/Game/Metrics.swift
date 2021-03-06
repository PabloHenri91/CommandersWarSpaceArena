////
////  Metrics.swift
////  CommandersWar
////
////  Created by Pablo Henrique Bertaco on 1/11/17.
////  Copyright © 2017 PabloHenri91. All rights reserved.
////
//
//#if os(iOS)
//    import Fabric
//    import Crashlytics
//    import GameAnalytics
//#endif
//
//import SpriteKit
//import GameKit
//
//class Metrics {
//    
//    static var needToConfigure = true
//    
//    static func configure() {
//        
//        if Metrics.needToConfigure {
//            if Metrics.canSendEvents() {
//                Metrics.needToConfigure = false
//                #if os(iOS)
//                    Fabric.with([Crashlytics.self, GameAnalytics.self])
//                    
//                    let bundleShortVersionString = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0.0"
//                    GameAnalytics.configureBuild(bundleShortVersionString)
//                    GameAnalytics.initializeWithConfiguredGameKeyAndGameSecret()
//                #endif
//            }
//        }
//    }
//    
//    static func loadBox(boxName: String) {
//        guard Metrics.canSendEvents() else { return }
//    }
//    
//    static func loadScene(sceneName: String) {
//        guard Metrics.canSendEvents() else { return }
//    }
//    
//    static func battleStart() {
//        guard Metrics.canSendEvents() else { return }
//        
//        let playerData = MemoryCard.sharedInstance.playerData!
//        let botLevel = playerData.botLevel
//    }
//    
//    static func openTheGame() {
//        guard Metrics.canSendEvents() else { return }
//        
//        let date = Date()
//        let formatter = DateFormatter()
//        formatter.dateFormat = "HH"
//        formatter.timeZone = NSTimeZone.local
//        let hour = formatter.string(from: date)
//    }
//    static func win(score: Int) {
//        guard Metrics.canSendEvents() else { return }
//        
//        let playerData = MemoryCard.sharedInstance.playerData!
//        let botLevel = playerData.botLevel
//    }
//    
//    static func lose(score: Int) {
//        guard Metrics.canSendEvents() else { return }
//        
//        let playerData = MemoryCard.sharedInstance.playerData!
//        let botLevel = playerData.botLevel
//    }
//    
//    static func userName() -> String {
//        return MemoryCard.sharedInstance.playerData.name ?? "Unknown"
//    }
//    
//    static func deviceName() -> String {
//        return (MemoryCard.sharedInstance.playerData.deviceName ?? "Unknown").replacingOccurrences(of: ":", with: ";")
//    }
//    
//    static func canSendEvents() -> Bool {
//        
//        if let alias = MemoryCard.sharedInstance.playerData.name {
//            if ["", "PabloHenri91", "Carolkarlinski"].contains(alias) {
//                return false
//            }
//        } else {
//            return false
//        }
//        
//        #if DEBUG || !os(iOS)
//            return false
//        #else
//            return true
//        #endif
//    }
//}
//
//#if os(OSX)
//    class Answers {
//        
//        open class func logContentView(withName contentNameOrNil: String?, contentType contentTypeOrNil: String?, contentId contentIdOrNil: String?, customAttributes customAttributesOrNil: [String : Any]? = nil) {
//            
//        }
//        
//        open class func logLevelStart(_ levelNameOrNil: String?, customAttributes customAttributesOrNil: [String : Any]? = nil) {
//            
//        }
//        
//        open class func logLevelEnd(_ levelNameOrNil: String?, score scoreOrNil: NSNumber?, success levelCompletedSuccesfullyOrNil: NSNumber?, customAttributes customAttributesOrNil: [String : Any]? = nil) {
//            
//        }
//    }
//    
//    class GameAnalytics {
//        
//        open class func addDesignEvent(withEventId eventId: String!) {
//            print(eventId)
//        }
//    }
//#endif
