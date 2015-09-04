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
    @IBOutlet weak var history: HistoryDisplay!
    
    private var brain = CalculatorBrain()
    
    private var userIsInTheMiddleOfTypingANumber = false
    private var decimalPointEnable = true
    
    private func clearAll(){
        history.clearHistory()
        brain.clearStack()
        displayValue = nil
        userIsInTheMiddleOfTypingANumber = false
        decimalPointEnable = true
    }
    
    private func removeDigit(){
        var displayLength = count(display.text!)
        if displayLength > 1 {
            if display.text!.removeAtIndex(display.text!.endIndex.predecessor()) == "."{
                decimalPointEnable = true
            }
        }
        else{
            displayValue = nil
            userIsInTheMiddleOfTypingANumber = false
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle{
            history.addHistory(operation + "=")
            displayValue = brain.performOperation(operation)
        }
    }
    
    @IBAction func sysOperate(sender: UIButton) {
        if let operation = sender.currentTitle {
            history.addHistory(operation)
            switch operation{
                case "C": clearAll()
                case "←": removeDigit()
                default: break
            }
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
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        decimalPointEnable = true
        displayValue = brain.pushOperand(displayValue!)
    }
    
    var displayValue: Double? {
        get{
            return NSNumberFormatter().numberFromString(display.text!)?.doubleValue
        }
        set{
            if newValue != nil {
                display.text = "\(newValue!)"
                //history.addHistory("0")
            }
            else {
                display.text = "0"
                //history.addHistory("0")
            }
            userIsInTheMiddleOfTypingANumber = false
        }
    }
}


