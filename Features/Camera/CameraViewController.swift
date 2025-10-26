//
//  CameraViewController.swift
//  SmartRepair
//
//  Created by Rashika
//

import Foundation
import UIKit
import AVFoundation

class CameraViewController: UIViewController {

    // MARK: - Properties
    private let captureSession = AVCaptureSession()
    private var photoOutput = AVCapturePhotoOutput()
    private var previewLayer: AVCaptureVideoPreviewLayer!
    var onPhotoCaptured: ((UIImage) -> Void)?

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
    }

    // MARK: - Camera Setup
    private func setupCamera() {
        captureSession.sessionPreset = .photo

        guard let backCamera = AVCaptureDevice.default(for: .video) else {
            print("No camera available")
            return
        }

        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            if captureSession.canAddInput(input) { captureSession.addInput(input) }
            if captureSession.canAddOutput(photoOutput) { captureSession.addOutput(photoOutput) }

            // Preview
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.frame = view.bounds
            view.layer.addSublayer(previewLayer)

            captureSession.startRunning()
        } catch {
            print("Error setting up camera: \(error)")
        }
    }

    // MARK: - Capture Photo
    func takePhoto() {
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
}

// MARK: - AVCapturePhotoCaptureDelegate
extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {
        guard let data = photo.fileDataRepresentation(),
              let image = UIImage(data: data) else { return }
        onPhotoCaptured?(image)
    }
}
