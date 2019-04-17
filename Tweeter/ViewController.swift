//
//  ViewController.swift
//  Tweeter
//
//  Created by Nach on 14/4/19.
//  Copyright © 2019 Edenred. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    
    @IBOutlet weak var contentScrollView: UIScrollView!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var messageTextView: UITextView!
    
    @IBOutlet weak var messageTableView: UITableView!
    
    var messageArray : NSMutableArray = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.lblUserName.text = "Test User"
        self.lblUserName.textColor = UIColor.white
        self.lblUserName.font = Constants.FontConstants.bold_header
        
        self.userImageView.layer.cornerRadius = 35/2
        self.userImageView.layer.masksToBounds = true
        
        self.messageTextView.delegate = self
        self.messageTextView.font = Constants.FontConstants.message_font
        
        self.btnSend.layer.cornerRadius = self.btnSend.frame.height / 2
        self.btnSend.layer.masksToBounds = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification:NSNotification){
        let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        
        self.contentScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize!.height, right: 0)
        self.contentScrollView.setContentOffset(CGPoint(x: 0, y: keyboardSize!.height), animated: true)
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        self.contentScrollView.contentInset = UIEdgeInsets.zero
        self.contentScrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }

    @IBAction func sendPressed(_ sender: UIButton) {
        self.messageTextView.resignFirstResponder()
        
        guard let messageString = self.messageTextView.text else {
            return
        }
        
        if !messageString.isEmpty {
            if messageString.count > 50 {
                if messageString.contains(" ") || messageString.contains("\n") {
                    self.messageArray.addObjects(from: splitMessage(messageString))
                } else {
                    showAlert("The message entered is more than 50 letters")
                    return
                }
            } else {
                self.messageArray.add(messageString)
            }
            
            self.messageTableView.reloadData()
            if self.messageArray.count > 1 {
                self.messageTableView.scrollToRow(at: IndexPath.init(row: self.messageArray.count - 1, section: 0) as IndexPath, at: .top, animated: true)
            }
            self.messageTextView.text = ""
        } else {
            showAlert("Empty Message")
        }
    }
    
    func showAlert(_ alertMessage : String) {
        let alertController = UIAlertController(title: "", message:
            alertMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func splitMessage(_ messageString:String) -> [String] {
        var messages : [String] = []
        var messagesToBeDisplayed : [String] = []
        
        let messageArray:[String] = messageString.components(separatedBy: [" " , "\n"])
        var stringUnderConstruction = ""
       
        for messageComponent in messageArray {
            if stringUnderConstruction.count + messageComponent.count <= 45 {
                if stringUnderConstruction.isEmpty {
                    stringUnderConstruction = messageComponent
                } else {
                    stringUnderConstruction += " " + messageComponent
                }
            } else {
                messages.append(stringUnderConstruction)
                stringUnderConstruction = messageComponent
            }
        }
        
        if !stringUnderConstruction.isEmpty {
            messages.append(stringUnderConstruction)
        }
        
        var count = 1
        let messagesCount = messages.count
        for message in messages {
            messagesToBeDisplayed.append("\(count)/\(messagesCount) \(message)")
            count += 1
        }
        
        return messagesToBeDisplayed
    }
    
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageContentViewCell",for: indexPath) as UITableViewCell
        
        let messageLabel:UITextView = cell.viewWithTag(999) as! UITextView
        messageLabel.text = self.messageArray.object(at: indexPath.row) as? String
        messageLabel.textColor = UIColor.white
        messageLabel.font = Constants.FontConstants.message_font
        
        messageLabel.layer.cornerRadius = 15
        messageLabel.layer.masksToBounds = true
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension ViewController : UITextViewDelegate {
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        self.messageTextView.resignFirstResponder()
        return true
    }
    
}
