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
    @State var type = false
    
    var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 192, height: 192)
            
            Button(action: {
                photo = true
                openCameraRoll = false
                type = true
            }, label: {
                Text("Record Video")
                    .frame(width:300, height:50)
            }).sheet(isPresented: $type) {
                ImagePicker(selectedImage: $imageSelected, sourceType: .camera)
            }
            
            Button(action: {
                photo = true
                openCameraRoll = true
                type = false
            }, label: {
                Text("Upload Video")
                    .frame(width:300, height:50)
            }).sheet(isPresented: $openCameraRoll) {
                ImagePicker(selectedImage: $imageSelected, sourceType: .photoLibrary)
            }
        }
    }
}

#Preview {
    Home()
}
