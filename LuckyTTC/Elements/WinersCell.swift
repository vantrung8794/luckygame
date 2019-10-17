//
//  WinersCell.swift
//  RandomFace
//
//  Created by TrungNV on 10/16/19.
//  Copyright © 2019 TrungNV. All rights reserved.
//

import UIKit

class WinersCell: UITableViewCell {

    @IBOutlet weak var img_avatar: UIImageView!
    @IBOutlet weak var lblName: UILabel!
//    var didSelect: (() -> Void)?
    
    @IBOutlet weak var subView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        img_avatar.setRadius(img_avatar.frame.height / 2)
        subView.setRadius(8.0)
    }
    
    func configCell(_ data: PersonBO){
        img_avatar.image = data.image
        lblName.text = data.name
    }
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: true)
//        if let select = self.didSelect{
//            select()
//        }
//    }
}
