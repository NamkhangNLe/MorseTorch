//
//  Home.swift
//  MorseCode
//
//  Created by Max Ko on 10/13/23.
//

import SwiftUI



struct Home: View {
    
    @State var photo = false
    @State var openCameraRoll = false
    @State var imageSelected = UIImage()
    
    var body: some View {
        VStack {
            Rectangle()
                .frame(width:300, height: 500)
            Rectangle()
                .frame(width:300, height: 50)
            Button(action: {
                photo = true
                openCameraRoll = true
            }, label: {
                if photo {
                    Image(uiImage: imageSelected)
                        .frame(width:300, height:50)
                } else {
                    Rectangle()
                        .frame(width:300, height:50)
                }
            })
            
        }.sheet(isPresented: $openCameraRoll) {
            ImagePicker(sourceType: .photoLibrary)
        }
    }
}

#Preview {
    Home()
}


