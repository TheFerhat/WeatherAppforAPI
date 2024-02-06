//
//  LastViewController.swift
//  WeatherApp
//
//  Created by Ferhat Ayar on 6.02.2024.
//

import UIKit
import CoreData

class LastViewController: UIViewController {
    
    @IBOutlet weak var sehirLabel: UILabel!
    @IBOutlet weak var dereceLabel: UILabel!
    @IBOutlet weak var ruzgarLabel: UILabel!
    
    var chosenSehir = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hidKeyboard))
        view.addGestureRecognizer(gestureRecognizer)

        getData()
        
    }
    
    @objc func hidKeyboard(){
        view.endEditing(true)
    }
    
    func getData(){
        
        sehirLabel.text = chosenSehir
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(chosenSehir)&appid=81553a114bc16e43e474d44f39fe09b3")
        let session = URLSession.shared
        let data = session.dataTask(with: url!) { data, response, error in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }else {
                if data != nil {
                    do{
                        let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String,Any>
                        DispatchQueue.main.async{
                            if let main = jsonResponse["main"] as? [String : Any] {
                                if let temp = main["temp"] as? Double {
                                    let derece = Int(temp - 273.15)
                                    self.dereceLabel.text = String(derece)
                                }
                            }
                            if let wind = jsonResponse["wind"] as? [String : Any] {
                                if let speed = wind["speed"] as? Double {
                                    self.ruzgarLabel.text = String(speed)
                                }
                            }
                        }
                    }catch{
                        print("error")
                    }
                }
            }
        }
        data.resume()
    }
    
    @IBAction func favButtonClicked(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newWeathers = NSEntityDescription.insertNewObject(forEntityName: "Weathers", into: context)
        newWeathers.setValue(sehirLabel.text, forKey: "sehir")
        newWeathers.setValue(UUID(), forKey: "id")
        
        do{
            try context.save()
        }catch{
            print("error")
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newData"), object: nil)
        
        navigationController?.popToRootViewController(animated: true)
        
    }
    

}
