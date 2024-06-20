//
//  ViewController.swift
//  TextRecon
//
//  Created by Thush-Fdo on 17/05/2024.
//

import UIKit
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var textSample: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textSample.text = "-No Text-"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @IBAction func CaptureImage(_ sender: Any) {
        self.showImagePicker(selectedSource: .camera)
    }
    
    @IBAction func GalleryImage(_ sender: Any) {
        self.showImagePicker(selectedSource: .photoLibrary)
    }
    
    
    @IBAction func SampleImage(_ sender: Any) {
        let optionSheet = UIAlertController(title: "Sample Images",
                                            message: "Use below images to test the app",
                                            preferredStyle: .alert)
        
        optionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (action) in
            print("Cancel")
            self.imageView.image = UIImage(named: "PlaceholderImg")
            self.textSample.text = "-No Text-"
        }))
        
        optionSheet.addAction(UIAlertAction(title: "Sample 01", style: .default, handler: { [weak self]
            (action) in
            
            self?.imageView.image = UIImage(named: "sample1")
            self?.textSample.text = "Processing..."
            self?.recognizetext(image: self?.imageView.image)
        }))
        
        optionSheet.addAction(UIAlertAction(title: "Sample 02", style: .default, handler: { [weak self]
            (action) in
            
            self?.imageView.image = UIImage(named: "sample2")
            self?.textSample.text = "Processing..."
            self?.recognizetext(image: self?.imageView.image)
        }))
        
        optionSheet.addAction(UIAlertAction(title: "Sample 03", style: .default, handler: { [weak self]
            (action) in
            
            self?.imageView.image = UIImage(named: "sample3")
            self?.textSample.text = "Processing..."
            self?.recognizetext(image: self?.imageView.image)
        }))
        
        self.present(optionSheet, animated: true)
    }
    
    
    func recognizetext(image: UIImage?) {
        guard let cgImage = image?.cgImage else { return }
        
        //Handler
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        //Request
        let request = VNRecognizeTextRequest { [weak self] request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation], error == nil else {
                return
            }
            
            let text = observations.compactMap({
                $0.topCandidates(1).first?.string
            }).joined(separator: ", ")
            
            DispatchQueue.main.async {
                self?.textSample.text = text
            }
        }
        
        //Process Request
        do {
            try handler.perform([request])
        } catch  {
            print(error)
        }
        
    }
    
    func showImagePicker(selectedSource : UIImagePickerController.SourceType){
        guard UIImagePickerController.isSourceTypeAvailable(selectedSource) else{
            return
        }
        
        let imagepickerController = UIImagePickerController()
        imagepickerController.delegate = self
        imagepickerController.sourceType = selectedSource
        imagepickerController.allowsEditing = false
        self.present(imagepickerController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imagePicked = info[.originalImage] as? UIImage{
            self.imageView.image = imagePicked
            self.textSample.text = "Processing..."
            self.recognizetext(image: self.imageView.image)
        } else {
            print("Image Not Found")
        }
        
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
        self.imageView.image = UIImage(named: "PlaceholderImg")
        self.textSample.text = "-No Text-"
    }
}

