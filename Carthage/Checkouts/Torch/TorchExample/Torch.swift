//
//  Torch.swift
//  MMEAG
//
//  Created by Christoph Pageler on 04.10.18.
//  Copyright © 2018 Christoph Pageler. All rights reserved.
//


import Foundation
import AVKit


/// 🔦
public class Torch {

    private static var sharedDevice: AVCaptureDevice?

    /// The AVCaptureDevice to control the torch (if available)
    private static var device: AVCaptureDevice? {
        if sharedDevice != nil {
            return sharedDevice
        }

        guard let device = AVCaptureDevice.default(for: .video) else { return nil }
        guard device.hasTorch else { return nil }

        sharedDevice = device

        return device
    }

    /// stores the current torch level, the getter of AVCaptureDevice.torchLevel seems not to work
    private static var currentLevel: Float = 0.0

    /// Exception safe closure which provides the device
    /// If no device is available, or the device has no torch support, the closure never gets called
    ///
    /// - Parameter closure: closure with capture device if available
    private static func device(closure: (AVCaptureDevice) throws -> Void) {
        guard let device = device else { return }
        do {
            try closure(device)
        } catch {
            print("Torch: catch \(error)")
        }
    }

    /// Waits for given time and blocks current thread
    ///
    /// - Parameter duration: time interval in seconds
    private static func wait(_ duration: TimeInterval) {
        let group = DispatchGroup()
        group.enter()
        _ = group.wait(timeout: DispatchTime.now() + duration)
    }

    /// Checks if a device with torch support is available
    ///
    /// - Returns: true then the device is available with torch support
    public static func isAvailable() -> Bool {
        return device != nil
    }

    /// Sets the torch level on the device
    ///
    /// - Parameter level: from 0.0 to 1.0 where 0 is off and 1 is 100%
    public static func setTorch(to level: Float) {
        device { device in
            try device.lockForConfiguration()

            if level == 0 {
                device.torchMode = .off
            } else {
                device.torchMode = .on
                try device.setTorchModeOn(level: level)
            }

            currentLevel = level

            device.unlockForConfiguration()
        }
    }

    /// Sets the given level on the torch for the given duration
    /// After the duration, the level will be set to the value before
    /// Don't call this method on the main thread to avoid blocking the UI
    ///
    /// - Parameters:
    ///   - level: from 0.0 to 1.0 where 0 is off and 1 is 100%
    ///   - duration: duration in seconds
    public static func setTorch(to level: Float, duration: TimeInterval) {
        device { device in
            let oldTorchLevel = currentLevel
            setTorch(to: level)
            wait(duration)
            setTorch(to: oldTorchLevel)
        }
    }

    /// Sets the given levels on the torch for the given duration
    /// Waits for `gap` seconds between each level
    /// After the duration, the level will be set to the value before
    /// Don't call this method on the main thread to avoid blocking the UI
    ///
    /// - Parameters:
    ///   - levels: array of levels from 0.0 to 1.0 where 0 is off and 1 is 100%
    ///   - duration: duration in seconds for each level
    ///   - gap: waiting time between each level
    public static func setTorch(to levels: [Float], duration: TimeInterval, gap: TimeInterval) {
        for level in levels {
            setTorch(to: level, duration: duration)
            wait(gap)
        }
    }

    /// Blinks the torch for the given number
    /// Waits for `gap` seconds between each blink
    /// After the duration, the level will be set to the value before
    /// Don't call this method on the main thread to avoid blocking the UI
    ///
    /// - Parameters:
    ///   - numberOfBlinks: number of blinks
    ///   - duration: duration in seconds for each blink
    ///   - gap: waiting time between each blink
    public static func blink(_ numberOfBlinks: Int, duration: TimeInterval, gap: TimeInterval) {
        let levels = Array<Float>(repeating: 1.0, count: numberOfBlinks)
        setTorch(to: levels, duration: duration, gap: gap)
    }

    /// Flash the torch
    ///
    /// - Parameters:
    ///   - level: level of flash from 0.0 to 1.0 where 0 is off and 1 is 100%
    ///   - duration: duration of flash
    public static func flash(level: Float = 1, duration: TimeInterval = 0) {
        setTorch(to: level)
        wait(duration)
        setTorch(to: 0)
    }

}
