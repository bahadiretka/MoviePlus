//
//  SmallCollectionViewCell.swift
//  Movie+
//
//  Created by Bahadır Etka Kılınç on 25.06.2024.
//

import UIKit

class SmallCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var movieType: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
