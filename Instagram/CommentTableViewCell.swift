//
//  CommentTableViewCell.swift
//  Instagram
//
//  Created by 中村 行汰 on 2024/05/20.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    @IBOutlet weak var commentDateLabel: UILabel!
    @IBOutlet weak var commenterNameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
