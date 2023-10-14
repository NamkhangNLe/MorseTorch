//
//  Home.swift
//  MorseCode
//
//  Created by Max Ko on 10/13/23.
//

import SwiftUI

struct AppContentView: View {
    @State var videoSelected = false
    @State var translate = false
    
    var body: some View{
        return Group {
            if videoSelected {
                Display()
            } else if translate {
                Translate()
            }
            else {
                Home(videoSelected: $videoSelected, translate: $translate)
            }
        }
    }
}

struct Home: View {
    @Binding var videoSelected: Bool
    @Binding var translate: Bool
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
                //videoSelected = true
            }, label: {
                Text("Record Video")
                    .frame(width:300, height:50)
            }).sheet(isPresented: $type) {
                ImagePicker(selectedImage: $imageSelected, sourceType: .camera, videoSelected: $videoSelected)
            }
            
            Button(action: {
                photo = true
                openCameraRoll = true
                type = false
                
            }, label: {
                Text("Upload Video")
                    .frame(width:300, height:50)
            }).sheet(isPresented: $openCameraRoll) {
                ImagePicker(selectedImage: $imageSelected, sourceType: .photoLibrary, videoSelected: $videoSelected)
            }
            
            Button(action: {
                translate = true
            }, label: {
                Text("Create Morse Code")
                    .frame(width: 300, height: 50)
            })
    
        }
    }
}

struct Translate: View{
    @State var text = ""
    
    var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 48, height: 48)
            TextField("Enter text to translate", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button(action: {
                // Save the entered text for later use
                UserDefaults.standard.set(text, forKey: "textToTranslate")
            }, label: {
                Text("Translate Text")
                    .frame(width: 300, height: 50)
            })
        }
    }
}


struct Display: View {
    var body: some View {
        VStack{
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 48, height: 48)
            Text("Output Text")
                .frame(width: 400, height: 200)
        }
    }
}

//#Preview {
//    Home()
//}
