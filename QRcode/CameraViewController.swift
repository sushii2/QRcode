//
//  CameraViewController.swift
//  QRcode
//
//  Created by svesposi on 9/25/18.
//  Copyright © 2018 SSQRCODE. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase
import FirebaseStorage
import MobileCoreServices

class CameraViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, UIDocumentPickerDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var qrCode:UIImage?
    @IBOutlet weak var qrImageView: UIImageView!
    
    @IBOutlet weak var cameraView: UIView!
    var scannedCode:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCamera()
       
    }
    func setUpCamera() {
        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()     // setups captureSession, view layer, and output
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {  print("boop")
            return }
        let videoInput: AVCaptureDeviceInput
        
        
        do{
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)){
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = cameraView.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        cameraView.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
       
    }
    func failed() { //triggered if cant add input/output --- triggered in simulator always
        
        let alert = UIAlertController(title: "Scanning not supported", message: "Your device does not have a camera", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
        captureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        
        if(captureSession?.isRunning == false){
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if(captureSession?.isRunning == true){
            captureSession.stopRunning()
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metaDataObject = metadataObjects.first { //reads QR code and passes to found
            guard let readableObject = metaDataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
        
        }
    
    func found(code: String){ //trigger segue to resume view
        scannedCode = code
        print(code)
        self.performSegue(withIdentifier: "toResume", sender: self)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toResume" {
            if let viewController = segue.destination as? ResumeViewController{
                viewController.scannedCode = self.scannedCode
            }
        }
    }
    
    @IBAction func returnToCam(segue: UIStoryboardSegue){
        if let sourceViewController = segue.source as? ResumeViewController {
            
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt urls: URL) {
        let myURL = urls
        uploadFilestoFirebase(url: myURL as NSURL)
        print("import result : \(myURL)")
        
    }
    
    func uploadFilestoFirebase(url: NSURL){
        let storageRef = Storage.storage().reference(withPath: "myFiles/myResume.pdf")
        let uploadMetaData = StorageMetadata()
        uploadMetaData.contentType = ""
        let uploadTask = storageRef.putFile(from: (url as URL), metadata: uploadMetaData){
            (metadata, error) in
            if(error != nil){
                print("I recieved a error! \(error?.localizedDescription)")
            }else{
                print("upload complete! here's some metadata! \(metadata)")
                storageRef.downloadURL(completion: { (url, error) in
                    if let error = error {
                        print(error as Any)
                    } else {
                        guard let imageUrl = url?.absoluteString else { return }
                        print(imageUrl)
                        self.qrCode = self.generateQRCode(from: imageUrl)
                        self.qrImageView.image = self.qrCode
                    }
                })
            }
            
        }
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        
        return nil
    }

    
    @IBAction func uploadPressed(_ sender: UIButton) {
        let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypeText as String,kUTTypeContent as String,kUTTypeItem as String,kUTTypeData as String], in: .import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .formSheet
        self.present(documentPicker, animated: true)
    }
}
