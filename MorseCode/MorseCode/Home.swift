//
//  Home.swift
//  MorseCode
//
//  Created by Max Ko on 10/13/23.
//

import SwiftUI
import AVFoundation
import Torch

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
        GeometryReader { geo in
            ZStack {
                
                Image("Image 3")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                    .opacity(1.0)
                VStack {
                    Image("logo")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 384, height: 300)
                    Text("""
                     Morse Torch
                    """)
                    .frame(width: 384, height: 80)
                    .font(.system(size: 50))
                    .scaledToFill()
                    
                    Text("Morse to Text")
                        .frame(width: 190, height: 40)
                        .font(.system(size: 25))
                        .scaledToFill()
                        .foregroundColor(.white)
                        .cornerRadius(20)

                    
                    
                    Button(action: {
                        photo = true
                        openCameraRoll = false
                        type = true
                        //videoSelected = true
                    }, label: {
                        Text("Record Video")
                            .frame(width:300, height:50)
                            .background(Color.black.opacity(0.3))
                            .foregroundColor(.white)
                            .cornerRadius(10)
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
                            .background(Color.black.opacity(0.4))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }).sheet(isPresented: $openCameraRoll) {
                        ImagePicker(selectedImage: $imageSelected, sourceType: .photoLibrary, videoSelected: $videoSelected)
                    }
                    
                    Text("Text to Morse")
                        .frame(width: 190, height: 40)
                        .font(.system(size: 25))
                        .scaledToFill()
//                        .background(Color.black.opacity(0.5))
                        .foregroundColor(.white)
                        .cornerRadius(20)
                    
                    Button(action: {
                        translate = true
                    }, label: {
                        Text("Translate Text")
                            .frame(width: 300, height: 50)
                            .background(Color.black.opacity(0.65))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    })
                    Text("-.. . ...- . .-.. --- .--. . -..  ..-. --- .-.  .... .- -.-. -.- --. - -..-")
                        .frame(width: 300, height: 20)
                        .scaledToFit()
                        .font(.system(size: 15))
                    
                    Button(action: {
                        if let url = URL(string: "https://github.com/NamkhangNLe/MorseCode"), UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url)
                        }
                    }, label: {
                        Image("Image 2").resizable().frame(width: 50, height: 50)
                    })
                    
                    
                    
                }
            }
        }
    }
}

struct Translate: View{
    @State var text = ""
    @State var torchIsOn = false
    @State var buttonTapped = false
    @State private var goBack = false

    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                
                Image("Image 3")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                    .opacity(1.0)
                VStack {
                    Image("logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 48, height: 48)
                    
                    TextField("Enter text to translate", text: $text)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .background(Color.gray)
                        .padding()
                    
                    Button(action: {
                        // Save the entered text for later use
                        UserDefaults.standard.set(text, forKey: "textToTranslate")
                        text = text.morseCode()
                        let code = Array(text)
                        for element in code{
                            if (element == ".") {
                                Torch.setTorch(to: 0.5, duration: 0.5)
                                Torch.setTorch(to:0, duration: 0.5)
                            } else if (element == "-") {
                                Torch.setTorch(to: 0.5, duration: 1.5)
                                Torch.setTorch(to:0, duration: 0.5)
                            } else {
                                Torch.setTorch(to: 0, duration: 2)
                            }
                        }
                        buttonTapped = true
                    }, label: {
                        Text("Translate")
                            .frame(width: 300, height: 50)
                            .background(Color.black.opacity(0.3))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }).disabled(buttonTapped)
                    
                    Button {
                        buttonTapped = false
                        text = ""
                    } label: {
                        Text("Reset")
                            .frame(width: 300, height: 50)
                            .background(Color.black.opacity(0.5))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Button {
                        
                        goBack.toggle()
                        Torch.setTorch(to: 0)
                    } label: {
                        Text("Back")
                            .frame(width: 100, height: 50)
                            .background(Color.black.opacity(0.9))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }.fullScreenCover(isPresented: $goBack){
                        AppContentView()
                    }
                    
                }
            }
        }
    }
}
    
    extension String {
        func morseCode() -> String {
            let morseCodeDictionary = [
                "a": ".-",
                "b": "-...",
                "c": "-.-.",
                "d": "-..",
                "e": ".",
                "f": "..-.",
                "g": "--.",
                "h": "....",
                "i": "..",
                "j": ".---",
                "k": "-.-",
                "l": ".-..",
                "m": "--",
                "n": "-.",
                "o": "---",
                "p": ".--.",
                "q": "--.-",
                "r": ".-.",
                "s": "...",
                "t": "-",
                "u": "..-",
                "v": "...-",
                "w": ".--",
                "x": "-..-",
                "y": "-.--",
                "z": "--..",
                "1": ".----",
                "2": "..---",
                "3": "...--",
                "4": "....-",
                "5": ".....",
                "6": "-....",
                "7": "--...",
                "8": "---..",
                "9": "----.",
                "0": "-----",
                " ": "/"
            ]
            
            var morseCode = ""
            for character in self.lowercased() {
                if let code = morseCodeDictionary[String(character)] {
                    morseCode += code
                }
            }
            return morseCode
        }
    }
    
    
    struct Display: View {
        @State private var goBack = false
        
        var body: some View {
            GeometryReader { geo in
                ZStack {
                    
                    Image("Image 3")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                        .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                        .opacity(1.0)            
                    VStack{
                            Image("logo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 48, height: 48)
                            Text("Output Text")
                                .frame(width: 400, height: 200)
                            Button {
                                goBack.toggle()
                            } label: {
                                Text("Back")
                                    .frame(width: 100, height: 50)
                                    .background(Color.black.opacity(0.3))
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }.fullScreenCover(isPresented: $goBack){
                                AppContentView()
                            }
                        }
                    }
                }
            }
        }
