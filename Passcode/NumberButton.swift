//
//  NumberButton.swift
//  Passcode
//
//  Created by David Walter on 29.01.18.
//  Copyright © 2018 David Walter. All rights reserved.
//

import UIKit

@IBDesignable
class NumberButton: UIButton {

    @IBInspectable
    public var value: String = "" {
        didSet {
            border()
        }
    }
    
    public var borderRadius: CGFloat = 30
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = max(frame.width, frame.height) / 2
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        border()
        actions()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        actions()
    }
    
    private func border() {
        layer.borderWidth = 1
        layer.cornerRadius = max(frame.width, frame.height) / 2
        layer.borderColor = UIColor.clear.cgColor
    }
    
    private func actions() {
        addTarget(self, action: #selector(handleTouchDown), for: .touchDown)
        addTarget(self, action: #selector(handleTouchUp), for: [.touchUpInside, .touchDragOutside, .touchCancel])
    }
    
    @objc func handleTouchDown() {
        var rgb: (red: CGFloat, green: CGFloat, blue: CGFloat) = (0, 0, 0)
        tintColor.getRed(&rgb.red, green: &rgb.green, blue: &rgb.blue, alpha: nil)
        animate(title: UIColor(red: 1 - rgb.red, green: 1 - rgb.green, blue: 1 - rgb.blue, alpha: 1.0), back: tintColor)
    }
    
    @objc func handleTouchUp() {
        animate(title: tintColor, back: nil)
    }
    
    private func animate(title: UIColor?, back: UIColor?) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
            self.setTitleColor(title, for: .normal)
            self.backgroundColor = back
        })
    }
}
