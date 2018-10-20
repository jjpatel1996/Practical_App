//
//  FirstTaskVC.swift
//  Task2
//
//  Created by Jay Patel on 19/10/18.
//  Copyright © 2018 Jay Patel. All rights reserved.
//

import UIKit

class FirstTaskVC: UIViewController, UITextFieldDelegate {
    
    //Task 1 list
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var inputTextfield: UITextField!
    
    //Task 2 list
    @IBOutlet weak var inputTextfield2: UITextField!
    @IBOutlet weak var searchElementTextfield: UITextField!
    
    @IBOutlet weak var resulltLabel2: UILabel!
    
    let algorith = Algorithm()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputTextfield.addTarget(self, action: #selector(textdidChange(textfield:)), for: UIControl.Event.editingChanged)
        inputTextfield.delegate = self
        inputTextfield2.delegate = self
    }
    
    @objc func textdidChange(textfield:UITextField){
        
        //Convert text as array then mergeSort.
        guard textfield.text != nil && textfield.text != "" else {
            resultLabel.text = ""
            return
        }
        
        //Verify if it's array
        guard textfield.text!.contains(",") else {
            resultLabel.text = textfield.text
            return
        }
        
        var isFloat = false
        let stringArray = textfield.text!.components(separatedBy: ",").filter({
            if Int($0) != nil {
                return true
            }else if Float($0) != nil {
                isFloat = true
                return true
            }
            return false
        })
        
        if isFloat {
            resultLabel.text = algorith.mergeSort(stringArray.map({ Float($0)! })).description
        }else{
            resultLabel.text = algorith.mergeSort(stringArray.map({ Int($0)! })).description
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == inputTextfield2 {
            searchElementTextfield.becomeFirstResponder()
        }
        return true
    }
    
    @IBAction func PerformCheck(_ sender: Any) {
        
        //Check if Array list is proper
        //Check if element is written or not
        guard inputTextfield2.text != nil && inputTextfield2.text != "" else {
            resulltLabel2.text = "Enter array list"
            return
        }
        
        guard searchElementTextfield.text != nil && searchElementTextfield.text != "" else {
            resulltLabel2.text = "Enter search element"
            return
        }
        
        self.view.endEditing(true)
        
        let searchElement = searchElementTextfield.text!
        
        var isContainInvalidElement = false
        var isFloat = false
        let stringArray = inputTextfield2.text!.components(separatedBy: ",").filter({
            if Int($0) != nil {
                return true
            }else if Float($0) != nil {
                isFloat = true
                return true
            }
            isContainInvalidElement = true
            return false
        })
        
        guard !isContainInvalidElement else {
            resulltLabel2.text = "Array contain invalid type elements"
            return
        }
        
        if isFloat {
            if let floatValue = Float(searchElement) {
                resulltLabel2.text =  algorith.binarySearch(inputArr: stringArray.map({ Float($0)! }).sorted(), searchItem: floatValue) ? "Found" : "Not found"
            }else{
                resulltLabel2.text = "Search element type is not valid"
            }
            
        }else{
            if let intValue = Int(searchElement) {
                resulltLabel2.text =  algorith.binarySearch(inputArr: stringArray.map({ Int($0)! }).sorted(), searchItem: intValue) ? "Found" : "Not found"
            }else{
                resulltLabel2.text = "Search element type is not valid"
            }
        }
        
        
    }
    
    
}
