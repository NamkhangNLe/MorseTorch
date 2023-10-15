//
//  ViewController.swift
//  Torch
//
//  Created by Christoph Pageler on 14.10.18.
//  Copyright © 2018 Christoph Pageler. All rights reserved.
//


import UIKit
import Torch


class ViewController: UIViewController {

    @IBOutlet var labelTorchAvailable: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        if Torch.isAvailable() {
            labelTorchAvailable.text = "Torch available"
        } else {
            labelTorchAvailable.text = "Torch not available"
        }
    }

    @IBAction func actionSetTorch0(_ sender: UIButton) {
        Torch.setTorch(to: 0)
    }

    @IBAction func actionSetTorch50(_ sender: UIButton) {
        Torch.setTorch(to: 0.5)
    }

    @IBAction func actionSetTorch100(_ sender: UIButton) {
        Torch.setTorch(to: 1)
    }

    @IBAction func actionBlink5(_ sender: UIButton) {
        Torch.blink(5, duration: 0.2, gap: 0.2)
    }

}

