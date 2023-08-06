//
//  RightChatTableViewCell.swift
//  Chatbot
//
//  Created by Khusboo Singh on 06/08/23.
//

import UIKit

class RightChatTableViewCell: UITableViewCell {

    @IBOutlet weak var rightChatMainView: UIView!
    @IBOutlet weak var chatView: UIView!
    @IBOutlet weak var lblChatBot: UILabel!
    @IBOutlet weak var imgChatBot: UIImageView!
    
    var typingIndicatorBottomConstraint: NSLayoutConstraint!
    
    let typingIndicator = TypingIndicatorView(receiverName: "Chatbot")
    
    func createTypingIndicator() {
      self.insertSubview(typingIndicator, belowSubview: self)
      typingIndicatorBottomConstraint = typingIndicator.bottomAnchor.constraint(
        equalTo: self.bottomAnchor,
        constant: 16)
      typingIndicatorBottomConstraint.isActive = true
      NSLayoutConstraint.activate([
        typingIndicator.heightAnchor.constraint(equalToConstant: 20),
        typingIndicator.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25)
      ])
    }
    
    func setTypingIndicatorVisible(_ isVisible: Bool) {
      let constant: CGFloat = isVisible ? -16 : 16
        if isVisible == true {
            rightChatMainView.isHidden = true
            typingIndicator.isHidden = false
        }else {
            rightChatMainView.isHidden = false
            typingIndicator.isHidden = true
            self.contentView.willRemoveSubview(typingIndicator)
        }
      UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: {
        self.typingIndicatorBottomConstraint.constant = constant
        self.layoutIfNeeded()
      })
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        makeRounded()
        createTypingIndicator()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func makeRounded() {
       // imgChatBot.layer.borderWidth = 0.5
        imgChatBot.layer.masksToBounds = false
        imgChatBot.layer.cornerRadius = imgChatBot.frame.height/2
        imgChatBot.clipsToBounds = true
    }
    
}
