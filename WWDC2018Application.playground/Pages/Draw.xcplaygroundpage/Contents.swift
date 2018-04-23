/*:
 
 # We need to make a logo for WWDC!
 
 This is going to require some drawing skills.
 
 To make this logo, we are first going to have to figure out any text we need.
 
 # In the large white box, draw any characters which will be needed in your logo
 
 For example, you can draw a C for WWDC, or an L for the L in Apple.
 
 # Once you have drawn your character, press "CHECK" and a neural network will predict which character you have drawn.
 
*/

import UIKit
import PlaygroundSupport

let view = DrawView()
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true

/*:
 If it predicted incorrectly, press the __red__ button.
 
 # But if it predicted correctly, we can work with it!
 
 Customize the font of your letter through the variables below. Type the font you want and put the size you want as well. You can see it update in the smaller white box.
 
 Decrease the size if you can't see the full letter. Also, if your font name is incorrect, it will default to the Helvetica Neue font.
 
*/

let fontName = "HelveticaNeue-Light"
let size: CGFloat = 33.0

view.setFont(name: fontName, size: size)

PlaygroundPage.current.keyValueStore["font"] = .string(fontName)
PlaygroundPage.current.keyValueStore["size"] = .integer(Int(size))


/*:
 
 # Once you are finished, press the GREEN button.
 
 # Repeat this process until you have all the letters you need to include in your logo.
 
 You can draw the same letter multiple times. For example, you may need to draw two Ws in order to get both of the Ws included in WWDC
 */

//: [Next](@next)
