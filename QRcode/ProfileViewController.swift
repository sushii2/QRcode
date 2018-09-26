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


class ProfileViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func uploadButtonPressed(_ sender: UIButton) {
        let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypeText),String(kUTTypeContent),String(kUTTypeItem),String(kUTTypeData)], in: .import)
        documentPicker.delegate = self as? UIDocumentPickerDelegate
        self.present(documentPicker, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func uploadFilestoFirebase(data: NSURL){
        
    }
    

    
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
   /* func documentPicker(picker: UIDocumentPickerViewController, didFinishPickingMedia info:[String: AnyObject]) {
        guard let mediaType: String = info[UIDocumentPickerViewController] as? String else {
            dismiss(animated: true,completion: nil)
            return
        }
    }*/
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print(urls)
    }
    
    
        
    }

