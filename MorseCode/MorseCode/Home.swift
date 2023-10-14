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
                    //let String path = UIImagePickerController.InfoKey
                } else {
                    Text("Upload Video")
                        .frame(width:300, height:50)
                }
            })
            
        }.sheet(isPresented: $openCameraRoll) {
            ImagePicker(selectedImage: $imageSelected, sourceType: .photoLibrary)
        }
    }
}

#Preview {
    Home()
}


