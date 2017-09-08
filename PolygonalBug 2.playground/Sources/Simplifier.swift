import SpriteKit

//returns the distance between 2 given points
func getDist(pointA: CGPoint, pointB: CGPoint) -> CGFloat{
    let distX = pointB.x - pointA.x
    let distY = pointB.y - pointA.y
    return sqrt(abs((distX*distX) + (distY*distY)))
}

//returns the angle of a segment
func getAngle(pointA: CGPoint, pointB: CGPoint) -> Int{
    let pi = CGFloat(3.14159)
    let distX = abs(pointB.x - pointA.x)
    let distY = abs(pointB.y - pointA.y)
    return Int(atan2(distY, distX)*180/pi)
}

//simplifies the curve, based on angles and distance
func simplifySeg(pointA: CGPoint, pointB: CGPoint, pointC: CGPoint) -> Bool{
    var firstAngle = abs(getAngle(pointA: pointA, pointB: pointB))
    var secondAngle = abs(getAngle(pointA: pointB, pointB: pointC))
    if firstAngle > 90 { firstAngle = 180 - firstAngle }
    if secondAngle > 90 { secondAngle = 180 - secondAngle }
    let angleDiff = abs(secondAngle - firstAngle)
    
    if angleDiff > 15 {
        let pointsDistAC = getDist(pointA: pointA, pointB: pointC)
        if pointsDistAC > 50 {
            return true
        }
    }
    return false
}

//sets the color based on the position of the objects
func colorSelect(position: CGPoint) -> SKColor{
    let option = abs(Int((position.x - position.y) / 100))
    switch option {
    case 0:
        return SKColor(red: 232/255, green: 74/255, blue: 95/255, alpha: 1)
    case 1:
        return SKColor(red: 244/255, green: 104/255, blue: 122/255, alpha: 1)
    case 2:
        return SKColor(red: 255/255, green: 188/255, blue: 183/255, alpha: 1)
    case 3:
        return SKColor(red: 163/255, green: 81/255, blue: 92/255, alpha: 1)
    default:
        return SKColor(red: 117/255, green: 72/255, blue: 78/255, alpha: 1)
    }
}
