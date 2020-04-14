//
//  YearDurationLabelCell.swift
//  TMDb
//
//  Created by Bogdan Munteanu on 17/10/2019.
//  Copyright © 2019 Bogdan Munteanu. All rights reserved.
//

import UIKit

class YearDurationLabelCell: UITableViewCell, MovieListing {
    
    @IBOutlet weak var yearAndDurationLabel: UILabel!
    
    var movie: ExtendedMovie! {
        didSet {
            assignLabel()
        }
    }
    
    func assignLabel() {
        yearAndDurationLabel.text = "\(movie.year) - \(String(describing: movie.duration)) min"
    }
}
