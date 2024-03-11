//
//  WebSocket.swift
//  RestaUm-Client
//
//  Created by Luiz Sena on 21/02/24.
//

import Foundation

class WebSocket: ObservableObject {
    @Published var matrix: [[Bool?]] = []
    @Published var countOfPlayers: Int = 0
    @Published var isYourTurn: Bool = false
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false
    @Published var chatMessages: [ChatModel] = []
    private var choiceArr: [(Int, Int)] = []
    private var webSocketTask: URLSessionWebSocketTask?


    func startWebSocket(_ ipAdress: String) {
        self.connect(ipAdress: ipAdress)
    }

    internal func connect(ipAdress: String) {

        guard let url = URL(string: "ws://\(ipAdress):8080/game") else { return }
        let request = URLRequest(url: url)
        webSocketTask = URLSession.shared.webSocketTask(with: request)
        webSocketTask?.resume()
        reciveMessage()
    }

    internal func reciveMessage() {
        webSocketTask?.receive(completionHandler: { result in
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    DispatchQueue.main.async {
                        self.chatMessages.append(ChatModel(messageType: .Oponent, message: text))
                    }
                case .data(let data):
                    let decodedData = try! JSONDecoder().decode(DataWrapper.self, from: data)
                    print(decodedData.contentType)
                    self.verifyDTO(dataWrapper: decodedData)
                @unknown default:
                    break
                }
            case .failure(let failure):
                print(failure.localizedDescription)
                return
            }
            self.reciveMessage()
        })

    }

    func pieceTap(_ position: (Int, Int)) {
        if isYourTurn {
            self.choiceArr.append(position)
            if choiceArr.count == 2 {
                validateMoviment(from: choiceArr[0], to: choiceArr[1])
            }
        }
    }

    func sendMessage(_ message: String) {
        guard let _ = message.data(using: .utf8) else { return } // Data
        webSocketTask?.send(.string(message)) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }

    func sendData(_ data: DataWrapper) {
        let encoded = try! JSONEncoder().encode(data)
        webSocketTask?.send(.data(encoded)) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }

    private func validateMoviment(from: (Int, Int), to: (Int, Int)) {
        if (from.0 == to.0 && (to.1 - from.1) == 2 ) {
            self.moveRight(from: (from.0, from.1))
        } else if (from.0 == to.0 && (from.1 - to.1) == 2) {
            self.moveLeft(from: (from.0, from.1))
        } else if ((to.0 - from.0) == 2 && from.1 == to.1) {
            self.moveDown(from: (from.0, from.1))
        } else if ((from.0 - to.0) == 2 && from.1 == to.1) {
            self.moveUp(from: (from.0, from.1))
        } else {
            print("Movimento Inexistente")
        }
        self.choiceArr = []
    }

    private func verifyDTO(dataWrapper: DataWrapper) {
        DispatchQueue.main.async {
            switch dataWrapper.contentType {
            case .GameBoardToClient:
                let content = try! JSONDecoder().decode([[Bool?]].self, from: dataWrapper.data)
                self.matrix = content
            case .NumberOfPlayerToClient:
                let content = try! JSONDecoder().decode(Int.self, from: dataWrapper.data)
                self.countOfPlayers = content
            case .TurnToClient:
                let content = try! JSONDecoder().decode(Bool.self, from: dataWrapper.data)
                self.isYourTurn = content
            case .PlayResponseToClient:
                let content = try! JSONDecoder().decode([[Bool?]].self, from: dataWrapper.data)
                self.matrix = content
            case .Win:
                self.alertMessage = "Você Venceu!"
                self.showAlert.toggle()
            case .Lose:
                self.alertMessage = "Você Perdeu!"
                self.showAlert.toggle()
            default:
                print("Thats not sopost to be here")
            }
        }
    }

    private func moveRight(from: (Int, Int)) {
        let item = self.matrix[from.0][from.1]
        let rightItem = self.matrix[from.0][from.1 + 1]
        let destinyItem = matrix[from.0][from.1 + 2]

        if item == true && rightItem == true && destinyItem == false {
            self.matrix[from.0][from.1]?.toggle()
            matrix[from.0][from.1 + 1]?.toggle()
            matrix[from.0][from.1 + 2]?.toggle()
            self.isYourTurn.toggle()
            let wrapper = DataWrapper(data: Play(row: from.0, column: from.1, playType: .right).toData(), contentType: .PlayToServer)
            sendData(wrapper)
            print("Jogada Validada")
        } else {
            print("Jogada Invalidada")
        }
    }

    private func moveLeft(from: (Int, Int)) {
        let item = matrix[from.0][from.1]
        let leftItem = matrix[from.0][from.1 - 1]
        let destinyItem = matrix[from.0][from.1 - 2]

        if item == true && leftItem == true && destinyItem == false {
            matrix[from.0][from.1]?.toggle()
            matrix[from.0][from.1 - 1]?.toggle()
            matrix[from.0][from.1 - 2]?.toggle()
            self.isYourTurn.toggle()
            let wrapper = DataWrapper(data: Play(row: from.0, column: from.1, playType: .left).toData(), contentType: .PlayToServer)
            sendData(wrapper)
            print("Jogada Validada")
        } else {
            print("Jogada Invalidada")
        }
    }
    
    private func moveDown(from: (Int, Int)) {
        let item = matrix[from.0][from.1]
        let bottomItem = matrix[from.0 + 1][from.1]
        let destinyItem = matrix[from.0 + 2] [from.1]

        if item == true && bottomItem == true && destinyItem == false {
            matrix[from.0][from.1]?.toggle()
            matrix[from.0 + 1][from.1]?.toggle()
            matrix[from.0 + 2][from.1]?.toggle()
            self.isYourTurn.toggle()
            let wrapper = DataWrapper(data: Play(row: from.0, column: from.1, playType: .bottom).toData(), contentType: .PlayToServer)
            sendData(wrapper)
            print("Jogada Validada")
        } else {
            print("Jogada Invalida")
        }
    }

    private func moveUp(from: (Int, Int)){
        let item = matrix[from.0][from.1]
        let topItem = matrix[from.0 - 1][from.1]
        let destinyItem = matrix[from.0 - 2][from.1]

        if item == true && topItem == true && destinyItem == false {
            matrix[from.0][from.1]?.toggle()
            matrix[from.0 - 1][from.1]?.toggle()
            matrix[from.0 - 2][from.1]?.toggle()
            self.isYourTurn.toggle()
            let wrapper = DataWrapper(data: Play(row: from.0, column: from.1, playType: .top).toData(), contentType: .PlayToServer)
            sendData(wrapper)
            print("Jogada Validada")
        } else {
            print("Jogada Invalidada")
        }
    }
}
