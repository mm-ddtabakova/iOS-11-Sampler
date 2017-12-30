//
//  ViewController.swift
//  AdvancedAnimationsSample
//
//  Created by Dobrinka Tabakova on 12/30/17.
//  Copyright © 2017 Dobrinka Tabakova. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var scaleAnimator: UIViewPropertyAnimator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        imageView.layer.cornerRadius = 30
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func toggleButtonTapped(_ sender: Any) {
        if scaleAnimator == nil {
            let scale = self.view.bounds.width / self.imageView.bounds.width
            
            scaleAnimator = UIViewPropertyAnimator(duration: 2, curve: .easeOut, animations: {
                self.imageView.layer.cornerRadius = 0
                self.imageView.transform = CGAffineTransform(scaleX: scale, y: scale)
            })
            scaleAnimator.scrubsLinearly = false
            scaleAnimator.pausesOnCompletion = true
            scaleAnimator.startAnimation()
        } else if scaleAnimator.fractionComplete == 1 {
            scaleAnimator.isReversed = !scaleAnimator.isReversed
            scaleAnimator.startAnimation()
        } else {
            if scaleAnimator.isRunning {
                scaleAnimator.pauseAnimation()
            } else {
                scaleAnimator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
            }
        }
    }
}

