# Torch

![Swift Version](https://img.shields.io/badge/Swift-4.2-orange.svg)
![Platforms](https://img.shields.io/badge/Platforms-iOS-yellow.svg?style=flat)
[![License](https://img.shields.io/badge/License-MIT-green.svg?style=flat)](https://github.com/cpageler93/Torch/blob/master/LICENSE)
[![Twitter: @cpageler93](https://img.shields.io/badge/contact-@cpageler93-009fee.svg?style=flat)](https://twitter.com/cpageler93)

`Torch` is Swift (iOS) Library which helps to control the device's flashlight.

## Install

### Carthage

To install `Torch` with Carthage, setup Carthage for your project as described in the [Quick Start](https://github.com/Carthage/Carthage#quick-start).

Then add this line to your Cartfile:

```
github "cpageler93/Torch" ~> 0.2.0
```

## Usage

### Check if Torch is available on the current device

```swift
let isAvailable = Torch.isAvailable() // Bool
```

### Set torch value

```swift
// 100%
Torch.setTorch(to: 1.0)

// 50%
Torch.setTorch(to: 0.5)

// 0%
Torch.setTorch(to: 0.0)
```

### Set torch value for a given duration

```swift
// set torch to 50% for 20 seconds
// after 20 seconds the torch resets it's state to the value before
Torch.setTorch(to: 0.5, duration: 20)
```

### Blink

```swift
// blinks 5 times, each blink lasts 0.2 seconds, the gap between each blink is also 0.2
Torch.blink(5, duration: 0.2, gap: 0.2)
```

## Need Help?

Please [submit an issue](https://github.com/cpageler93/Torch/issues) on GitHub.

## License

This project is licensed under the terms of the MIT license. See the [LICENSE](LICENSE) file.