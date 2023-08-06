//
//  ViewController.swift
//  Chatbot
//
//  Created by Khusboo Singh on 06/08/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var chatview: UIView!
    
    @IBOutlet weak var btnchat: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        btnchat.setTitle("Click to chatbot", for: .normal)
        
        let downArrowViewGesture = UITapGestureRecognizer(target: self, action:  #selector(self.chatbotClicekd))
        downArrowViewGesture.numberOfTapsRequired = 1
        self.btnchat.addGestureRecognizer(downArrowViewGesture)
        self.btnchat.isUserInteractionEnabled = true
        
    }

    @objc func chatbotClicekd(sender : UITapGestureRecognizer) {
        let chatbot = ChatbotVC()
        self.present(chatbot, animated:true, completion:nil)
        
    }
    

}

