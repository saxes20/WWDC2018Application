//: [Previous](@previous)

/*:
 
 # Nice job! You're almost done!
 
 Now you can add the characters and digits you wrote to your own WWDC logo! There are also Apple logos which you can add on to your WWDC logo too.
 
 # Click and drag on one of the labels or images to move it onto the logo. You can then pinch or rotate the view to either expand, shrink, or rotate the image/label which has been selected. The selected image/label will be outlined in blue.
 
 */

import UIKit
import PlaygroundSupport


var theLetters: String? = nil
if let keyValue = PlaygroundPage.current.keyValueStore["letters"],
    case .string(let letters) = keyValue {
    theLetters = letters
}
theLetters
let lettersArr = theLetters?.characters.split{$0 == " "}.map(String.init)

var theDigits: String? = nil
if let keyValue = PlaygroundPage.current.keyValueStore["digits"],
    case .string(let digits) = keyValue {
    theDigits = digits
}
let digitsArr = theDigits?.characters.split{$0 == " "}.map(String.init)

var font: String? = nil
if let keyValue = PlaygroundPage.current.keyValueStore["font"],
    case .string(let fontName) = keyValue {
    font = fontName
}
font

var size: Int? = nil
if let keyValue = PlaygroundPage.current.keyValueStore["size"],
    case .integer(let sizeNum) = keyValue {
    size = sizeNum
}
size

//: Change the background of your image by setting the variable below to a different name. The options are wwdc13.jpg, wwdc13.jpg, wwdc14.png, wwdc15.png, wwdc16.png, or wwdc17.jpg

let bgName = "wwdc15.png"

let view = LogoView(characters: lettersArr!, digits: digitsArr!, font: font!, size: size!, background: bgName)
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true

/*:
 
 #  Once you're finished, press the DONE button, and take a screenshot of your final logo to save it. Thanks for playing!
 
 */



//: [Next](@next)
