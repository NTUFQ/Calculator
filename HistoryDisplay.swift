//
//  HistoryDisplay.swift
//  Calculator
//
//  Created by Fu Qiang on 9/4/15.
//  Copyright (c) 2015 Fu Qiang. All rights reserved.
//

import Foundation
import UIKit

class HistoryDisplay: UILabel {

    func addHistory(op: String){
        text! = text! + " " + op
    }
    
    func clearHistory(){
        text! = "History"
    }
}
