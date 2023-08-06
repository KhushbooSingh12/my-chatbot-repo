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
        btnchat.setTitle("", for: .normal)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(clickChatbot(_:)))
        chatview.isUserInteractionEnabled = true
        chatview.addGestureRecognizer(tap)
        
    }

    @objc func clickChatbot(_ sender: UITapGestureRecognizer) {
        
    }
    

}

