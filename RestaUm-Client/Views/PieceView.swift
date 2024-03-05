//
//  PieceView.swift
//  RestaUm-Client
//
//  Created by Luiz Sena on 21/02/24.
//

import SwiftUI

struct PieceView: View {

    var isNotEmpty: Bool
    @Binding var isYourTurn: Bool

    var body: some View {
        if isYourTurn {
            Circle()
                .stroke(isNotEmpty ? .clear : .gray , lineWidth: 5)
                .background(Circle().fill(isNotEmpty ? .blue : .clear))
        } else {
            Circle()
                .stroke(isNotEmpty ? .clear : .gray , lineWidth: 5)
                .background(Circle().fill(isNotEmpty ? .gray : .clear))
        }


//            .fill(isEmpty ? .blue : .clear)

//            .stroke(isEmpty ? .clear : .gray, style: .init(lineWidth: 5))


    }
}

#Preview {
    PieceView(isNotEmpty: true, isYourTurn: .constant(false))
}
