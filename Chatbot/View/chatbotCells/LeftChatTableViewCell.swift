//
//  LeftChatTableViewCell.swift
//  Chatbot
//
//  Created by Khusboo Singh on 06/08/23.
//

import UIKit

class LeftChatTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImg: UIImageView!
    
    @IBOutlet weak var lblChat: UILabel!
    @IBOutlet weak var chatView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        makeRounded()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func makeRounded() {
        
        //        userImg.layer.borderWidth = 0.5
        userImg.layer.masksToBounds = false
        userImg.layer.cornerRadius = userImg.frame.height/2
        userImg.clipsToBounds = true
        
    }
}

