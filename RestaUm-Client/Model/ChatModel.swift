//
//  ChatModel.swift
//  RestaUm-Client
//
//  Created by Luiz Sena on 04/03/24.
//

import Foundation

struct ChatModel: Hashable {
    let messageType: MessageType
    let message: String
}

enum MessageType: String {
    case Myself
    case Oponent
}
