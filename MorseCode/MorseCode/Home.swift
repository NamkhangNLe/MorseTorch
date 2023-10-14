//
//  Home.swift
//  MorseCode
//
//  Created by Max Ko on 10/13/23.
//

import SwiftUI
import AVFoundation

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
                    .background(Color.blue)
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
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }).sheet(isPresented: $openCameraRoll) {
                ImagePicker(selectedImage: $imageSelected, sourceType: .photoLibrary, videoSelected: $videoSelected)
            }
            
            Button(action: {
                translate = true
            }, label: {
                Text("Translate Text")
                    .frame(width: 300, height: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            })
    
        }
    }
}

struct Translate: View{
    @State var text = ""
    @State var torchIsOn = false
    let flashDuration = 0.2
    
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
                text = text.morseCode()
                flashLight()
            }, label: {
                Text("Translate")
                    .frame(width: 300, height: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            })
        }
    }
    
    func flashLight() {
        let device = AVCaptureDevice.default(for: AVMediaType.video)
        if (device != nil) {
            do {
                try device!.lockForConfiguration()
                if torchIsOn {
                    device!.torchMode = AVCaptureDevice.TorchMode.off
                    torchIsOn = false
                } else {
                    device!.torchMode = AVCaptureDevice.TorchMode.on
                    torchIsOn = true
                }
                device!.unlockForConfiguration()
            } catch {
                print(error)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + flashDuration) {
                self.flashLight()
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
                morseCode += code + " "
            }
        }
        return morseCode
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
//}
