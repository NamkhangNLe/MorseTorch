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

func getDotBarDuration(freq: [Int : Int], largest: Int) -> (Double, Double) {
    
    var dot = 0.0
    var bar = 0.0
    var doneDot = false
    
    var total = 0.0
    var count = 0.0
    var started = false
    
    let leniancy = 1
    var skips = 0
    
    
    for i in 1...largest {
        if freq.keys.contains(i) {
            
            started = true
            total += Double(i * freq[i]!)
            count += Double(freq[i]!)
            skips = 0
        
        } else if (started) {
            // count continuous skips only
            skips += 1
        }
        
        // calculate dot
        if skips > leniancy{
            
            if doneDot {
                break
            }
            
    
            dot = (total / count)
            
            // reset for bar
            total = 0.0
            count = 0.0
            skips = 0
            started = false
            
            //break next time
            doneDot = true
        }
    }
    
    bar = (total / count)
    
    return (dot, bar)
}

func pickLightSource(in lightGroupings: [String : [[Int]]]) -> ([Int], Double, Double, Double, Double, Double) {
    var lightSignal: [Int] = []
    
    let keys = lightGroupings.keys
    
    var bestRelativeScore = 0.0
    
    var bestRelativeDot = 0.0
    var bestRelativeBar = 0.0
    
    var bestShortPause = 0.0
    var bestLongPause = 0.0
    var bestMidPause = 0.0
    
            
    for key in keys {
        
        var onfreq : [Int : Int] = [:]
        let mode = stringToArr(strArr: key)
        
        var contOn = 0
        var largestOn = 0
        
        var offfreq : [Int : Int] = [:]
        var contOff = 0
        var largestOff = 0
        
        // get freq list
        
        for lightSig in mode {
            if (lightSig == 1) {
                contOn += 1
            } else if (contOn > 1) {
                if onfreq.keys.contains(contOn) {
                    onfreq[contOn]! += 1
                } else {
                    onfreq[contOn] = 1
                }
                largestOn = max(largestOn, contOn)
                contOn = 0
            }
            
            if (lightSig == 0) {
                contOff += 1
            } else if (contOff > 1) {
                if offfreq.keys.contains(contOff) {
                    offfreq[contOff]! += 1
                } else {
                    offfreq[contOff] = 1
                }
                largestOff = max(largestOff, contOff)
                contOff = 0
            }
            
        }
        
        // add last key if end in 1
        
        if (contOn > 1) {
            if onfreq.keys.contains(contOn) {
                onfreq[contOn]! += 1
            } else {
                onfreq[contOn] = 1
            }
        }
        
        if (contOff > 1) {
            if offfreq.keys.contains(contOff) {
                offfreq[contOff]! += 1
            } else {
                offfreq[contOff] = 1
            }
        }
                
        // calculate the dot and bar
        let (dot, bar) = getDotBarDuration(freq: onfreq, largest: largestOn)
        
        // calculate pauses
        let (short, mid, long) = getPauses(freq: offfreq, largest: largestOff)
        // got the bar and dot frequency
        
        let relative = bar / dot
        
        if abs(relative - 3) < abs(bestRelativeScore - 3) {
            bestRelativeScore = relative
            bestRelativeBar = bar
            bestRelativeDot = dot
            lightSignal = mode
            bestShortPause = short
            bestLongPause = long
            bestMidPause = mid
        }
    }

    return (lightSignal, bestRelativeDot,bestRelativeBar, bestShortPause, bestMidPause, bestLongPause)
}

func getPauses(freq: [Int : Int], largest: Int) -> (Double, Double, Double) {
    
    var short = 0.0
    var long = 0.0
    var mid = 0.0

    var shortDone = false
    var midDone = false
    
    var total = 0.0
    var count = 0.0
    var started = false
    
    let leniancy = 1
    var skips = 0
    
    for i in 1...largest {
        if freq.keys.contains(i) {
            
            started = true
            total += Double(i * freq[i]!)
            count += Double(freq[i]!)
            skips = 0
        
        } else if (started) {
            // count continuous skips only
            skips += 1
        }
        
        // calculate dot
        if skips > leniancy{
            
            if midDone {
                break
            }
            
            if shortDone {
                
                mid = (total / count)
                
                // reset for bar
                total = 0.0
                count = 0.0
                skips = 0
                started = false
                
                //break next time
                midDone = true
                
            }
            
            short = (total / count)
            
            // reset for bar
            total = 0.0
            count = 0.0
            skips = 0
            started = false
            
            //break next time
            shortDone = true
            

        }
    }
    
    long = (total / count)
        
    return (short, mid, long)
}

func translateToMC(signal:[Int], dot: Double, bar: Double, short: Double, mid: Double, long: Double) -> String {
    
    var morseCode = ""
    
    var contON = 0.0
    var contOFF = 0.0
    
    for sig in signal {
        
        if (sig == 1) {
            
            if ((mid - 1) ... (mid + 1)  ~= contOFF) {
                morseCode += " "
            } else if ((long - 1) ... (long + 1)  ~= contOFF) {
                morseCode += " / "
            }
            
            contON += 1
            contOFF = 0
            
        } else {
            
            if ((dot - 1) ... (dot + 1)  ~= contON) {
                morseCode += "."
            } else if ((bar - 1) ... (bar + 1)  ~= contON) {
                morseCode += "-"
            }
            
            contOFF += 1
            contON = 0
        }
        
    }
    
    return morseCode
}




