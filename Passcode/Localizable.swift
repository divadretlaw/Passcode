//
//  Localizable.swift
//  Localizable
//
//  Created by David Walter on 02.02.18.
//  Copyright © 2018 David Walter. All rights reserved.
//

import UIKit

func Localized(_ key: String, comment: String = "") -> String {
    return NSLocalizedString(key, tableName: "Localizable", bundle: Bundle(for: Passcode.self), comment: comment)
}

extension UILabel {
    
    @IBInspectable
    public var LocalizedText: String {
        get {
            return ""
        }
        set {
            self.text = Localized(newValue)
        }
    }
    
}

extension UIButton {
    
    @IBInspectable
    public var LocalizedTitle: String {
        get {
            return ""
        }
        set {
            self.setTitle(Localized(newValue), for: .normal)
        }
    }
    
}
