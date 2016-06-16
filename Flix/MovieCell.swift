//
//  MovieCell.swift
//  Flix
//
//  Created by Jeanne Luning Prak on 6/15/16.
//  Copyright © 2016 Jeanne Luning Prak. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {
    @IBOutlet weak var info: UIButton!
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var overview: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
