/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    Defines the model types that are used throughout the app. This includes
                the dream, creature, and effect types.
*/

import SpriteKit

/**
    The `Dream` type is a value type that contains a description of a dream, the
    creature that you saw in a dream, the effects of that creature, and the number
    of creatures that were in the dream. This type has value semantics which is
    important for "Locality of Reasoning", as described in the accompanying WWDC
    talk.
*/
struct Dream: Equatable {
    // MARK: Types

    enum Creature: Equatable, RawRepresentable {
        enum UnicornColor {
            case yellow, pink, white
        }
        
        typealias RawValue = Int
        
        init?(rawValue: RawValue) {
            switch rawValue {
            case 0 : self = .unicorn(.yellow)
            case 1: self = .unicorn(.pink)
            case 2: self = .unicorn(.white)
            case 3: self = .crusty
            case 4: self = .shark
            case 5: self = .dragon
                
            default: return nil
            }
        }
        
        var rawValue: RawValue {
            switch self {
            case .unicorn(.yellow): return 0
            case .unicorn(.pink): return 1
            case .unicorn(.white): return 2
            case .crusty: return 3
            case .shark: return 4
            case .dragon: return 5
            }
        }

        case unicorn(UnicornColor)
        case crusty
        case shark
        case dragon

        /// Returns the associated image for the creature.
        var image: UIImage {
            let name: String
            switch self {
                case .unicorn(.yellow): name = "unicorn-yellow"
                case .unicorn(.pink): name = "unicorn-pink"
                case .unicorn(.white): name = "unicorn-white"
                case .crusty: name = "crusty"
                case .shark: name = "shark"
                case .dragon: name = "dragon"
            }

            return UIImage(named: name)!
        }

        /// A user-presentable name for the creature.
        var name: String {
            switch self {
                case .unicorn(.yellow): return "Yellow unicorn"
                case .unicorn(.pink): return "Pink unicorn"
                case .unicorn(.white): return "White unicorn"
                case .crusty: return "Crusty"
                case .shark: return "Shark"
                case .dragon: return "Dragon"
            }
            
        }

        /// All creatures so that we can present them in a list.
        static let all: [Creature] = [
            .unicorn(.yellow),
            .unicorn(.pink),
            .unicorn(.white),
            .crusty,
            .shark,
            .dragon
        ]
    }

    /// The `Effect` type adds effect to how the dream is previewed.
    enum Effect: Int {
        case fireBreathing
        case laserFocus
        case magic
        case fireflies
        case rain
        case snow

        /// Returns the particle name specific to the current value.
        var resourceName: String {
            let caseName = "\(self)"

            // Uppercase just the first character in the case name.
            let secondIndex = caseName.index(after: caseName.startIndex)

            let filePrefix = caseName.substring(to: secondIndex).uppercased() + caseName.substring(from: secondIndex)

            return filePrefix + "Particle"
        }

        /// All effects so that we can present them in a list.
        static let all: [Effect] = [
            .fireBreathing,
            .laserFocus,
            .magic,
            .fireflies,
            .rain,
            .snow
        ]

        /// Makes a SpriteKit node based on the kind of effect.
        func makeNode() -> SKNode {
            let node = SKEmitterNode(fileNamed: resourceName)!

            if case .fireBreathing = self {
                node.run(.repeatForever(.sequence([
                    .run({
                        node.particleBirthRate = 300
                    }),
                    .wait(forDuration: 0.35),
                    .run({
                        node.particleBirthRate = 0
                    }),
                    .wait(forDuration: 0.75)
                ])))
            }

            return node
        }
    }

    // MARK: Properties

    var description: String
    var creature: Creature
    var effects: Set<Effect>
    var numberOfCreatures: Int

    init(description: String, creature: Creature, effects: Set<Effect>, numberOfCreatures: Int = 1) {
        self.description = description
        self.creature = creature
        self.effects = effects
        self.numberOfCreatures = numberOfCreatures
    }
    
    public func encode() -> Dictionary<String, AnyObject> {
        
        var dictionary : Dictionary = Dictionary<String, AnyObject>()
        dictionary["description"] = description as AnyObject?
        dictionary["creature"] = NSNumber(value: creature.rawValue) as AnyObject?
        
        
        let effectList : NSMutableArray = [];
        for effect in effects
        {
            effectList.add(NSNumber(value: effect.rawValue))
        }
        
        dictionary["effects"] = effectList
        dictionary["numberOfCreatures"] = NSNumber(value: numberOfCreatures) as AnyObject
        
        
        return dictionary
    }
    
    
    
    
    init(dictionary : Dictionary<String, AnyObject>) {
        self.description = dictionary["description"] as! String
        
        self.creature = Dream.Creature.init(rawValue: Int(dictionary["creature"] as! NSNumber))!
        
        var effects : Set<Dream.Effect> = [];
        for effectNum in dictionary["effects"] as! NSArray
        {
            effects.insert(Effect(rawValue: effectNum as! Int)!) ;
        }
        
        self.effects = effects
        self.numberOfCreatures = Int(dictionary["numberOfCreatures"] as! NSNumber)
    }
    
}

func ==(_ lhs: Dream.Creature, _ rhs: Dream.Creature) -> Bool {
    switch (lhs, rhs) {
        case let (.unicorn(lhsUnicorn), .unicorn(rhsUnicorn)): return lhsUnicorn == rhsUnicorn
        case (.crusty, .crusty): return true
        case (.shark, .shark): return true
        case (.dragon, .dragon): return true

        default: return false
    }
}

func ==(_ lhs: Dream, _ rhs: Dream) -> Bool {
    return lhs.description == rhs.description &&
           lhs.creature == rhs.creature &&
           lhs.effects == rhs.effects &&
           lhs.numberOfCreatures == rhs.numberOfCreatures
}
