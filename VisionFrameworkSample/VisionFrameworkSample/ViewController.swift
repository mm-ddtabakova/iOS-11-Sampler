//
//  ViewController.swift
//  VisionFrameworkSample
//
//  Created by Dobrinka Tabakova on 9/30/17.
//  Copyright © 2017 Dobrinka Tabakova. All rights reserved.
//

import UIKit
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var processImageButton: UIButton!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loadImageButtonTapped(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func processImageButtonTapped(_ sender: Any) {
        self.processImage()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = originalImage
            processImageButton.isEnabled = true
        }
        picker.dismiss(animated: true)
    }
    
    func processImage() {
        self.processImageButton.isHidden = true
        self.loadingIndicator.isHidden = false
        
        let sourceImage = self.imageView.image

        DispatchQueue.global(qos: .background).async {
            let detectFaceRequest = VNDetectFaceLandmarksRequest { (request, error) in
                if let results = request.results as? [VNFaceObservation] {
                    for faceObservation in results {
                        guard let landmarks = faceObservation.landmarks else {
                            continue
                        }
                        let boundingRect = faceObservation.boundingBox
                        
                        var landmarkRegions: [VNFaceLandmarkRegion2D] = []
                        
                        if let faceContour = landmarks.faceContour {
                            landmarkRegions.append(faceContour)
                        }
                        if let leftEye = landmarks.leftEye {
                            landmarkRegions.append(leftEye)
                        }
                        if let rightEye = landmarks.rightEye {
                            landmarkRegions.append(rightEye)
                        }
                        if let innerLips = landmarks.innerLips {
                            landmarkRegions.append(innerLips)
                        }
                        if let outerLips = landmarks.outerLips {
                            landmarkRegions.append(outerLips)
                        }
                        if let leftEyebrow = landmarks.leftEyebrow {
                            landmarkRegions.append(leftEyebrow)
                        }
                        if let rightEyebrow = landmarks.rightEyebrow {
                            landmarkRegions.append(rightEyebrow)
                        }
                        if let leftPupil = landmarks.leftPupil {
                            landmarkRegions.append(leftPupil)
                        }
                        if let rightPupil = landmarks.rightPupil {
                            landmarkRegions.append(rightPupil)
                        }
                        if let nose = landmarks.nose {
                            landmarkRegions.append(nose)
                        }
                        if let noseCrest = landmarks.noseCrest {
                            landmarkRegions.append(noseCrest)
                        }
                        
                        let resultImage = self.drawLandmarks(image: sourceImage!, boundingRect: boundingRect, landmarks: landmarkRegions)
                        DispatchQueue.main.async {
                            self.imageView.image = resultImage
                            self.processImageButton.isHidden = false
                            self.loadingIndicator.isHidden = true
                        }
                    }
                }
            }
            let vnImage = VNImageRequestHandler(cgImage: (sourceImage?.cgImage!)!, options: [:])
            try? vnImage.perform([detectFaceRequest])
        }
    }
    
    func drawLandmarks(image: UIImage, boundingRect: CGRect, landmarks: [VNFaceLandmarkRegion2D]) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(image.size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: 0, y: image.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setLineWidth(4.0)
        
        let rectWidth = image.size.width * boundingRect.size.width
        let rectHeight = image.size.height * boundingRect.size.height
        let rectOriginX = image.size.width * boundingRect.origin.x
        let rectOriginY = image.size.height * boundingRect.origin.y

        let rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        context.draw(image.cgImage!, in: rect)
        
        let faceContourColor = UIColor.green
        faceContourColor.setStroke()
        context.addRect(CGRect(x: rectOriginX, y: rectOriginY, width: rectWidth, height: rectHeight))
        context.drawPath(using: CGPathDrawingMode.stroke)
        
        let landmarksColor = UIColor.red
        landmarksColor.setStroke()
        for landmarkRegion in landmarks {
            let points = landmarkRegion.normalizedPoints.map{CGPoint(x: rectOriginX + $0.x * rectWidth, y: rectOriginY + $0.y * rectHeight)}
            context.addLines(between: points)
            context.drawPath(using: CGPathDrawingMode.stroke)
        }
        
        let resultImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return resultImage
    }
}

