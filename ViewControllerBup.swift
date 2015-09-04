//
//  ViewController.swift
//  Calculator
//
//  Created by Fu Qiang on 8/30/15.
//  Copyright (c) 2015 Fu Qiang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    
    @IBOutlet weak var history: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false
    var decimalPointEnable = true
    
    func addHistory(op: String){
        history.text = history.text! + " " + op
    }
    
    func clearAll(){
        history.text = "History"
        displayValue = nil
        operandStack.removeAll()
    }
    
    func removeDigit(){
        var displayLength = count(display.text!)
        if displayLength > 1 {
            display.text!.removeAtIndex(display.text!.endIndex.predecessor())
        }
        else{
            display.text = "0"
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        addHistory(operation + "=")
        switch operation {
        case "C": clearAll()
        case "←": removeDigit()
        case "+": performOperation { $0 + $1 }
        case "−": performOperation { $0 - $1 }
        case "×": performOperation { $0 * $1 }
        case "÷": performOperation { $0 / $1 }
        case "√": performOperation { sqrt($0)}
        case "sin": performOperation { sin($0) }
        case "cos": performOperation { cos($0) }
        case "π": appendConstant(M_PI)
        case "±": performOperation { -$0 }
        default: break
        }
    }
    
    private func performOperation(operation: (Double,Double) -> Double){
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(),operandStack.removeLast())
            enter()
        }
    }
    
    private func performOperation(operation: Double -> Double){
        
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    private func appendConstant(constant: Double){
        enter()
        displayValue = constant
        enter()
    }
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if digit == "."{
            if decimalPointEnable{
                if userIsInTheMiddleOfTypingANumber{
                    display.text = display.text! + "."
                }
                else {
                    display.text = "0."
                    userIsInTheMiddleOfTypingANumber = true
                }
                decimalPointEnable = false
            }
        }
        else if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
        } else{
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    var operandStack = Array<Double>()
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        decimalPointEnable = true
        
        if (displayValue != nil) {
            operandStack.append(displayValue!)
        }
        addHistory(display.text!)
        println("operationStack = \(operandStack)")
    }
    
    var displayValue: Double? {
        get{
            return NSNumberFormatter().numberFromString(display.text!)?.doubleValue
        }
        set{
            if newValue != nil {
                display.text = "\(newValue!)"
            }
            else {
                display.text = "0"
            }
            userIsInTheMiddleOfTypingANumber = false
        }
    }
}


