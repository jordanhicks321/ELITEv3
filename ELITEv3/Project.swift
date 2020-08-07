//
//  Project.swift
//  DTIv2
//
//  Created by Dj Haven on 6/23/20.
//  Copyright © 2020 Dj Haven. All rights reserved.
//

import Foundation
import UIKit
import Foundation



class Project: UIViewController {
   
    var tableView = UITableView()
    var button = dropDownBtn()
    var height = NSLayoutConstraint()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabeView()
        
        button = dropDownBtn.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        button.setTitle("Colors", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(button)
        
        button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        button.widthAnchor.constraint(equalToConstant: 150).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        button.dropView.dropDownOptions = ["Blue", "Grenn"]
        button.isHidden = true
        }
        
       
    
    @objc func buttonClicked(_ : UIButton) {
        print("Like")
    }
    
   
    
    
    
    @IBAction func ButtonPressed(_ sender: Any) {
        let semaphore = DispatchSemaphore (value: 0)

        var request = URLRequest(url: URL(string: "http://192.168.1.32:3000/newUser")!,timeoutInterval: Double.infinity)
        request.addValue("username", forHTTPHeaderField: "username")
        request.addValue("password", forHTTPHeaderField: "password")

        request.httpMethod = "POST"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
          print(String(data: data, encoding: .utf8)!)
          semaphore.signal()
        }

        task.resume()
        semaphore.wait()

    }
    
    func createbuttons(buttonname: String) {
        
        let button = UIButton.init(type: .system)
        button.frame = CGRect(x: 50.0, y: 150.0, width: 200.0, height: 52.0)
        button.setTitle(buttonname, for: .normal)
        button.layer.borderWidth = 5.0
        button.layer.borderColor = UIColor.white.cgColor
        button.backgroundColor = UIColor.black
        button.titleLabel?.textColor = UIColor.white
        button.tintColor = UIColor.white
        button.layer.cornerRadius = 15.0
        button.addTarget(self, action: #selector(buttonClicked(_ :)),
            for: .touchUpInside)
        self.view.addSubview(button)
        button.isHidden = true
        
        let userName = UILabel.init()
              userName.frame = CGRect(x: 10.0, y: 40.0, width: UIScreen.main.bounds.size.width - 20.0, height: 21.0)
              userName.text = "Swift Tutorial"
              userName.font = UIFont(name: "verdana", size: 20.0)
              self.view.addSubview(userName)
              userName.isHidden = true
    }
    
    
    
    func createlabels(labelname: String) {
        let userName = UILabel.init()
              userName.frame = CGRect(x: 10.0, y: 40.0, width: UIScreen.main.bounds.size.width - 20.0, height: 21.0)
              userName.text = labelname
              userName.font = UIFont(name: "verdana", size: 20.0)
              self.view.addSubview(userName)
              userName.isHidden = true
        
    }
    
    func createtextfield(labelname: String) {
       
        
        let txtUserName = UITextField(frame: CGRect(x: 10.0, y: 100.0, width: UIScreen.main.bounds.size.width - 20.0, height: 50.0 ))

               txtUserName.backgroundColor = .yellow
               txtUserName.borderStyle = .line
               txtUserName.keyboardAppearance = .dark
               txtUserName.keyboardType = .emailAddress
               
               self.view.addSubview(txtUserName)
               txtUserName.isHidden = true
    }
    
    func setTabeView() {
        
        tableView.frame = self.view.frame
        tableView.backgroundColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.isHidden = true
    }
}
extension Project: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "\(indexPath)"
        return cell
    }
}

class dropDownBtn: UIButton, dropDownProtocol {
    func dropDownPressed(string: String) {
        self.setTitle(string, for: .normal)
        self.dismissDropDown()
    }
    
    
    var dropView = dropDownView()
    var height = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.darkGray
        
        dropView = dropDownView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        dropView.delegate = self
        dropView.translatesAutoresizingMaskIntoConstraints = false
        
        
    
    }
    
    
    override func didMoveToSuperview() {
            self.superview?.addSubview(dropView)
            self.superview?.bringSubviewToFront(dropView)
            dropView.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            dropView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            dropView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
            height = dropView.heightAnchor.constraint(equalToConstant: 0)
    }
    var isOpen = false
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isOpen == false {
            
            isOpen = true
            
            NSLayoutConstraint.deactivate([self.height])
            
            if self.dropView.tableView.contentSize.height > 150{
                self.height.constant = 150
            } else {
                self.height.constant = self.dropView.tableView.contentSize.height 
                }
                
            
            
            NSLayoutConstraint.activate([self.height])
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.dropView.layoutIfNeeded()
                self.dropView.center.y += self.dropView.frame.height / 2
            }, completion: nil)
            
        } else {
            isOpen = false
            NSLayoutConstraint.deactivate([self.height])
            self.height.constant = 0
            NSLayoutConstraint.activate([self.height])
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.dropView.center.y -= self.dropView.frame.height / 2
                self.dropView.layoutIfNeeded()
            }, completion: nil)
        }
    }
    func dismissDropDown() {
        isOpen = false
        NSLayoutConstraint.deactivate([self.height])
        self.height.constant = 0
        NSLayoutConstraint.activate([self.height])
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.dropView.center.y -= self.dropView.frame.height / 2
            self.dropView.layoutIfNeeded()
                  }, completion: nil)
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol dropDownProtocol {
    func dropDownPressed(string : String)
    }


class dropDownView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    var dropDownOptions = [String]()
    
    var tableView = UITableView()
    
    var delegate : dropDownProtocol!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView.backgroundColor = UIColor.darkGray
        self.backgroundColor = UIColor.darkGray
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(tableView)
        
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropDownOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        cell.textLabel?.text = dropDownOptions[indexPath.row]
        cell.backgroundColor = UIColor.darkGray
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate.dropDownPressed(string: dropDownOptions[indexPath.row])
        print(dropDownOptions[indexPath.row])
    }
}
