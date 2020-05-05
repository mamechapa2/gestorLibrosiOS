//
//  FavBookTableViewCell.swift
//  gestorLibros
//
//  Created by user152673 on 5/5/20.
//  Copyright © 2020 Apple Inc. All rights reserved.
//

import UIKit

class FavBookTableViewCell: UITableViewCell {

    @IBOutlet weak var nombreFav: UILabel!
    @IBOutlet weak var imageFav: UIImageView!
    @IBOutlet weak var ratingControlFav: RatingControl!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
