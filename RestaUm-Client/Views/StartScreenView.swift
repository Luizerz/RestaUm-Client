//
//  StartScreenView.swift
//  RestaUm-Client
//
//  Created by Luiz Sena on 21/02/24.
//

import SwiftUI

struct StartScreenView: View {
    
    @State private var ipAdress: String = ""

    var body: some View {
        NavigationStack {
            ZStack {
                background
                VStack {
                    Text("Resta Um")
                        .font(.system(size: 50))
                        .colorInvert()
                    TextField("IpAdress: ", text: $ipAdress)
                        .frame(maxWidth: 250)
                        .padding()
                        .background(.thinMaterial)
                        .keyboardType(.numbersAndPunctuation)
                    NavigationLink {
                        GameView(viewModel: WebSocket(), ipAdress: self.ipAdress)
                    } label: {
                        Text("Entrar no Jogo")
                            .font(.system(size: 25))
                            .padding(10)
                            .background {
                                RoundedRectangle(cornerRadius: 15.0)
                                    .fill(.thinMaterial)
                            }
                    }
                }
            }
        }
    }
    var background: some View {
        Rectangle()
            .fill(.linearGradient(colors: [.purple, .blue, .cyan], startPoint: .top, endPoint: .bottom))
            .ignoresSafeArea()
    }
}

#Preview {
    StartScreenView()
}
