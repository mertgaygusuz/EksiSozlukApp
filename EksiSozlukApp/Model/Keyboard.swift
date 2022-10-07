//
//  Keyboard.swift
//  EksiSozlukApp
//
//  Created by Mert Gaygusuz on 7.10.2022.
//

import Foundation
import UIKit

extension UIView {
    
    func setKeyboard() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(setKeyboardPosition(_ :)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc private func setKeyboardPosition(_ notification : NSNotification) {
        
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        let startingFrame = (notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let endFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let differenceY = endFrame.origin.y - startingFrame.origin.y
        
        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIView.KeyframeAnimationOptions.init(rawValue: curve) ,animations: {
            self.frame.origin.y += differenceY
        }, completion: nil)
    }
}
