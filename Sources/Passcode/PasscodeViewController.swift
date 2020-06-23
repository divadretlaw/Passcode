//
//  PasscodeViewController.swift
//  Passcode
//
//  Created by David Walter on 29.01.18.
//  Copyright © 2018 David Walter. All rights reserved.
//

import UIKit
import LocalAuthentication
import Security

public enum PasscodeType {
    case authenticate
    case askCode
    case changeCode
}

class PasscodeViewController: UIViewController {
    
    var config: PasscodeConfig!
    var type = PasscodeType.authenticate
    
    var compareCode: String?
    var code = "" {
        didSet {
            var count = 0
            
            for view in self.codeView.arrangedSubviews {
                if let view = view as? PasscodeCharacter {
                    view.value = count < code.count
                    count += 1
                }
            }
            
            guard self.code.count == 4 else { return }
            
            switch type {
            case .authenticate, .askCode:
                if code == self.config.passcodeGetter() {
                    self.dismiss(success: true)
                } else {
                    self.displayError()
                }
            case .changeCode:
                if compareCode == nil {
                    compareCode = code
                    self.resetCode()
                    UILabel.animate(withDuration: 0.3, animations: { self.codeReenterLabel.alpha = 1.0 })
                    return
                } else {
                    if compareCode == code {
                        self.config.passcodeSetter(code)
                        self.dismiss(success: true)
                    } else {
                        self.displayError()
                    }
                }
            }
        }
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var codeView: UIStackView!
    @IBOutlet weak var codeReenterLabel: UILabel!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var biometricsButton: UIButton!
    
    @IBOutlet weak var blurView: UIVisualEffectView!

    // MARK: - Callbacks
    
    var authenticatedCompletion: ((Bool) -> Void)?
    var dismissCompletion: (() -> Void)?
    
    // MARK: - View Cycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        switch type {
        case .changeCode:
            self.codeLabel.text = Localized("passcodeNew")
        case .askCode:
            self.codeLabel.text = Localized("passcodeText")
        default:
            self.codeLabel.text = Localized("passcodeText")
            self.cancelButton.isHidden = true
            self.biometricsButton.isHidden = !self.config.biometricsGetter()
        }
        
        // Config
        self.codeReenterLabel.text = Localized("passcodeReenter")
        self.biometricsButton.setTitle(self.config.biometrics, for: .normal)
        
        // Colors
        self.codeLabel.textColor = self.config.colors.text
        self.codeView.tintColor = self.config.colors.mainTint
        self.codeReenterLabel.textColor = self.config.colors.text
        
        self.cancelButton.setTitleColor(self.config.colors.mainTint, for: .normal)
        self.biometricsButton.setTitleColor(self.config.colors.biometrics.0, for: .normal)
        self.biometricsButton.backgroundColor = self.config.colors.biometrics.1
        self.blurView.effect = UIBlurEffect(style: self.config.colors.dark ? .dark : .light)

        PasscodeCharacter.appearance().tintColor = self.config.colors.mainTint
        NumberButton.appearance().tintColor = self.config.colors.buttonTint
        
        UIButton.appearance(whenContainedInInstancesOf: [PasscodeViewController.self]).tintColor = self.config.colors.buttonTint
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.config.colors.dark ? .lightContent : .default
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
		if self.config.autoBiometrics {
        	self.biometrics()
		}
    }
    
    // MARK: - Helpers
    
    func resetCode() {
        self.code = ""
    }
    
    public func dismiss(success: Bool) {
        if let dismissCompletion = dismissCompletion {
            dismissCompletion()
            self.authenticatedCompletion?(success)
        } else {
            self.dismiss(animated: true) {
                self.authenticatedCompletion?(success)
            }
        }
    }
    
    func displayError() {
        self.view.isUserInteractionEnabled = false
        let animation = CABasicAnimation(keyPath: "position")
        animation.autoreverses = true
        animation.duration = 0.1
        animation.isRemovedOnCompletion = true
        animation.repeatCount = 2
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.codeView.center.x - 10, y: self.codeView.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.codeView.center.x + 10, y: self.codeView.center.y))
        
        self.codeView.layer.add(animation, forKey: animation.keyPath)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + animation.duration * Double(animation.repeatCount + 1)) {
            self.code = ""
            self.view.isUserInteractionEnabled = true
        }
    }

    // MARK: - IBActions
    
    @IBAction func didPress(button: UIButton) {
        guard let button = button as? NumberButton else {
            self.code = String(self.code.dropLast(1))
            return
        }
        
        code.append(button.value)
    }
    
    @IBAction func cancel(_ sender: AnyObject?) {
        self.code = ""
        self.dismiss(success: false)
    }
    
    @IBAction func biometrics(_ sender: AnyObject? = nil) {
        guard self.config.foreground, !self.biometricsButton.isHidden else { return }
        
        let context = LAContext()
        context.localizedFallbackTitle = Localized("biometricsFallback")
        var error: NSError?
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error),
        let reason = self.config.reason else {
            let alert = UIAlertController(title: Localized("Error"), message: error?.localizedDescription, preferredStyle: .alert)
            alert.view.tintColor = self.config.colors.mainTint
            alert.addAction(UIAlertAction(title: Localized("OK"), style: .cancel, handler: { _ in }))
            self.present(alert, animated: true)
            return
        }
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
            if success {
                self.dismiss(success: true)
            } else {
                print(error ?? "error")
            }
        }
    }
}
