//
//  CameraManager.swift
//  FiltersAppSwiftUI
//
//  Created by Mohammad Alabed on 17/11/2024.
//

import UIKit
import AVFoundation
import CoreImage

enum CameraManagerError: Error {
    case CannotAccessCamera
}

protocol CameraManagerDelegate: AnyObject {
    func captureOutput(ciImage: CIImage)
}

class CameraManager: NSObject {
    
    static var shared: CameraManager = CameraManager()
    
    weak var delegate: CameraManagerDelegate?
    
    var captureSession: AVCaptureSession!
    var videoOutput: AVCaptureVideoDataOutput!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var filteredLayer: CALayer!
    
    // Enhance performence
    private var lastProcessedTime: TimeInterval = 0
    private let frameProcessingInterval: TimeInterval = 0.05 // Process less frames per second
    
    
    func createCamera(inView: UIView, imageQuality: AVCaptureSession.Preset = .hd1280x720, outputDelegate: CameraManagerDelegate?) throws {
        delegate = outputDelegate
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = imageQuality
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
              let input = try? AVCaptureDeviceInput(device: camera),
              captureSession.canAddInput(input) else {
            throw CameraManagerError.CannotAccessCamera
        }
        captureSession.addInput(input)
        
        // Add video output
        videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(videoOutput)
        
        // Set up preview layer
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = inView.bounds
        inView.layer.addSublayer(previewLayer)
        
        // Set up filtered layer
        filteredLayer = CALayer()
        filteredLayer.frame = inView.bounds
        filteredLayer.contentsGravity = .resizeAspectFill
        inView.layer.addSublayer(filteredLayer)
        
        // Start session
        captureSession.startRunning()
    }
    
    func canProcessFrames() -> Bool {
        let currentTime = CACurrentMediaTime()
        if currentTime - lastProcessedTime < frameProcessingInterval {
            return false
        }
        lastProcessedTime = currentTime
        return true
    }
}


extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard canProcessFrames() else {
            return
        }
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer).oriented(.leftMirrored)
        delegate?.captureOutput(ciImage: ciImage)
    }
}
