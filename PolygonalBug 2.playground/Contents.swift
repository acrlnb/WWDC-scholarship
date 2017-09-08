/*:
 
        IN BUGS WE TRUST
         code by acrlnb
          2017  0.9.2
 
thanks to BEPiD for forcing me to learn how to (kinda) code once and for all
*/

// Protip: try dragging the dots around


import SpriteKit
import PlaygroundSupport

let view = SKView (frame: CGRect(x: 0, y: 0, width: 800, height: 1000))
let scene = DrawingBoard(size: CGSize(width: 800, height: 1000))

PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true
view.presentScene(scene)
