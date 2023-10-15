//
//  VideoView.swift
//  MorseCode
//
//  Created by Max Ko on 10/14/23.
//

import SwiftUI
import UIKit
import CoreGraphics

struct VideoView: View {

    var body: some View {
        VStack {
            Button(action: {
                helperLoadImgArray()
                print("tried")
            }, label: {
                Text("test")
            }
            )

        }
    }
    
    func helperLoadImgArray() {
        
        if let grayscalePixels = grayscalePixelArray(fromImageNamed: "tiny") {
            for row in grayscalePixels {
                print(row)
            }
        } else {
            print("Error loading image or extracting pixel data.")
        }
        
    }
    
    func grayscalePixelArray(fromImageNamed imageName: String) -> [[UInt8]]? {
        guard let image = UIImage(named: imageName) else {
            // Handle image loading error
            print("UI Image error")
            return nil
        }

        guard let cgImage = image.cgImage else {
            // Handle image conversion error
            print("CG Image error")
            return nil
        }

        let width = cgImage.width
        let height = cgImage.height

        guard let context = CGContext(
            data: nil,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: width,
            space: CGColorSpaceCreateDeviceGray(),
            bitmapInfo: CGImageAlphaInfo.none.rawValue
        ) else {
            print("context creation error")
            return nil
        }

        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))

        var grayscalePixels: [[UInt8]] = []

        for y in 0..<height {
            var row: [UInt8] = []
            for x in 0..<width {
                if let pixelData = context.data {
                    let offset = 1 * (width * y + x)
                    let pixelValue = pixelData.load(fromByteOffset: offset, as: UInt8.self)
                    row.append(pixelValue)
                }
            }
            grayscalePixels.append(row)
        }
        return grayscalePixels
    }
    
}

#Preview {
    VideoView()
}
