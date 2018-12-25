//
//  ViewController.swift
//  PhotoFlip
//
//  Created by Doğa Bayram on 1.12.2018.
//  Copyright © 2018 Doğa Bayram. All rights reserved.
//

import UIKit
import MobileCoreServices
import GoogleMobileAds

class ViewController: UIViewController , UIImagePickerControllerDelegate,UINavigationControllerDelegate,GADBannerViewDelegate ,GADInterstitialDelegate{
    
    
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var imageView: UIImageView!
    var originalHorizonFlip = true
    var originalVertiaclFlip = true
    var originalImage : UIImage?
    var imageMirror = UIImage()
    @IBOutlet weak var choosePhotoLabel: UILabel!
    let imagePicker = UIImagePickerController()
    var interstitial: GADInterstitial!
    var fromGallery : Bool?
    @IBOutlet weak var chooseButton: UIButton!
    

    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.isUserInteractionEnabled = true
        imagePicker.delegate = self
        bannerFunc()

       //originalImage = UIImage(named: "Mersin-Gezilecek-Yerler")
       //imageView.image = originalImage
    
       swipeGestures()
        
    }
    
    func bannerFunc() {
        
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self

    }
    
    func interstitialAds() {
        
        interstitial.delegate = self
        let request = GADRequest()
        interstitial.load(request)
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
        
       // alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default))
        
        let action = UIAlertAction(title: "OK", style: .default) { (alertOk) in
            if self.interstitial.isReady {
                self.interstitial.present(fromRootViewController: self)
            }
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func galleryPickerButton(_ sender: UIButton) {
        
       
        
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true) {
            self.fromGallery = true
            self.chooseButton.isHidden = true
            self.originalHorizonFlip = true
            self.originalVertiaclFlip = true
            self.bannerFunc()
            self.interstitialAds()
        }
        
  
        
    }
    
   
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
      
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
           originalImage = UIImage(cgImage: image.cgImage!, scale: 1.0, orientation: .up)
            //originalImage = image
            imageView.image = originalImage
            fromGallery = nil
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
    
    
//    @IBAction func rotationLeft(_ sender: UIButton) {
//        if originalImage != nil {
//                originalImage = UIImage(cgImage: originalImage!.cgImage!, scale: 1.0, orientation: .left)
//                imageView.image = originalImage
//            }
//        
//        
//    }
//    
//    
//    
//    @IBAction func rotationRight(_ sender: UIButton) {
//        
//        if originalImage != nil {
//            originalImage = UIImage(cgImage: originalImage!.cgImage!, scale: 1.0, orientation: .right)
//            imageView.image = originalImage
//        }
//        
//    }
    
    
    
    func alert() {
        let alert = UIAlertController(title: "Choose Photo", message: "From Camera Or Library", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default))
        self.present(alert, animated: true, completion: nil)
    }
   
    
}

