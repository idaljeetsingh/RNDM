//
//  ThoughtCell.swift
//  RNDM
//
//  Created by Daljeet Singh Chhabra on 22/01/19.
//  Copyright © 2019 Daljeet Singh Chhabra. All rights reserved.
//

import UIKit
import Firebase

class ThoughtCell: UITableViewCell {

    //MARK: OUTLETS
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var thoughTxtLabel: UILabel!
    @IBOutlet weak var likesImage: UIImageView!
    @IBOutlet weak var likesNumLabel: UILabel!
    
    //MARK: Variables
    
    private var thought: Thoughts!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        likesImage.addGestureRecognizer(tap)
        likesImage.isUserInteractionEnabled = true
    }
    
    @objc func likeTapped(){
            Firestore.firestore().collection(THOUGHTS_REF).document(thought.documentId)
                .updateData([NUM_LIKES: thought.numLikes + 1])
    }
    
    func configureCell(thought : Thoughts) {
        self.thought = thought
        usernameLabel.text = thought.username
        thoughTxtLabel.text = thought.thoughtTxt
        likesNumLabel.text = String(thought.numLikes)
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, hh:mm"
        let timeStamp = formatter.string(from: thought.timeStamp)
        timestampLabel.text = timeStamp
    }
}
