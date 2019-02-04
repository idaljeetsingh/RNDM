//
//  Thoughts.swift
//  RNDM
//
//  Created by Daljeet Singh Chhabra on 22/01/19.
//  Copyright © 2019 Daljeet Singh Chhabra. All rights reserved.
//

import Foundation
import Firebase
class Thoughts {

    private(set) var username: String!
    private(set) var timeStamp: Date!
    private(set) var thoughtTxt: String!
    private(set) var numLikes: Int!
    private(set) var numComments: Int!
    private(set) var documentId: String!
    
    init(username: String, timeStamp: Date, thoughtTxt: String, numLikes: Int, documentId: String, numComments: Int) {
        
        self.username = username
        self.timeStamp = timeStamp
        self.thoughtTxt = thoughtTxt
        self.numLikes = numLikes
        self.numComments = numComments
        self.documentId = documentId
        
    }
    
    class func parseData(snapshot: QuerySnapshot?) -> [Thoughts] {
        
        var thoughts = [Thoughts]()
        
        guard let snap = snapshot else { return thoughts }
        for document in snap.documents {
            let data = document.data()
            let username = data[USERNAME] as? String ?? "Anonymous"
            let timestamp = data[TIMESTAMP] as? Date ?? Date()
            let thoughtTxt = data[THOUGHT_TXT] as? String ?? ""
            let numLikes = data[NUM_LIKES] as? Int ?? 0
            let numComments = data[NUM_COMMENTS] as? Int ?? 0
            let documentId = document.documentID
            
            
            let newThought = Thoughts(username: username, timeStamp: timestamp, thoughtTxt: thoughtTxt, numLikes: numLikes, documentId: documentId, numComments: numComments)
            
            thoughts.append(newThought)
        }
        return thoughts
    }
    
}
