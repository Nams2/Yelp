//
//  SortCell.swift
//  Yelp
//
//  Created by Namrata Mehta on 4/7/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol SortCellDelegate {
    @objc optional func sortCell(sortCell: SortCell, didChangeValue value: Int)
}

class SortCell: UITableViewCell {

    @IBOutlet weak var sortOptionSegment: UISegmentedControl!
    weak var delegate: SortCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        sortOptionSegment.addTarget(self, action: #selector(SortCell.segmentValueChanged), for: UIControlEvents.valueChanged)
    }
    
    func segmentValueChanged() {
        delegate?.sortCell!(sortCell: self, didChangeValue: sortOptionSegment.selectedSegmentIndex)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
