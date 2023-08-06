//
//  ChatbotVCViewController.swift
//  Chatbot
//
//  Created by Khusboo Singh on 06/08/23.
//

import UIKit


enum chatType: String, CodingKey {
    case chatbot = "chatbot"
    case user = "user"
}

struct chatbotResponse {
    var session_id = ""
    var chatData = [chatbotData]()
}

struct chatbotData {
    var botResponse = ""
    var userRequest = ""
    var chatType = ""
    var session = ""
}

class ChatbotVC: UIViewController {
    
    @IBOutlet weak var chatbotMainView: UIView!
    @IBOutlet weak var redView: UIView!
    @IBOutlet weak var lblWelcome: UILabel!
    @IBOutlet weak var viewForTableView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewForTextView: UIView!
    @IBOutlet weak var chatTxtView: CommonPlaceHolderTextView!
    @IBOutlet weak var btnSendChat: UIButton!
    @IBOutlet weak var imgChatBot: UIView!
    @IBOutlet weak var txtViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnCancel: UIButton!
    
    
    var chatbotDataStruct = [chatbotData]()
    var currentChatType = chatType.self
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "LeftChatTableViewCell", bundle: nil), forCellReuseIdentifier: "LeftChatTableViewCell")
        tableView.register(UINib(nibName: "RightChatTableViewCell", bundle: nil), forCellReuseIdentifier: "RightChatTableViewCell")
        Styling()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(ChatbotVC.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatbotVC.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue
        
        if self.viewForTableView.bounds.origin.y == 0 {
            self.viewForTableView.bounds.origin.y += keyboardFrame.height
            tableView.contentInset = UIEdgeInsets(top: keyboardFrame.height, left: 0, bottom: 0, right: 0)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.viewForTableView.bounds.origin.y != 0 {
            self.viewForTableView.bounds.origin.y = 0
        }
        tableView.contentInset = .zero
    }
    
    func Styling() {
        let chatbot = chatbotData.init(botResponse: "Hi, How can I assist you today?",userRequest: "",chatType: currentChatType.chatbot.rawValue,session: "")
        chatbotDataStruct.append(chatbot)
        
        btnSendChat.setTitle("", for: .normal)
        btnCancel.setTitle("", for: .normal)
        redView.roundCornerView([.topLeft,.topRight], radius: 15.0)
        
        viewForTableView.roundCornerView([.topLeft,.topRight], radius: 15.0)
        
        btnSendChat.layer.cornerRadius = 15
        btnSendChat.layer.masksToBounds = true
        imgChatBot.layer.cornerRadius = 35
        imgChatBot.layer.masksToBounds = true
        
        viewForTextView.roundCornerView([.topLeft,.topRight,.bottomLeft,.bottomRight], radius: 15)
        viewForTextView.layer.borderWidth = 1
        viewForTextView.layer.borderColor = UIColor.gray.cgColor
        
//        let image = UIImage(named: "imageName")
//        imageView.layer.borderWidth = 1.0
//        imageView.layer.masksToBounds = false
//        imageView.layer.borderColor = UIColor.white.cgColor
//        imageView.layer.cornerRadius = image.frame.size.width / 2
//        imageView.clipsToBounds = true
        
        let origImage = UIImage(named: "send-button")
        validateButton(true)
    }
    
    @IBAction func btnsendChatClicked(_ sender: UIButton) {
        guard let title = self.chatTxtView.text else {
            return
        }
        if !title.isEmpty {
            var chatArr = [chatbotData]()
            let chat = chatbotData.init(botResponse: "" ,userRequest: title,chatType: self.currentChatType.user.rawValue)
            chatArr.append(chat)
            
            if chatbotDataStruct.count > 1 {
                if let session = chatbotDataStruct.last?.session {
                    let chatbot = chatbotData.init(botResponse: "",userRequest: title,chatType: currentChatType.user.rawValue,session: session)
                    chatbotDataStruct.append(chatbot)
                    
                    let chatbot1 = chatbotData.init(botResponse: "Typing",userRequest: "",chatType: currentChatType.chatbot.rawValue,session: "")
                    chatbotDataStruct.append(chatbot1)
                }
            }else {
                let chatbot = chatbotData.init(botResponse: "",userRequest: title,chatType: currentChatType.user.rawValue,session: "")
                chatbotDataStruct.append(chatbot)
                let chatbot1 = chatbotData.init(botResponse: "Typing",userRequest: "",chatType: currentChatType.chatbot.rawValue,session: "")
                chatbotDataStruct.append(chatbot1)
            }
            self.tableView.reloadData()
            
            scrollToBottom()
            validateButton(false)
            
            chatApi(promptMsg: title)
            self.chatTxtView.text = ""
        }
    }
    
    @IBAction func btnCancelClicked(_ sender: Any) {
        dismiss(animated: true)
    }
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.chatbotDataStruct.count-1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    func validateButton(_ interation: Bool) {
        let origImage = UIImage(named: "send-button")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        
        if interation == true {
            btnSendChat.isUserInteractionEnabled = true
            btnSendChat.isEnabled = true
            btnSendChat.setImage(tintedImage, for: .normal)
            btnSendChat.tintColor = .white
            btnSendChat.backgroundColor = .systemRed
        }else {
            btnSendChat.isUserInteractionEnabled = false
            btnSendChat.isEnabled = false
            btnSendChat.setImage(tintedImage, for: .normal)
            btnSendChat.tintColor = .white
            btnSendChat.backgroundColor = .lightGray
        }
    }
    
    // MARK: - services method
    
    
    func chatApi(promptMsg: String) {
        // saveAttachment()
        self.tableView.reloadData()
        let apiManager = ApiManager()
        let url = "https://api.openai.com/v1/chat/completions"
        var username = ""
        var session = ""
        
        if chatbotDataStruct.count > 0 {
            if let sessions = chatbotDataStruct.last?.session {
                session = sessions
            }
        }
       
       // let headerDictionary:NSDictionary = ["tokenId": "1932sd8487d3g487","fromSystem":"app"]
        apiManager.callWebServiceMethodCallWithParameterDictionary(urlString: url, headerDictionary: nil, bodyDictionary: nil , requestType: "POST", sucessHandler: {[unowned self] (response) in
            do {
                
                let responseData = try JSONSerialization.jsonObject(with: response, options: .mutableContainers)
                let responseDictionary = responseData as! NSDictionary
                
                if let status = responseDictionary["status"] as? Int {
                    if status == 200  {
                        DispatchQueue.main.async {
                            print("Request JSON",responseDictionary)
                            
                            var session = ""
                            if let sessionId = responseDictionary["session_id"] as? String {
                                session = sessionId
                            }
                            
                            if let data = responseDictionary["data"] as? [[String:Any]] {
                               
                                self.chatbotDataStruct.removeAll()
                                let chatbot = chatbotData.init(botResponse: "Hi, How can I assist you today?",userRequest: "",chatType: self.currentChatType.chatbot.rawValue,session: "")
                                
                                self.chatbotDataStruct.insert(chatbot, at: 0)
                                for item in data {
                                    if let userchat = item["user"] as? String {
                                        self.chatbotDataStruct.append(chatbotData.init(botResponse: "",userRequest: userchat,chatType: self.currentChatType.user.rawValue,session: session))
                                    }
                                    
                                    if let bot = item["bot"] as? String {
                                        if !bot.isEmpty {
                                            self.chatbotDataStruct.append(chatbotData.init(botResponse: bot,userRequest: "",chatType: self.currentChatType.chatbot.rawValue,session: session))
                                        }
                                    }
                                    
                                }
                                
                                self.tableView.reloadData()
                                self.scrollToBottom()
                                self.validateButton(true)
                                
                            }
                        }
                    }else if status == 400 {
                        DispatchQueue.main.async {
                            if let title = responseDictionary["message"] as? String {
                                
                            }
                        }
                    }
                }
            } catch {
                print(error)
               
            }
            
        }){ (errorMessage) in
           
        }
    }
}
    

