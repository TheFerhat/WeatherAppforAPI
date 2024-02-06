//
//  SecondViewController.swift
//  WeatherApp
//
//  Created by Ferhat Ayar on 6.02.2024.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet weak var sehirLabel: UITextField!
    var selectedSehir = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hidKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        
    }
    
    @objc func hidKeyboard(){
        view.endEditing(true)
    }
    
    @IBAction func showButtonClicked(_ sender: Any) {
        selectedSehir = sehirLabel.text!
        performSegue(withIdentifier: "toLastVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toLastVC" {
            let destination = segue.destination as! LastViewController
            destination.chosenSehir = selectedSehir
        }
    }
    
}
