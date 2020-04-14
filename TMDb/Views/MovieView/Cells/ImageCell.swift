//
//  ImageCell.swift
//  TMDb
//
//  Created by Bogdan Munteanu on 17/10/2019.
//  Copyright © 2019 Bogdan Munteanu. All rights reserved.
//

import UIKit

class ImageCell: UITableViewCell, MovieListing {
    
    @IBOutlet weak var posterImage: UIImageView!
    
    var movie: ExtendedMovie! {
        didSet {
            assignImage()
        }
    }
    
    func assignImage() {
        posterImage.image = movie.poster
    }
    
}