extension ChatbotVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatbotDataStruct.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if chatbotDataStruct[indexPath.row].chatType == currentChatType.user.rawValue {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "LeftChatTableViewCell", for: indexPath) as? LeftChatTableViewCell {
                cell.lblChat.text = chatbotDataStruct[indexPath.row].userRequest
                return cell
            }
        }else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "RightChatTableViewCell", for: indexPath) as? RightChatTableViewCell {
                if chatbotDataStruct[indexPath.row].botResponse == "Typing" && chatbotDataStruct[indexPath.row].session == "" {
                    cell.setTypingIndicatorVisible(true)
                }else {
                    cell.lblChatBot.text = chatbotDataStruct[indexPath.row].botResponse
                    cell.setTypingIndicatorVisible(false)
                }
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension ChatbotVC: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        let origImage = UIImage(named: "send-button")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        
        if !textView.text.trimmingCharacters(in: .whitespaces).isEmpty {
            btnSendChat.isEnabled = true
            btnSendChat.setImage(tintedImage, for: .normal)
            btnSendChat.tintColor = .white
            btnSendChat.backgroundColor = .systemRed
        }else {
            btnSendChat.isEnabled = false
            btnSendChat.setImage(tintedImage, for: .normal)
            btnSendChat.tintColor = .white
            btnSendChat.backgroundColor = .lightGray
        }
        
       
    }
 
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
