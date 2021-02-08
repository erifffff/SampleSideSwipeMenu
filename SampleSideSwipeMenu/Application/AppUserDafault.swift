//
//  AppUserDafault.swift
//  SampleSideSwipeMenu
//
//  Created by Eri Fujiwara on 2021/01/26.
//  Copyright © 2021 fjwrer_1004. All rights reserved.
//

import Foundation
import UIKit

class AppUserDefault {
    
    /// 背景色
    static var backgroundColor: UIColor? {
        get {
            if let bgcolorData = UserDefaults.standard.data(forKey: "backgroundColor") {
                let bgcolor = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(bgcolorData) as? UIColor
                return bgcolor
            }else{
                return .white
            }
        }
        
        set {
            if let value = newValue {
                if let bgcolorData = try? NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: false) {
                    UserDefaults.standard.set(bgcolorData, forKey: "backgroundColor")
                }
            }
        }
    }
    
    

}
