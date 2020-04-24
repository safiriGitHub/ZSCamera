//
//  CameraCustomViewController.swift
//  LogisticsDriver
//
//  Created by pengpai on 2020/4/3.
//  Copyright © 2020 qiluys. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import SnapKit

public class CameraCustomViewController: UIViewController {
    
    let session = AVCaptureSession()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        CCImageManager.captureAuthorization { (canCapture) in
            if canCapture {
                self.setUI()
                self.setupCaptureSession()
                self.session.startRunning()
            }else {
                self.session.stopRunning()
            }
        }
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        session.startRunning()
    }
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        session.stopRunning()
    }
    
    func setUI() {
        
        closeButton.addTarget(self, action: #selector(closeButtonClick), for: .touchUpInside)
        cameraButton.addTarget(self, action: #selector(cameraButtonClick), for: .touchUpInside)
        flashButton.addTarget(self, action: #selector(flashButtonClick), for: .touchUpInside)
        pictureButton.addTarget(self, action: #selector(pictureButtonClick), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(confirmButtonClick), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonClick), for: .touchUpInside)
        
        view.addSubview(closeButton)
        closeButton.snp_makeConstraints { (make) in
            make.leading.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(22)
        }
        
        view.addSubview(bottomView)
        bottomView.snp_makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(90)
        }
        bottomView.addSubview(cameraButton)
        cameraButton.snp_makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        bottomView.addSubview(pictureButton)
        pictureButton.snp_makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(30)
        }
        bottomView.addSubview(flashButton)
        flashButton.snp_makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-30)
        }
        
        view.addSubview(imageView)
        imageView.snp_makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(resultBottomView)
        resultBottomView.snp_makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(50)
        }
        resultBottomView.addSubview(cancelButton)
        cancelButton.snp_makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(30)
        }
        resultBottomView.addSubview(confirmButton)
        confirmButton.snp_makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-30)
        }
        
        uiBeforeTake()
    }
    // UI
    func uiBeforeTake() {
        imageView.isHidden = true
        bottomView.isHidden = false
        resultBottomView.isHidden = true
    }
    
    func uiAfterTakeSuccess() {
        imageView.isHidden = false
        imageView.image = self.takedPhoto
        bottomView.isHidden = true
        resultBottomView.isHidden = false
    }
    
    // MARK: actions
    
    @objc func cameraButtonClick() {
        
        if let output = session.outputs.first as? AVCaptureStillImageOutput ,
            let connection = output.connections.first {
            
            output.captureStillImageAsynchronously(from: connection) { (buffer, error) in
                if let b = buffer,
                    let data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(b),
                    let image = UIImage(data: data) {
                    
                    self.takedPhoto = image
                    self.uiAfterTakeSuccess()
                }else {
                    self.session.startRunning()
                    self.takePhotoFailed?(error?.localizedDescription)
                }
            }
        }else {
            session.startRunning()
            takePhotoFailed?(nil)
        }
    }
    
    
    /// 关闭
    @objc func closeButtonClick() {
        session.stopRunning()
        dismiss(animated: true, completion: nil)
    }
    /// 闪光灯
    @objc func flashButtonClick() {
        let on = turnTorchOn()
        flashButton.isSelected = on
    }
    
    @objc func pictureButtonClick() {
        session.stopRunning()
        openPictureCallback?()
    }
    
    @objc func confirmButtonClick() {
        takePhotoSuccess?(takedPhoto)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func cancelButtonClick() {
        takedPhoto = nil
        uiBeforeTake()
    }
    
    
    //MARK: Params
    let closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "camera_guanbi"), for: .normal)
        return button
    }()
    
    private let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(white: 0, alpha: 0.3)
        return view
    }()
    let cameraButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "camera_paizhaoanniu@2x"), for: .normal)
        button.setImage(UIImage(named: "camera_paizhaoanniu_dianjihou@2x"), for: .highlighted)
        return button
    }()
    let flashButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "camera_dengpao"), for: .normal)
        button.setImage(UIImage(named: "camera_dengpao_dianjihou"), for: .highlighted)
        button.setImage(UIImage(named: "camera_dengpao_dianjihou"), for: .selected)
        return button
    }()
    let pictureButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "camera_tuku"), for: .normal)
        return button
    }()
    
    private let resultBottomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(white: 0, alpha: 0.3)
        return view
    }()
    let confirmButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "camera_queding"), for: .normal)
        return button
    }()
    let cancelButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "camera_guan"), for: .normal)
        return button
    }()
    
    let imageView: UIImageView = {
        let imgView = UIImageView()
        return imgView
    }()
    
    public var takePhotoSuccess: ((UIImage?)->Void)?
    public var takePhotoFailed: ((String?)->Void)?
    public var openPictureCallback: (()->Void)?
    public var takedPhoto: UIImage?
}

fileprivate extension CameraCustomViewController {
    func setupCaptureSession() {
        var successful = true
        defer {
            if !successful {
                // log error msg...
                print("error setting capture session")
            }
        }
        
        guard let device = tunedCaptureDevice() else {
            successful = false
            return
        }
        
        // begin configuration
        session.beginConfiguration()
        defer {
            session.commitConfiguration()
        }
        // preset
        session.sessionPreset = .photo
        // add input
        do {
            let input = try AVCaptureDeviceInput(device: device)
            if session.canAddInput(input) {
                session.addInput(input)
            } else {
                successful = false
                return
            }
        } catch {
            print(error.localizedDescription)
            successful = false
            return
        }
        // add output
        let output = AVCaptureStillImageOutput()
        output.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        if session.canAddOutput(output) {
            session.addOutput(output)
        } else {
            successful = false
            return
        }

        // insert preview layer
        let layer = AVCaptureVideoPreviewLayer(session: session)
        layer.videoGravity = .resizeAspectFill
        layer.frame = view.bounds
        view.layer.insertSublayer(layer, at: 0)
    }
    
    private func tunedCaptureDevice() -> AVCaptureDevice? {
        guard let device = AVCaptureDevice.default(for: .video) else {
            return nil
        }
        do {
            try device.lockForConfiguration()
            if device.isFocusModeSupported(.continuousAutoFocus) {
                device.focusMode = .continuousAutoFocus
            }
            if device.isExposureModeSupported(.continuousAutoExposure) {
                device.exposureMode = .continuousAutoExposure
            }
            if device.isWhiteBalanceModeSupported(.continuousAutoWhiteBalance) {
                device.whiteBalanceMode = .continuousAutoWhiteBalance
            }
            device.unlockForConfiguration()
            return device
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    private func turnTorchOn() -> Bool {
        var onOff = false
        guard let device = tunedCaptureDevice() else {
            return onOff
        }
        do {
            try device.lockForConfiguration()
            if device.hasTorch && device.hasFlash {
                if device.flashMode == .off {
                    device.flashMode = .on
                    device.torchMode = .on
                    onOff = true
                }else if device.flashMode == .on {
                    device.flashMode = .off
                    device.torchMode = .off
                }
            }
            device.unlockForConfiguration()
        } catch {
            print(error.localizedDescription)
        }
        
        return onOff
    }
}
