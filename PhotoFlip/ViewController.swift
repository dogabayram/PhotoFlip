//
//  ViewController.swift
//  PhotoFlip
//
//  Created by Doğa Bayram on 1.12.2018.
//  Copyright © 2018 Doğa Bayram. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    
    @IBOutlet weak var bannerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    var originalHorizonFlip = true
    var originalVertiaclFlip = true
    var originalImage : UIImage?
    var imageMirror = UIImage()
    @IBOutlet weak var choosePhotoLabel: UILabel!
    let imagePicker = UIImagePickerController()

    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.isUserInteractionEnabled = true
        imagePicker.delegate = self

       //originalImage = UIImage(named: "Mersin-Gezilecek-Yerler")
       //imageView.image = originalImage
    
       swipeGestures()
        
    }
    
    func swipeGestures () {
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(flipHorizontalButton(_:)))
        leftSwipe.direction = UISwipeGestureRecognizer.Direction.left
        self.imageView.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(flipHorizontalButton(_:)))
        rightSwipe.direction = UISwipeGestureRecognizer.Direction.right
        self.imageView.addGestureRecognizer(rightSwipe)
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(flipVerticalButton(_:)))
        downSwipe.direction = UISwipeGestureRecognizer.Direction.down
        self.imageView.addGestureRecognizer(downSwipe)
        
        let topSwipe = UISwipeGestureRecognizer(target: self, action: #selector(flipVerticalButton(_:)))
        topSwipe.direction = UISwipeGestureRecognizer.Direction.up
        self.imageView.addGestureRecognizer(topSwipe)
    }
    
    
    @IBAction func saveImageButton(_ sender: UIButton) {
        
        if originalImage != nil {
        UIImageWriteToSavedPhotosAlbum(imageMirror, self, #selector(self.cameraRollComplete(_:finishedSavingWithError:contextInfo:)), nil)
        } else {
            alert()
        }
        
        
        
    }
    @objc func cameraRollComplete(_ image: UIImage, finishedSavingWithError error: NSError, contextInfo: UnsafeMutableRawPointer) {
        let alert = UIAlertController(
            title: NSLocalizedString("Saved to Photo Library",
                                     comment: "Confirming photo was saved to the system photo library"),
            message: nil,
            preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func galleryPickerButton(_ sender: UIButton) {
        
        choosePhotoLabel.isHidden = true
       originalHorizonFlip = true
      originalVertiaclFlip = true
        
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true) {
            self.choosePhotoLabel.isHidden = true
            self.originalHorizonFlip = true
            self.originalVertiaclFlip = true
        }
        
  
        
    }
    
    @IBAction func cameraPickerButton(_ sender: UIButton) {
        
        choosePhotoLabel.isHidden = true
        originalHorizonFlip = true
        originalVertiaclFlip = true
        
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true) {
            self.choosePhotoLabel.isHidden = true
            self.originalHorizonFlip = true
            self.originalVertiaclFlip = true
        }

        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            originalImage = image
            imageView.image = image
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func flipHorizontalButton(_ sender: Any) {
        
        if originalImage != nil {
        if originalHorizonFlip {
            imageMirror = UIImage(cgImage: originalImage!.cgImage!, scale: 1.0, orientation: .upMirrored)
            imageView.image = imageMirror
            UIView.transition(with: self.imageView, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)
            originalHorizonFlip = false
        } else {
        originalHorizonFlip = true
            imageMirror = originalImage!
            imageView.image = imageMirror
        UIView.transition(with: self.imageView, duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
            }} else {
            alert()
        }
        
    }
    
    @IBAction func flipVerticalButton(_ sender: UIButton) {
        
        if originalImage != nil {
            if originalVertiaclFlip {
                imageMirror = UIImage(cgImage: originalImage!.cgImage!, scale: 1.0, orientation: .downMirrored)
                imageView.image = imageMirror
                UIView.transition(with: self.imageView, duration: 0.5, options: .transitionFlipFromTop, animations: nil, completion: nil)
                originalVertiaclFlip = false
            } else {
                originalVertiaclFlip = true
                imageMirror = originalImage!
                imageView.image = imageMirror
                UIView.transition(with: self.imageView, duration: 0.5, options: .transitionFlipFromBottom, animations: nil, completion: nil)
            }} else {
            alert()
        }
  
    }
    
    
    func alert() {
        let alert = UIAlertController(title: "Choose Photo", message: "From Camera Or Library", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default))
        self.present(alert, animated: true, completion: nil)
    }
   
    
}

