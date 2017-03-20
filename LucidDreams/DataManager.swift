//
//  DataManager.swift
//  LucidDreams
//
//  Created by Iryna Didkovska on 3/18/17.
//  Copyright © 2017 Apple, Inc. All rights reserved.
//

import Foundation


class DataManager {
    
    
    
    static func saveModel(model : DreamListViewControllerModel)
    {
        let userDefaults = UserDefaults.standard
        
        var modelToSave = model;
        
        userDefaults.set(modelToSave.encode(), forKey: "Model")
    }
    
    static func getModel() -> DreamListViewControllerModel?
    {
        let userDefaults = UserDefaults.standard
        
        if (userDefaults.object(forKey: "Model") == nil)
        {
            return nil;
        }
        
        let model = DreamListViewControllerModel.init(dictionary: userDefaults.object(forKey: "Model") as! Dictionary<String, AnyObject>)
        
        
        return model
    }
    
    
    static func defaultsDreams() -> [Dream]
    {
        return [
            Dream(description: "Dream 1", creature: .unicorn(.pink), effects: [.fireBreathing]),
            Dream(description: "Dream 2", creature: .unicorn(.yellow), effects: [.laserFocus, .magic], numberOfCreatures: 2),
            Dream(description: "Dream 3", creature: .unicorn(.white), effects: [.fireBreathing, .laserFocus], numberOfCreatures: 3)
        ]
    }

}
