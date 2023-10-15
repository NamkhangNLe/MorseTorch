//
//  VideoMod.swift
//  MorseCode
//
//  Created by Joseph Masson on 10/14/23.
//

import Foundation
import SwiftUI
import UIKit
import CoreGraphics
import AVFoundation


func get3DVideoArray() -> [[[Int]]] {
    
    guard let videoURL = Bundle.main.url(forResource: "IMG_7605", withExtension: "mov")
    else {
        print("Video file not found.")
        return []
    }
    
    let frames = extract2(from: videoURL)
    var framesArray : [[[Int]]] = []
    
    for uiimg in frames {
        
        if let grayscalePixels = grayscalePixelArray(fromImageNamed: uiimg) {
            framesArray.append(grayscalePixels)
        } else {
            print("Error loading image or extracting pixel data.")
        }
    }
    
    return framesArray
}

func grayscalePixelArray(fromImageNamed imageName: UIImage?) -> [[Int]]? {
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

    var grayscalePixels: [[Int]] = []

    for y in 0..<height {
        var row: [Int] = []
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

func stringToArr(strArr: String) -> [Int] {
    let results = strArr
                  .trimmingCharacters(in: CharacterSet(charactersIn: "[]"))
                  .components(separatedBy:", ")
                  .map { return Int($0.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))!}
    return results
}

func pickLightSource(in lightGroupings: [String : [[Int]]]) -> [Int] {
    var lightSignal: [Int] = []
    var keys = lightGroupings.keys
    
    var idk = [1, 2, 3]
    
    for key in keys {
        
        var freq : [Int : Int] = [:]
        var mode = stringToArr(strArr: key)
        
        var cont = 0
        
        print(mode)
        
        for lightSig in mode {
            print(lightSig)
            if (lightSig == 1) {
                cont += 1
            } else if (cont > 1) {
                if freq.keys.contains(cont) {
                    freq[cont]! += 1
                } else {
                    freq[cont] = 1
                }
                cont = 0
            }
        }
        
        if (cont > 1) {
            if freq.keys.contains(cont) {
                freq[cont]! += 1
            } else {
                freq[cont] = 1
            }
        }
            
        print(freq)
    }
    
    
    return lightSignal
}
