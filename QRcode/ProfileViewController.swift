//
//  ProfileViewController.swift
//  QRcode
//
//  Created by Saksham Saraswat on 9/25/18.
//  Copyright © 2018 SSQRCODE. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import MobileCoreServices


class ProfileViewController: UIViewController, UIDocumentPickerDelegate{
   
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func uploadButtonPressed(_ sender: UIButton) {
        let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypeText as String,kUTTypeContent as String,kUTTypeItem as String,kUTTypeData as String], in: .import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .formSheet
        self.present(documentPicker, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                }
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
    /*func documentPicker(picker: UIDocumentPickerViewController, didFinishPickingMedia info:[NSData: AnyObject]) {
        guard let mediaType: NSData = info[UIDocumentPickerViewController] as? NSData else {
            dismiss(animated: true,completion: nil)
            return
        }
    }*/
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt urls: URL) {
        let myURL = urls
        uploadFilestoFirebase(url: myURL as NSURL)
        print("import result : \(myURL)")
        
    }
    

    
        
    }

