//
//  CalculatorBrain.swift
//  Caculator
//
//  Created by Lee on 2015/3/12.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

import Foundation

class calculatorBrain {
	private enum Op :Printable {
		case Operand(Double)
		case UnaryOperatoin(String, Double -> Double)
		case BinaryOperation(String, (Double, Double) -> Double)
		case symbol(String)
		
		var description: String {
		  get {
			  switch self {
			  case .UnaryOperatoin(let symbol, _):
				  return "\(symbol)"
			  case .BinaryOperation(let symbol, _):
				  return "\(symbol)"
			  case .Operand(let operand):
				  return "\(operand)"
			case .symbol(let operand):
				return "\(operand)"
			}
		}
	}
  }
  
  private var opStack = [Op]()
  
  private var knowOps = [String: Op]()
  
  init() {
	func learnOps(op: Op) {
		knowOps[op.description] = op
	}
	learnOps(Op.BinaryOperation("×", *))
	learnOps(Op.BinaryOperation("+", +))
	learnOps(Op.BinaryOperation("−") { $1 - $0 })
	learnOps(Op.BinaryOperation("÷") { $1 / $0 })
	learnOps(Op.UnaryOperatoin("√", sqrt))
	learnOps(Op.UnaryOperatoin("Sin", sin))
	learnOps(Op.UnaryOperatoin("Cos", cos))
	learnOps(Op.symbol("pi"))
  }
	
	var program: AnyObject {//geranteed to be a PropertyList
		get {
			return opStack.map({$0.description})
		}
		set {
			if let opSymbols = newValue as? Array<String> {
				var newStack = [Op]()
				for opSymbol in opSymbols {
					if let op = knowOps[opSymbol] {
						newStack.append(op)
					}else if let operand = NSNumberFormatter().numberFromString(opSymbol)?.doubleValue {
						newStack.append(.Operand(operand))
					}
				}
			}
		}
	}
  private func evaluate(ops: [Op]) -> (result: Double?, remainingOp: [Op]) {
    if !ops.isEmpty {
      var remainingOps = ops
      let op = remainingOps.removeLast()
      switch op {
      case .Operand(let operand):
        return (operand, remainingOps)
	  case .symbol(let operand):
		if operand == "pi" {
			return (M_PI, remainingOps)}
      case .UnaryOperatoin(_, let operation):
        let operationEvaluation = evaluate(remainingOps)
        if let operand = operationEvaluation.result {
          return (operation(operand), operationEvaluation.remainingOp)
        }
      case .BinaryOperation(_, let operation):
        let op1Evaluation = evaluate(remainingOps)
        if let operand1 = op1Evaluation.result {
          let op2Evaluation = evaluate(op1Evaluation.remainingOp)
          if let operand2 = op2Evaluation.result {
            return (operation(operand1, operand2), op2Evaluation.remainingOp)
          }
        }
	default: break
      }
    }
    return (nil, ops)
  }
	func evaluate()->Double? {
		let (result, remainder) = evaluate(opStack)
		println("\(opStack) = \(result) with \(remainder) left over")
		return result
	}
  
  func pushOperand(operand: Double) -> Double? {
    opStack.append(Op.Operand(operand))
	return evaluate()
  }
  func performOperation(symble: String) -> Double? {
    if let operation = knowOps[symble] {
      opStack.append(operation)
    }
	return evaluate()
  }
	func clearStack() {
		opStack.removeAll(keepCapacity: false)
	}
}