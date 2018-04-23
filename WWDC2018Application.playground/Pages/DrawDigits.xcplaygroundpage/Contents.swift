//: [Previous](@previous)

/*:
 
 # Now you can do the same thing, just with numbers instead of letters
 
 You might need numbers like 2, 0, 1, and 8 to have 2018 on your logo.
 
 # Go ahead!
 
 */

import UIKit
import PlaygroundSupport

let view = DrawView()
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true

let fontName = "HelveticaNeue-Light"
let size: CGFloat = 33.0

view.setFont(name: fontName, size: size)

PlaygroundPage.current.keyValueStore["font"] = .string(fontName)
PlaygroundPage.current.keyValueStore["size"] = .integer(Int(size))

//: [Next](@next)
