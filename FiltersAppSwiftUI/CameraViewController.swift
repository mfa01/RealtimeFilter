//
//  CameraViewController.swift
//  FiltersAppSwiftUI
//
//  Created by Mohammad Alabed on 17/11/2024.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {

    var filter: CIFilter?
    lazy var ciContext: CIContext = {
        if let metalDevice = MTLCreateSystemDefaultDevice() {
            return CIContext(mtlDevice: metalDevice)
        }
        return CIContext() // Fallback to CPU-based rendering
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
    }

    func setupCamera() {
        do {
            try CameraManager.shared.createCamera(inView: self.view, outputDelegate: self)
        } catch let error {
            print(error)
        }
    }

    func applyFilter(named filterName: String, intensity: Double?) {
        filter = CIFilter(name: filterName)
        if let intensity = intensity {
            filter?.setValue(intensity, forKey: kCIInputIntensityKey)
        }
    }
}

extension CameraViewController: CameraManagerDelegate {
    func captureOutput(ciImage: CIImage) {
        guard let filter = filter else { return }
        // Enhance memory by reducing the input frame
        let scaledImage = ciImage.transformed(by: CGAffineTransform(scaleX: 0.5, y: 0.5))
        filter.setValue(scaledImage, forKey: kCIInputImageKey)
        guard let outputImage = filter.outputImage else { return }
        // Render the filtered image
        DispatchQueue.main.async {
            if let cgImage = self.ciContext.createCGImage(outputImage, from: outputImage.extent) {
                CameraManager.shared.filteredLayer.contents = cgImage
            }
        }
    }
}

