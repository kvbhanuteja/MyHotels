//
//  UIButtonExtension.swift
//  MyHotels
//
//  Created by Bhanuteja on 21/07/21.
//

import UIKit


extension UIButton {
    func addRating() {
        self.setImage(UIImage(systemName: Constants.Images.filledStar), for: .normal)
    }
    
    func addBorder() {
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor(named: Constants.Colors.textColor)?.cgColor
        self.layer.cornerRadius = 5
    }
}

extension UIImageView {    
    func addRating() {
        self.image = UIImage(systemName: Constants.Images.filledStar)
    }
    
    func removeRating() {
        self.image = UIImage(systemName: Constants.Images.emptyStar)
    }
}
