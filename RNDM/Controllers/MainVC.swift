//
//  ViewController.swift
//  RNDM
//
//  Created by Daljeet Singh Chhabra on 20/01/19.
//  Copyright © 2019 Daljeet Singh Chhabra. All rights reserved.
//

import UIKit
import Firebase

func getCategory(segmentIndex : Int) -> String {
    
    if segmentIndex == 0{
        return "funny"
    }else if segmentIndex == 1{
        return "serious"
    }else if segmentIndex == 2{
        return "crazy"
    }else if segmentIndex == 3{
        return "popular"
    }
    else{
        return "funny"                          //DEFAULT CATEGORY WILL BE funny
    }
    
}
class MainVC: UIViewController , UITableViewDataSource, UITableViewDelegate{

    //MARK: OUTLETS
    @IBOutlet private weak var segmentControl: UISegmentedControl!
    @IBOutlet private weak var tableview: UITableView!
    
    
    //MARK: VARIABLES
    private var thoughts = [Thoughts]()
    private var thoughtsCollectionRef: CollectionReference!
    private var thoughtsListener: ListenerRegistration!
    private var selectedCategory: Int = 0

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableview.delegate = self
        tableview.dataSource = self
        tableview.reloadData()
        tableview.estimatedRowHeight = 80
        tableview.rowHeight = UITableView.automaticDimension
        thoughtsCollectionRef = Firestore.firestore().collection(THOUGHTS_REF)

    }
    
    @IBAction func categoryChanged(_ sender: Any) {
        
        selectedCategory = segmentControl.selectedSegmentIndex
        thoughtsListener.remove()
        setListener()
    }
    
   
    override func viewWillAppear(_ animated: Bool) {
        setListener()
    }
    
    func setListener() {
        if getCategory(segmentIndex: selectedCategory) == "popular"{
            
            thoughtsListener = thoughtsCollectionRef
                .order(by: NUM_LIKES, descending: true)
                .addSnapshotListener { (snapshot, error) in
                    if let error = error {
                        debugPrint("Error fetching documents: \(error)")
                    }else {
                        self.thoughts.removeAll()
                        self.thoughts = Thoughts.parseData(snapshot: snapshot)
                        self.tableview.reloadData()
                    }
            }
            
        }else{
            thoughtsListener = thoughtsCollectionRef
                .whereField(CATEGORY, isEqualTo: getCategory(segmentIndex: selectedCategory))
                .order(by: TIMESTAMP, descending: true)
                .addSnapshotListener { (snapshot, error) in
                    if let error = error {
                        debugPrint("Error fetching documents: \(error)")
                    }else {
                        self.thoughts.removeAll()
                        self.thoughts = Thoughts.parseData(snapshot: snapshot)
                        self.tableview.reloadData()
                    }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        thoughtsListener.remove()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return thoughts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "thoughtCell", for: indexPath) as? ThoughtCell{
            
            cell.configureCell(thought: thoughts[indexPath.row])
            return cell
        }else{
                return UITableViewCell()
        }
        
    }
    
    
}

