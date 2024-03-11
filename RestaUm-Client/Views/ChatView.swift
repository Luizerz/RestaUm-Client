//
//  ChatView.swift
//  RestaUm-Client
//
//  Created by Luiz Sena on 04/03/24.
//

import SwiftUI

struct ChatView: View {
    @Binding var chatMessages: [ChatModel]
    @State var message: String = ""
    var onSend: (String) -> ()
    var body: some View {
        ZStack {
            Color.gray.opacity(0.65)
                .ignoresSafeArea()
            VStack {
                ScrollView(.vertical) {
                    VStack {
                        ForEach(chatMessages, id: \.hashValue) { msg in
                            HStack(spacing: 5){
                                Text("\(msg.messageType.rawValue): ")
                                    .fontWeight(.bold)
                                Text(msg.message)
                            }
                            .padding([.top, .bottom], 2.5)
                        }
                    }
                    .frame(width: 350, height: 300)
                }
                .frame(width: 350, height: 300)
                .background {
                    RoundedRectangle(cornerRadius: 15.0)
                        .fill(.thinMaterial)
                }
                HStack {
                    TextField("Escreva sua mensagem", text: $message)
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 15.0)
                                .fill(.ultraThinMaterial)
                        }
                    Button("Send") {
                        chatMessages.append(ChatModel(messageType: .Myself, message: self.message))
                        onSend(self.message)
                        self.message = ""
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding()
        }


    }
}

//#Preview {
//    ChatView(chatMessages: [])
//}
