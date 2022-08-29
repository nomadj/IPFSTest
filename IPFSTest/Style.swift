//
//  Style.swift
//  IPFSTest
//
//  Created by Bryan Albert on 8/28/22.
//

import SwiftUI

struct MyButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(10)
            .font(.headline)
            .background(Color(red: 0, green: 0.7, blue: 0.7))
            .foregroundColor(.white)
            .opacity(1)
            // .clipShape(Capsule())
            .cornerRadius(8)
            .shadow(color: .gray, radius: 5)
    }
}
