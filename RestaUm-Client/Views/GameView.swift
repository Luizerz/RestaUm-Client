//
//  ContentView.swift
//  RestaUm-Client
//
//  Created by Luiz Sena on 16/02/24.
//

import SwiftUI

struct GameView: View {
    @ObservedObject var viewModel: WebSocket
    let ipAdress: String

    var body: some View {
        if viewModel.countOfPlayers != 2 {
            Text("Waiting for your oponent")
                .onAppear {
                    viewModel.startWebSocket(ipAdress)
                }
                .navigationBarBackButtonHidden(true)
        } else {
            ZStack {
                VStack {
                    HStack {
                        NavigationLink("Chat 💬") {
                            ChatView(chatMessages: $viewModel.chatMessages) { msg in
                                viewModel.sendMessage(msg)
                            }
                        }
                        Button("Surrender 🏳️") {
                            viewModel.sendData(DataWrapper(data: Data(), contentType: .SurrenderToServer))
                        }
                    }
                    .padding(.top, 25)
                    Spacer()
                }
                VStack {
                    Text(viewModel.isYourTurn ? "Seu Turno 🤔" : "Turno do Oponente 🥸")
                        .font(.system(size: 25.0))
                        .foregroundStyle(viewModel.isYourTurn ? .green : .red)

                    ForEach(Array(viewModel.matrix.enumerated()), id: \.offset) { indexI, arr in
                        HStack {
                            ForEach(Array(arr.enumerated()), id: \.offset) { indexJ, item in
                                if let item = item {
                                    PieceView(isNotEmpty: item, isYourTurn: $viewModel.isYourTurn)
                                            .onTapGesture {
                                                print(indexI, indexJ)
                                                viewModel.pieceTap((indexI, indexJ))
                                            }
                                    .frame(maxWidth: 45, maxHeight: 50)
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationBarBackButtonHidden(true)
            .alert(viewModel.alertMessage, isPresented: $viewModel.showAlert) {
                Button("OK!") {}
            }
        }
    }
}

#Preview {
    GameView(viewModel: WebSocket(), ipAdress: "127.0.0.1")
}
