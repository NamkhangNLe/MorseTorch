//
//  Home.swift
//  MorseCode
//
//  Created by Max Ko on 10/13/23.
//

import SwiftUI

struct Home: View {
    var body: some View {
        VStack {
            Rectangle()
                .frame(width:300, height: 500)
            Rectangle()
                .frame(width:300, height: 50)
            HStack {
                Circle()
                    .frame(width:100, height: 100)
                Circle()
                    .frame(width:100, height: 100)
            }
        }
    }
}

#Preview {
    Home()
}
