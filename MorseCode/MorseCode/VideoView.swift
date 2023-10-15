//
//  VideoView.swift
//  MorseCode
//
//  Created by Max Ko on 10/14/23.
//

import SwiftUI
import UIKit
import CoreGraphics
import AVFoundation

struct VideoView: View {
    
    var body: some View {
        VStack {
            Button(action: {
                tester()
                print("tried")
            }, label: {
                Text("test")
            }
            )
            
        }
    }
    
    func tester() {
        let base = [0, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1 ,1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1 ,1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0]
        let source = base.description
        let grouping = [source : [base]]
        
        let (signal, dot, bar, short, mid, long) = pickLightSource(in: grouping)
        
        print(signal, dot, bar, short, long)
        let morseCode = translateToMC(signal: signal, dot: dot, bar: bar, short: short, mid: mid, long: long)
        
        print(morseCode)
    }
}

#Preview {
    VideoView()
}
