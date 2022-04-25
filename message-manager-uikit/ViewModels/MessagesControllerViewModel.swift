//
//  MessagesControllerViewModel.swift
//  message-manager-uikit
//
//  Created by mainuser on 25.04.2022.
//

import Foundation

protocol MessagesControllerViewModelDelegate {
    func updateMessagesController()
}

class MessagesControllerViewModel {
    
    // MARK: - CONSTANTS
    
    private let MESSAGES_PER_PAGE = 20
    
    // MARK: - PROPERTIES
    
    var delegate: MessagesControllerViewModelDelegate?
    var hasFinished: Bool = false
    
    var messages = [String]() {
        didSet {
            delegate?.updateMessagesController()
        }
    }
    
    // MARK: - FETCH DATA
    
    func fetchMessages() {
        APIService.shared.fetchMessages { result in
            switch result {
            case .success(let newMessages):
                if newMessages.isEmpty || newMessages.count < self.MESSAGES_PER_PAGE {
                    self.hasFinished = true
                }
                self.messages.append(contentsOf: newMessages)
            case .failure(_):
                self.fetchMessages()
            }
        }
    }
    
}
