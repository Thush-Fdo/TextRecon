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
    
    var optionSheet = UIAlertController()
    var optionList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textSample.text = "-No Text-"
        configureOptionSheet()
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
        self.present(optionSheet, animated: true)
    }
    
    func configureOptionSheet() {
        optionSheet = UIAlertController(title: "Sample Images",
                                        message: "Use below images to test the app",
                                        preferredStyle: .alert)
        optionList = ["Cancel", "sample1", "sample2", "sample3"]
        
        for option in optionList {
            if option == "cancel" {
                optionSheetAdd(title: option, image: option, action: .cancel)
            } else {
                optionSheetAdd(title: option, image: option, action: .default)
            }
        }
    }
    
    func optionSheetAdd(title: String, image: String, action: UIAlertAction.Style) {
        self.optionSheet.addAction(UIAlertAction(title: title, style: action, handler: { [weak self]
            (action) in
            
            if title == "Cancel" {
                self?.imageView.image = UIImage(named: "PlaceholderImg")
                self?.textSample.text = "-No Text-"
            } else  {
                self?.imageView.image = UIImage(named: image)
                self?.textSample.text = "Processing..."
                self?.recognizetext(image: self?.imageView.image)
            }
        }))
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

