//
//  AddThoughtVC.swift
//  RNDM
//
//  Created by Daljeet Singh Chhabra on 21/01/19.
//  Copyright © 2019 Daljeet Singh Chhabra. All rights reserved.
//

import UIKit
import Firebase

class AddThoughtVC: UIViewController, UITextViewDelegate {
    
    //MARK: OUTLETS:
    
    @IBOutlet private weak var categorySegment: UISegmentedControl!
    @IBOutlet private weak var userNameTxt: UITextField!
    
    @IBOutlet private weak var thoughtTxt: UITextView!
    @IBOutlet private weak var postButton: UIButton!
    
    
    //MARK: VARIABLES
    
    private var selectedCategory = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        postButton.layer.cornerRadius = 4
        thoughtTxt.layer.cornerRadius = 4
        thoughtTxt.text = "My random thought..."
        thoughtTxt.textColor = UIColor.lightGray
        thoughtTxt.delegate = self
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        textView.textColor = UIColor.darkGray
        
    }
    @IBAction func postButtonPressed(_ sender: Any) {
        guard let username = userNameTxt.text else {
            return
        }
        Firestore.firestore().collection(THOUGHTS_REF).addDocument(data: [
            CATEGORY : getCategory(segmentIndex: selectedCategory),
            NUM_COMMENTS : 0,
            NUM_LIKES : 0,
            THOUGHT_TXT : thoughtTxt.text,
            TIMESTAMP : FieldValue.serverTimestamp(),
            USERNAME : username
            
        ]) { (error) in
            
            if let error  = error {
                debugPrint("Error adding document \(error)")
            }else{
                self.navigationController?.popViewController(animated: true)
            }
            
            
        }
        
    }
    
    @IBAction func categoryChanged(_ sender: Any) {
        
        selectedCategory = categorySegment.selectedSegmentIndex
        
    }
    
    
    

}
