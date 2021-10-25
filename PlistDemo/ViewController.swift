//
//  ViewController.swift
//  PlistDemo
//
//  Created by Adriana González Martínez on 2/25/19.
//  Copyright © 2019 Adriana González Martínez. All rights reserved.
//

import UIKit


struct Score: Decodable {
    let name: String
    let score: Int
    
    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case score = "Score"
    }
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    var scores : [Score] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
       
        //TODO: Get the list of scores coming from your plist
        let ezraScore: [String: Any] = [
            "Name": "Ezra Morales",
            "Score": 3
        ]
        let lyraScore: [String: Any] = [
            "Name": "Lyra Morales",
            "Score": 1
        ]
        addValuePlist(plistName: "Scores", item: ezraScore)
        addValuePlist(plistName: "Scores", item: lyraScore)
        self.scores = readFromPropertyList(plistName: "Scores")
        table.reloadData()
        
    }
    
    // MARK: Table setup
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scores.count
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Highest Scores 🚀"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
        let item = scores[indexPath.row]
        //TODO: Make sure to display the score and name
        cell.textLabel?.text = "\(String(item.score))\t\(item.name)"
        return cell
        
    }
    
    //MARK: Plist handling
    //TODO: Keep your file clean by adding helper methods to handle the plist.
    func readFromPropertyList(plistName resource: String) -> [Score] {
        guard let scorePlistURL = Bundle.main.url(forResource: resource, withExtension: "plist") else { return [Score]() }
        guard let scorePlistData = FileManager.default.contents(atPath: scorePlistURL.path) else { return [Score]() }
        guard let scores = try? PropertyListDecoder().decode([Score].self, from: scorePlistData) else { return [Score]() }
        
        return scores
    }
    
    func addValuePlist(plistName resource: String, item: [String: Any]) {
        guard let scorePlistURL = Bundle.main.path(forResource: resource, ofType: "plist") else { return }
        if FileManager.default.fileExists(atPath: scorePlistURL) {
            guard let plistArray = NSMutableArray(contentsOfFile: scorePlistURL) else { return }
            plistArray.add(item)
            
            // adding values to the dictionary
            if FileManager.default.fileExists(atPath: scorePlistURL) {
                if !plistArray.write(toFile: scorePlistURL, atomically: false) {
                    print("File not written successfully")
                }
            }
        }
    }
    
}
