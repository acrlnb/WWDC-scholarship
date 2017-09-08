import SpriteKit


//Archor points are the joints between two lines, can be moved by user
public class AnchorPoint {
    var anchor = SKShapeNode()
    var childLines : [Line] = []  //array of lines that join in that anchor
    init (position: CGPoint, color: SKColor) {
        self.anchor = SKShapeNode(circleOfRadius: 12.0)
        self.anchor.position = CGPoint(x: position.x, y: position.y)
        self.anchor.fillColor = color
        self.anchor.strokeColor = color
    }
    
    func updateAnchor(newPosition: CGPoint, color: SKColor) {
        self.anchor.position = newPosition
        self.anchor.fillColor = color
    }
}


// Lines make the drawing, they move according to the anchors
public class Line {
    var line: SKShapeNode
    var subPath: CGMutablePath
    var pointA: AnchorPoint
    var pointB: AnchorPoint
    
    init(inicialPoint: AnchorPoint, finalPoint: AnchorPoint, color: SKColor) {
        self.pointA = inicialPoint
        self.pointB = finalPoint
        self.subPath = CGMutablePath()
        self.subPath.move(to: inicialPoint.anchor.position)
        self.subPath.addLine(to: finalPoint.anchor.position)
        self.line = SKShapeNode(path: subPath)
        self.line.strokeColor = color
        self.line.lineWidth = 3.5
    }

    func updateLine() {
        subPath.move(to: pointA.anchor.position)
        subPath.addLine(to: pointB.anchor.position)
        self.line.path = subPath
        self.line.strokeColor = colorSelect(position: pointB.anchor.position)
    }
}



public class DrawingBoard: SKScene {
    
    var originalPath : [CGPoint] = [] //array of the original points
    var mainAnchors : [AnchorPoint] = [] //array of all anchors
    var move = false
    var anchorSelected: AnchorPoint!
    var clicked = false

//
    public override init(size:CGSize) {
        super.init(size: size)
        backgroundColor =  SKColor(red: 45/255, green: 42/255, blue: 43/255, alpha: 1)
    }
    
//
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

//
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! //pq faz isso 2x
        let location = touch.location(in: self)
        
        if mainAnchors.count > 1 {
            for i in 0..<mainAnchors.count{
                if mainAnchors[i].anchor.contains(location){
                    move = true
                    mainAnchors[i].anchor.strokeColor = SKColor.white
                    anchorSelected = mainAnchors[i]
                }
                else {
                    mainAnchors[i].anchor.strokeColor = colorSelect(position: mainAnchors[i].anchor.position)
                    
                }
            }
        }
        
        if !move {
            let newAnchor = AnchorPoint(position: location, color: colorSelect(position: location))
            mainAnchors.append(newAnchor)
            self.addChild(newAnchor.anchor)
        }
    }
    
//
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        clicked = true
        let touch = touches.first!
        let location = touch.location(in: self)
        var newAnchor: AnchorPoint
        var mainPath: Line

        if !move {
            originalPath.append(location)
            
            // creates anchors based on touch position and distance from previous points
            var count = mainAnchors.count
            let lengthPath = originalPath.count
                
            if lengthPath > 1 {
                let isDifferentEnough = simplifySeg(pointA: mainAnchors[count-1].anchor.position, pointB: originalPath[lengthPath-2], pointC: originalPath[lengthPath-1])
                if isDifferentEnough {
                    newAnchor = AnchorPoint(position: location, color: colorSelect(position: location))
                    mainAnchors.append(newAnchor)
                    count += 1
                    
                    if count > 1 {
                        mainPath = Line(inicialPoint: mainAnchors[count-2], finalPoint: mainAnchors[count-1], color: colorSelect(position: location))
                        mainAnchors[count-2].childLines.append(mainPath)
                        mainAnchors[count-1].childLines.append(mainPath)
                        self.addChild(mainPath.line)
                    }
                    
                    self.addChild(newAnchor.anchor)
                }
            }
            
            // draw lines while moving the points
            
        }
        
        if move { //creates the dragged effect
            for i in 0..<anchorSelected.childLines.count {
                anchorSelected.childLines[i].updateLine()
            }
            anchorSelected.updateAnchor(newPosition: location, color: colorSelect(position: location))
        }
    } // touchesMoved
    
    
//
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    
      if !move {
            var hasPosition = false
            var overPosition = -1
            var size = mainAnchors.count
            let touch = touches.first!
            let location = touch.location(in: self)
        
            for i in 0..<size {
                if mainAnchors[i].anchor.contains(location) {
                    hasPosition = true
                    overPosition = i
                }
            }

            if hasPosition == false {
                let newAnchor = AnchorPoint(position: location, color: colorSelect(position: location)) // adds an anchor point where the path ended
                mainAnchors.append(newAnchor)
                size = mainAnchors.count
                let mainPath = Line(inicialPoint: mainAnchors[size-2], finalPoint: mainAnchors[size-1], color: colorSelect(position: location))
                mainAnchors[size-2].childLines.append(mainPath)
                mainAnchors[size-1].childLines.append(mainPath)
                self.addChild(mainPath.line)
                self.addChild(newAnchor.anchor)
            }
            else {
                let mainPath = Line(inicialPoint: mainAnchors[size-1], finalPoint: mainAnchors[overPosition], color: colorSelect(position: location))
                mainAnchors[overPosition].childLines.append(mainPath)
                mainAnchors[size-1].childLines.append(mainPath)
                self.addChild(mainPath.line)
            }
        }
    
        move = false
    }
}
