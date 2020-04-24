//
//  CCImageManager.swift
//  LogisticsDriver
//
//  Created by pengpai on 2020/4/3.
//  Copyright © 2020 qiluys. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

public class CCImageManager {
    /// Camera about
    
    // MARK: Authorizations
    /// Capture authorization
    public class func captureAuthorization(shouldCapture: ((Bool)-> Void)?) {

        let captureStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch captureStatus {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (granted) in
                runOnMainQuene {
                    shouldCapture?(granted)
                }
            }
            break
        case .authorized:
            shouldCapture?(true)
            break
        default:
            shouldCapture?(false)
            break
        }
    }
    
    // Run on main quene
    public class func runOnMainQuene(callBack: (()->Void)?) {
        if Thread.current.isMainThread {
            if let call = callBack {
                call()
            }
        }else {
            DispatchQueue.main.async {
                if let call = callBack {
                    call()
                }
            }
        }
    }
    
    /// Crop the image to target size, default crop in the middle
    public class func cropImageAffterCapture(originImage: UIImage, toSize: CGSize) -> UIImage {
        
        let ratio = toSize.height/toSize.width
        let width = originImage.size.width
        let height = width * ratio
        let x = CGFloat(0)
        let y = (originImage.size.height - height)/2
        
        let finalRect = CGRect(x: x, y: y, width: width, height: height)
        
        let croppedImage = UIImage.init(cgImage: originImage.cgImage!.cropping(to: finalRect)!, scale: originImage.scale, orientation: originImage.imageOrientation)
        
        return croppedImage
    }
    
    /// Crop the image to target rect
    public class func cropImageToRect(originImage: UIImage, toRect: CGRect) -> UIImage {
        
        let croppedImage = UIImage.init(cgImage: originImage.cgImage!.cropping(to: toRect)!, scale: originImage.scale, orientation: originImage.imageOrientation)
        
        return croppedImage
    }
     
}
