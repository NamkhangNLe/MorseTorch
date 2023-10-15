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
//        let base = [1, 1, 1, 1, 0, 0, 0, 1, 1, 0, 1, 1, 1]
//        let source = base.description
//        var grouping = [source : [base]]
//        
//        pickLightSource(in: grouping)
        
        let vidArr = get3DVideoArray()
        
        for frame in vidArr {
            for row in frame {
                print(row)
            }
        }
        
    }
}

#Preview {
    VideoView()
}
