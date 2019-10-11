//
//  TitleLable.swift
//  TMDb
//
//  Created by Bogdan Munteanu on 19/09/2019.
//  Copyright © 2019 Bogdan Munteanu. All rights reserved.
//

import UIKit

@IBDesignable
class TitleLable: UILabel {

    @IBInspectable
    var color: UIColor? {
        didSet {
            textColor = color
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textColor = .red
        font = UIFont.systemFont(ofSize: 20)
    }
}
