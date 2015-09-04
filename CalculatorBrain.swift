//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Fu Qiang on 9/3/15.
//  Copyright (c) 2015 Fu Qiang. All rights reserved.
//

import Foundation

class CalculatorBrain {
    private enum Op: Printable//protocol
    {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double,Double) -> Double)
        //case PushConstant(String, Double)
        
        var description: String{
            get{
                switch self{
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                //case .PushConstant(let symbol, _):
                    //return symbol
                }
            }
        }
    }
    
    private var opStack = [Op]()//initializer
    
    private var operationDictionary = Dictionary<String, Op>()
    
    init(){
        operationDictionary["+"] = Op.BinaryOperation("+"){ $0 + $1 }
        operationDictionary["−"] = Op.BinaryOperation("−"){ $0 - $1 }
        operationDictionary["×"] = Op.BinaryOperation("×"){ $0 * $1 }
        operationDictionary["÷"] = Op.BinaryOperation("÷"){ $0 / $1 }
        operationDictionary["sin"] = Op.UnaryOperation("sin", sin)
        operationDictionary["cos"] = Op.UnaryOperation("cos", cos)
        operationDictionary["√"] = Op.UnaryOperation("√", sqrt)
        operationDictionary["±"] = Op.UnaryOperation("±") { -$0 }
        operationDictionary["π"] = Op.Operand(M_PI)
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]){
        //ops is inmutable here, because in swift, array is a Struct. Struct is simialr to Calss, but Struct doesn't have inheritage, and it is passed by value instead of reference. enum is also a Struct.
        var remainingOps = ops
        if !remainingOps.isEmpty{
            let op = remainingOps.removeLast()
            switch op{
            case .Operand(var operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, var operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), remainingOps)
                }
            case .BinaryOperation(_, var operation):
                let operand1Evaluation = evaluate(remainingOps)
                if let operand1 = operand1Evaluation.result{
                    let operation2Evaluation = evaluate(operand1Evaluation.remainingOps)
                    if let operand2 = operation2Evaluation.result{
                        return(operation(operand1,operand2),operation2Evaluation.remainingOps)
                    }
                }
                
            }
        }
        return(nil,ops)
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        println("\(opStack) = \(result), with \(remainder) left over.")
        return result
    }
    
    func pushOperand(operand: Double) -> Double?{
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(Symbol: String) -> Double?{
        if let operation = operationDictionary[Symbol]{
            opStack.append(operation)
        }
        return evaluate()
    }
    
    func clearStack() {
        opStack.removeAll()
    }
}
