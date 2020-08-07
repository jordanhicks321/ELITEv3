//
//  Open Project.swift
//  DTIv2
//
//  Created by Dj Haven on 6/23/20.
//  Copyright © 2020 Dj Haven. All rights reserved.
//

import Foundation
import UIKit

class OpenProject: UIViewController {
    
    let projectnames = ["a","b","c"]
    
    let defaults = UserDefaults.standard
   
   
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var User: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.dataSource = self
    
        
        
        navigationItem.hidesBackButton = true
        let username = defaults.integer(forKey: "userId")
        self.User.text = String(username)
    }
    
    
    
    
    @IBAction func logOutPressed(_ sender: Any) {
        let id = 0
        defaults.set(id, forKey: "userId")
        DispatchQueue.main.async {
        self.performSegue(withIdentifier: "saveProgress", sender: self)
                                }
        }
}



extension OpenProject: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toProject", sender: self)
    }
    
}

extension OpenProject: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projectnames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = projectnames[indexPath.row]
        
        return cell
    }
}
    

