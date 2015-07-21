//
//  ViewController.swift
//  Caculator
//
//  Created by Lee on 2015/3/9.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  
  @IBOutlet weak var display: UILabel!
  @IBOutlet weak var log: UILabel!
	
  var userIsInTheMiddleOfTypeANumber = false
  var isFloat = false
  var brain = calculatorBrain()
	
  @IBAction func appendDigit(sender: UIButton) {
    let digit = sender.currentTitle!
	log.text = log.text! + digit
    if userIsInTheMiddleOfTypeANumber {
		if isFloat {
			if digit != "." {
				display.text = display.text! + digit
			}
		}
		else {
			display.text = display.text! + digit
			if digit == "." {
				isFloat = true
			}
		}
    } else {
		if isFloat {
			if digit != "." {
				display.text = display.text! + digit
			}
		}
		else {
			if digit == "." {
				isFloat = true
				display.text = "0."
			} else {
				display.text = digit
			}
			userIsInTheMiddleOfTypeANumber = true
			
		}
    }
  }
	
  @IBAction func operate(sender: UIButton) {
	log.text = log.text! + sender.currentTitle!
    let operation = sender.currentTitle!
    if userIsInTheMiddleOfTypeANumber {
      enter()
	}
	if let operation = sender.currentTitle {
		if let result = brain.performOperation(operation) {
			displayValue = result
		} else {
			displayValue = 0
		}
	}
  }
	
  @IBAction func enter() {
	userIsInTheMiddleOfTypeANumber = false
	if let result = brain.pushOperand(displayValue) {
		displayValue = result
	} else {
		displayValue = 0
	}
  }
	
  @IBAction func clear() {
	  display.text = "0"
	  log.text = ""
	  brain.clearStack()
  }
  var displayValue:Double {
    get {
      return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
    }
    set {
      display.text! = "\(newValue)"
      userIsInTheMiddleOfTypeANumber = false
	  isFloat = false
    }
  }
}

