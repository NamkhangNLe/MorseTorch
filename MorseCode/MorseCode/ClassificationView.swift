//
//  ClassificationView.swift
//  Morse Torch
//
//  Created by Jonathan Huang on 10/15/23.
//

import SwiftUI
import Foundation
import Vision

struct ClassificationView: View {
    var body: some View {
        VStack {
            Button(action: {
                testing()
                print("done test")
            }, label: {
                Text("test")
            })
        }
    }
    
    func testing() {
        let arr = get3DVideoArray()
        let MSarr = makeModemap(in: arr)
    }

}

#Preview {
    ClassificationView()
}
