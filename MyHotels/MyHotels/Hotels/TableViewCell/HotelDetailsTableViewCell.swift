//
//  HotelDetailsTableViewCell.swift
//  MyHotels
//
//  Created by Bhanuteja on 20/07/21.
//

import UIKit

class HotelDetailsTableViewCell: UITableViewCell {
    static let cellId = "HotelDetailsTableViewCell"

    @IBOutlet weak var hotelImage: UIImageView!
    @IBOutlet weak var hotelName: UILabel!
    @IBOutlet weak var delete: UIButton!
    @IBOutlet weak var edit: UIButton!
    @IBOutlet weak var oneStar: UIImageView!
    @IBOutlet weak var twoStar: UIImageView!
    @IBOutlet weak var threeStar: UIImageView!
    @IBOutlet weak var fourStar: UIImageView!
    @IBOutlet weak var fiveStar: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUp(data: HotelDetails) {
        
        let images = [oneStar,
                      twoStar,
                      threeStar,
                      fourStar,
                      fiveStar]
        removeRating(images: images)
        for i in 0..<data.rating {
            images[i]?.addRating()
        }
        self.hotelImage.image = data.photo
        self.hotelName.text = data.name
        self.hotelName.sizeToFit()
    }
    
    func removeRating(images: [UIImageView?]) {
        images.forEach { image in
            image?.removeRating()
        }
    }

}
