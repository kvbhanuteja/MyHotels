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
}

extension UIImageView {    
    func addRating() {
        self.image = UIImage(systemName: Constants.Images.filledStar)
    }
    
    func removeRating() {
        self.image = UIImage(systemName: Constants.Images.emptyStar)
    }
}
