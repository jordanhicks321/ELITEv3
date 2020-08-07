//
//  Login.swift
//  DTIv2
//
//  Created by Dj Haven on 6/22/20.
//  Copyright © 2020 Dj Haven. All rights reserved.
//

import UIKit
import Foundation





class Login: UIViewController, UIGestureRecognizerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        
       
        }


    @IBOutlet weak var Username: UITextField!
    
    @IBOutlet weak var Password: UITextField!
    
    @IBAction func backPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "toHomePage", sender: self)
    }
    let defaults = UserDefaults.standard
    
    
    func invalidUsernamePassword() {
     DispatchQueue.main.async {
    // Create the action buttons for the alert.
    let defaultAction = UIAlertAction(title: "Agree",
                         style: .default) { (action) in
    }
    
    let alert = UIAlertController(title: "Invalid credentials",
          message: "UserName or Password is incorrect",
          preferredStyle: .alert)
    alert.addAction(defaultAction)
         
    self.present(alert, animated: true) {
       // The alert was presented
    }
     }}
    
    func agreeToTerms() {
        DispatchQueue.main.async {
       // Create the action buttons for the alert.
       let defaultAction = UIAlertAction(title: "Agree",
                            style: .default) { (action) in
       }
       
       let alert = UIAlertController(title: "Invalid credentials",
             message: "Please reenter user credentials",
             preferredStyle: .alert)
       alert.addAction(defaultAction)
            
       self.present(alert, animated: true) {
          // The alert was presented
       }
        }}
    
    func ServerError() {
     DispatchQueue.main.async {
    // Create the action buttons for the alert.
    self.dismiss(animated: false, completion: nil)
    let defaultAction = UIAlertAction(title: "Agree",
                         style: .default) { (action) in
    }
    
    let alert = UIAlertController(title: "Sorry,theres an issue with the server",
          message: "Please, contact IT",
          preferredStyle: .alert)
    alert.addAction(defaultAction)
         
    self.present(alert, animated: true) {
       // The alert was presented
    }
        
     }}
    
    
    
    
   func encrypt (input: String) -> String {
       var list = [String]()
       let josh = input
       for char in josh {
           let joshchar = String(char)
           switch joshchar {
           case "a" ..< "z", "A" ..< "Z","1" ..< "9"," ","!","@","#","$","%","^","&":
               let uniCode = UnicodeScalar(joshchar)
               print(joshchar)
               list.append((String(UnicodeScalar(uniCode!.value + 3)!)))
           default:
           print("nah")
       }}
       let joined = list.joined(separator: "")
       let reversed = String(joined.reversed())
       return reversed
   }
    
    
    
    struct Course {
        let token: String
        let id: Int
        
        init(json: [String: Any]){
            token = json["token"] as? String ?? ""
            id = json["id"] as? Int ?? -1
            
        }
    }
    func timeout() {
        ServerError()
        
    }
    func parsejson(data: Data){
        do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] else {return}
                     
                    
                    let course = Course(json: json)
                    let token = course.token
                    let id = course.id
                    defaults.set(id, forKey: "userId")
                    DispatchQueue.main.async {
                    self.dismiss(animated: false, completion: nil)
                    self.performSegue(withIdentifier: "toOpenProject", sender: self)
                    }
                } catch let jsonErr {
                    agreeToTerms()
                    print("Error serializing json:", jsonErr)
                    
                }
    }
    
    func loginAPI (input: String, input2: String)    {
        
       
     
        
        
          let semaphore = DispatchSemaphore (value: 0)

          var request = URLRequest(url: URL(string: "http://74.205.57.36:3000/login")!,timeoutInterval: Double.infinity)
          request.addValue(input, forHTTPHeaderField: "username")
          request.addValue(input2, forHTTPHeaderField: "password")

          request.httpMethod = "POST"
        
         
          
          let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                self.invalidUsernamePassword()
            
            
        
              return
            }
           self.parsejson(data: data)
            print(String(data: data, encoding: .utf8)!)
            semaphore.signal()
          }

          task.resume()
        
          DispatchQueue.main.asyncAfter(deadline: .now() + 10.0, execute: {
              self.ServerError()
              task.cancel()
              
          })
          
          
        }
    
    
    
    func callencrypt () {
    
            let encryptedUsername =  self.encrypt(input: Username.text!)
            let encryptedPassword =  self.encrypt(input: Password.text!)
            Username.text = ""
            Password.text = ""
            loginAPI(input: encryptedUsername, input2: encryptedPassword)
            let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.style = UIActivityIndicatorView.Style.gray
            loadingIndicator.startAnimating();

            alert.view.addSubview(loadingIndicator)
            present(alert, animated: true, completion: nil)
          
       }
   

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
     
    
    var x = ""

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if x == "yes" {
            return true
        } else {
            return false
        }
    }
    
    
    func checkpassword () {
        do {
        let userpassword = String(Password.text!)

        switch userpassword {
        case "a" ..< "z", "A" ..< "Z","1" ..< "9"," ","!","@","#","$","%","^","&":
            callencrypt()
        default:
            Username.text = ""
            Password.text = ""
            agreeToTerms()
        
        }}
               
           }
    
    
    
    
    @IBAction func LoginPressed(_ sender: Any) {
        do {
            let userusername = String(Username.text!)

            switch userusername {
            case "a" ..< "z", "A" ..< "Z","1" ..< "9"," ","!","@","#","$","%","^","&":
               checkpassword ()
            default:
                Username.text = ""
                Password.text = ""
                agreeToTerms()
            
            }}}
            
                
       
        
        
        


                
            
              
                
   
    

    
    
    
    

    
    
    
    
}

