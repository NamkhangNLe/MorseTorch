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
                helperLoadImgArray()
                print("tried")
            }, label: {
                Text("test")
            }
            )

        }
    }
    
    func helperLoadImgArray() {
        
        guard let videoURL = Bundle.main.url(forResource: "IMG_7605", withExtension: "mov")
        else {
            print("Video file not found.")
            return
        }
        
        let frames = extract2(from: videoURL)

        for (iframe, uiimg) in frames.enumerated() {
        
            if let grayscalePixels = grayscalePixelArray(fromImageNamed: uiimg) {
                print("frame \(iframe)")
                for (irow, row) in grayscalePixels.enumerated() {
                    print("row \(irow)")
                    print(row)
                }
            } else {
                print("Error loading image or extracting pixel data.")
            }
        }
        
    }
    
    func grayscalePixelArray(fromImageNamed imageName: UIImage?) -> [[UInt8]]? {
        guard let image = imageName else {
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
                    if pixelValue > 200 {
                        row.append(1)
                    } else {
                        row.append(0)
                    }
                }
            }
            grayscalePixels.append(row)
        }
        return grayscalePixels
    }
    
    func extract2(from videoURL: URL) -> [UIImage] {
        var frames: [UIImage] = []

        let asset = AVAsset(url: videoURL)
        let assetDuration = CMTimeGetSeconds(asset.duration)
        let frameRate = 5.0 // set number of fps

        let generator = AVAssetImageGenerator(asset: asset)
        generator.requestedTimeToleranceBefore = CMTime.zero
        generator.requestedTimeToleranceAfter = CMTime.zero

        let frameDuration = CMTimeMake(value: 1, timescale: Int32(frameRate))
        var currentTime = CMTime.zero

        while CMTimeCompare(currentTime, asset.duration) == -1 {
            do {
                let cgImage = try generator.copyCGImage(at: currentTime, actualTime: nil)
                let uiImage = UIImage(cgImage: cgImage)
                frames.append(uiImage)
            } catch {
                print("Error extracting frame at time \(CMTimeGetSeconds(currentTime)): \(error)")
            }

            currentTime = CMTimeAdd(currentTime, frameDuration)
        }

        return frames
    }
}

#Preview {
    VideoView()
}
