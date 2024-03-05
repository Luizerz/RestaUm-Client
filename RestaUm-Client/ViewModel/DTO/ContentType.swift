//
//  ContentType.swift
//  RestaUm-Client
//
//  Created by Luiz Sena on 03/03/24.
//

import Foundation

enum ContentType: Codable {
    //To Client DTO
    case ChatTextToClient
    case GameBoardToClient
    case PlayResponseToClient
    case NumberOfPlayerToClient
    case TurnToClient
    case Lose
    case Win
    //To Server DTO
    case ChatTextToServer
    case PlayToServer
}
