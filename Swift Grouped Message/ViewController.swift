//
//  ViewController.swift
//  Swift Grouped Message
//
//  Created by Kadir Kutluhan Alev on 6.09.2020.
//  Copyright © 2020 Kadir Kutluhan Alev. All rights reserved.
//

import UIKit

struct ChatMessage {
    let text: String
    let isIncoming: Bool
    let date: Date
}

extension Date {
    static func dateFromCustomString(customString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.date(from: customString) ?? Date()
    }
}

class ViewController: UITableViewController {
    
    private let cellId = "id"

    
    let chatMessagesFromServer = [
        ChatMessage(text: "Hey Im Kadir", isIncoming: true, date: Date.dateFromCustomString(customString: "08/03/2018")),
        ChatMessage(text: "I'm going to message another long message that will word wrap", isIncoming: true, date: Date.dateFromCustomString(customString: "08/03/2018")),
        ChatMessage(text: "I'm going to message another long message that will word wrap, I'm going to message another long message that will word wrap,I'm going to message another long message that will word wrap.I'm going to message another long message that will word wrap", isIncoming: false, date: Date.dateFromCustomString(customString: "09/03/2018")),
        ChatMessage(text: "Here is my very first message", isIncoming: false, date: Date.dateFromCustomString(customString: "10/03/2018")),
        ChatMessage(text: "Yo this is a short message", isIncoming: true, date: Date.dateFromCustomString(customString: "12/03/2018")),
        ChatMessage(text: "Third Section message", isIncoming: true, date: Date.dateFromCustomString(customString: "14/03/2018"))
    ]
    
    var chatMessages = [[ChatMessage]]()
    
    fileprivate func attemptToAssembleGroupedMessages() {
        
        // BU FONKSIYON GELEN DICTIONARY İ BELLİ BİR PROPERTY E GÖRE GRUPLAMAYI SAĞLAR.
        let groupedMessages = Dictionary(grouping: chatMessagesFromServer) { (element) -> Date in
            return element.date
        }
        //BU OZELLIGIN KOTU TARAFI ORDER OLMADAN RASTGELE ATAMA YAPAR.
        // BU YUZDEN EGER ISTERSEK KEY İÇİN BİR SIRALAMA KULLANABİLİRİZ.
        let sortedKeys = groupedMessages.keys.sorted()
        sortedKeys.forEach { (key) in
            let values = groupedMessages[key]
            chatMessages.append(values ?? [])
        }
//        groupedMessages.keys.forEach { (key) in
//            print(key)
//            let values = groupedMessages[key]
//            print(values ?? "")
//
//            chatMessages.append(values ?? [])
//        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        attemptToAssembleGroupedMessages()
        navigationItem.title = "Messages"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.register(ChatMessageCell  .self, forCellReuseIdentifier: cellId)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessages[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChatMessageCell
        let chatMessage = chatMessages[indexPath.section][indexPath.row]
        cell.chatMessage = chatMessage
        cell.selectionStyle = .none
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return chatMessages.count
    }
    
    class DateHeaderLabel: UILabel {
        override var intrinsicContentSize: CGSize {
            let origininalContentSize = super.intrinsicContentSize
            let height = origininalContentSize.height + 12
            layer.cornerRadius = height / 2
            layer.masksToBounds = true
            return CGSize(width: origininalContentSize.width + 20 , height: origininalContentSize.height + 12)
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let firstMessageInSection = chatMessages[section].first {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let dateString = dateFormatter.string(from: firstMessageInSection.date)
            let label = DateHeaderLabel()
            label.backgroundColor = .black
            label.text = dateString
            label.textColor = .white
            label.textAlignment = .center
            label.font = UIFont.boldSystemFont(ofSize: 14)
            label.translatesAutoresizingMaskIntoConstraints = false
                   
                   
            let containerView = UIView()
            containerView.addSubview(label)
            label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
            label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
            return containerView
        }
       return nil
    }
}

