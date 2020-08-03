//
//  ViewController.swift
//  mathxml
//
//  Created by Achira Sarker
//  2020-07-25
//

import UIKit
import Vision

class ViewController: UIViewController {

    @IBOutlet weak var digitLabel: UILabel!
    
    @IBOutlet weak var canvasView: CanvasView!
    
    @IBOutlet weak var printQuestion: UILabel!
    
    @IBOutlet weak var performCheck: UILabel!
    
    var requests = [VNRequest]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVision()
        mathQuestion()
    }
    
    //create vision model from coreml model
    func setupVision() {
        guard let visionModel = try? VNCoreMLModel(for: MNISTClassifier().model)
        else {
            fatalError("Can't load Vision ML model")
        }
        let classificationRequest = VNCoreMLRequest(model: visionModel, completionHandler: self.handleClassification)
        //use array to pass on classification request
        self.requests = [classificationRequest]
    }
    
    //completion handler
    func handleClassification (request: VNRequest, error:Error?) {
        guard let observations = request.results
        else {
            print("No results"); return
        }
        //from the obseravtions, obtain a list of classifications
        let classifications = observations
            .compactMap({$0 as? VNClassificationObservation})
            .filter({$0.confidence > 0.8})
            .map({$0.identifier})
        
        DispatchQueue.main.async {
            self.digitLabel.text = classifications.first
        }
    }
    
    
    @IBAction func clearCanvas(_ sender: Any) {
        canvasView.clearCanvas()
    }
    
    @IBAction func recognizeDigit(_ sender: Any) {
        let image = UIImage(view: canvasView)
        //create scaled image
        let scaledImage = scaleImage(image: image, toSize: CGSize(width: 28, height: 28))
        
        let imageRequestHandler = VNImageRequestHandler(cgImage: scaledImage.cgImage!, options: [:])
        do {
            try imageRequestHandler.perform(self.requests)
        }catch{
            print(error)
        }
        
    }
    
    //scale image down after getting it
    func scaleImage (image: UIImage, toSize size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //math question variables
    let x = Int.random(in: 0...9)
    let y = Int.random(in: 0...9)
    
    //print out question
    func mathQuestion() {
        repeat {
        printQuestion.text = "\(x) + \(y)"
        let digitLabeltext = Int(digitLabel.text!)
            if digitLabeltext == x + y {
                performCheck.text = "Correct"
            }
            else {
                performCheck.text = "Incorrect"
            }
        }
        while digitLabel != nil
    }
    

}

