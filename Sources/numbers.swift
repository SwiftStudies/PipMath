import CoreGraphics

///
/// Constants useful for mathmatical and geometrical operations
///
public class Constants {
    /// Pi (π) ratio of a circle's circumference to its diameter
    public static let Pi : CGFloat = 3.14159265358979323846264338327950288419716939937510582097494459230781640628620899
}

///
/// Generates a random number between 0.0 and 1.0
///
public func random()->CGFloat{
    return random(from:0, to:1)
}

///
/// Generates a random number between the two supplied parameters
///
public func random(from from:CGFloat, to:CGFloat)->CGFloat{
    if from > to {
        return random(from:to, to:from)
    } else if from == to{
        return from
    }
    
    let delta = to - from
    
    return CGFloat(Float(arc4random()) / 0xFFFFFFFF) * delta + from
}

public func angle(degrees degrees:CGFloat)->CGFloat{
    return Constants.Pi * degrees / 180.0
}

///
/// An interpolation function
///
public typealias Interpolater = (start:CGFloat,end:CGFloat, position:CGFloat)->CGFloat

///
/// Interpolation functions
///
public enum Interpolation{
    
    /// Linear interpolation
    case Linear
    
    /// Cosine smoothed interpolation
    case Cosine
    
    /// Supply a custom interpolation function
    case Custom(function:Interpolater)
    
    public func apply(start start:CGFloat,end:CGFloat,position:CGFloat)->CGFloat{
        switch  self {
        case .Linear:
            return (start * (1 - position) + end * position)
        case .Cosine:
            return Interpolation.Linear.apply(start: start, end: end, position: (1 - cos(position * Constants.Pi)) / 2.0)
        case .Custom(let function):
            return function(start:start,end:end,position:position)
        }
    }
}

///
/// Extends CGFloat with operations useful for performing mathmatical or 
/// geometrical operations
///
public extension CGFloat{
    ///Assuming the float actually represents an angle in radians, use the degrees
    ///property to treat it in degrees
    var degrees : CGFloat {
        get {
            return self * 180.0 / Constants.Pi
        }
        
        set {
            self = angle(degrees:newValue)
        }
    }
    
    /// Assigns a random value to the variable between 0.0 and 1.0
    public mutating func randomize(){
        self = random(from:0.0, to:1.0)
    }
    
    /// Assigns a random value to the variable between from and to
    public mutating func randomize(from from:CGFloat, to:CGFloat){
        self = random(from:from, to:to)
    }
    
    /// Returns the smallest angle between this angle and another one
    public func smallestAngleBetween(other: CGFloat) -> CGFloat {
        let Pi2 = Constants.Pi * 2.0
        var angle = (other - self) % Pi2
        if (angle >= Constants.Pi) {
            angle = angle - Pi2
        }
        if (angle <= -Constants.Pi) {
            angle = angle + Pi2
        }
        return angle
    }
    
    /// Rounds a number to the specified number of decimal places
    func rounded(toDecimals decimals: Int = 2) -> CGFloat {
        let workaround = (0..<decimals).reduce(1){ (initial:Int, other:Int) -> Int in
            initial * 10
        }
        let multiplier = pow(10, CGFloat(decimals))
        
        print (workaround)
        
        return round(CGFloat(workaround) * self) / CGFloat(workaround)
    }
    
    /// Interpolates between his number and another given a percentage through 
    /// transition the point is. The interpolation function can be optionally
    /// supplied
    public func interpolateBetween(end:CGFloat, position:CGFloat, function:Interpolation = .Linear)->CGFloat{
        return function.apply(start:self,end:end,position:position)
    }
}

public extension CGPoint{
    ///
    /// Returns the distance from 0,0
    ///
    public var distanceFromOrigin : CGFloat {
        return distanceBetween(otherPoint: CGPointZero)
    }
    
    ///
    /// Returns the normalized form of the point (maintaining the angle
    /// but keeping the two points between 0.0 and 1.0
    ///
    public var normalized : CGPoint {
        let distance = distanceFromOrigin
        
        
        return distance > 0 ? CGPoint(x: x / distance, y: y / distance) : CGPointZero
    }
    
    /// Returns the angle the line is on
    public var angle: CGFloat {
        return atan2(y, x)
    }
    
    ///
    /// Returns the distance between two points
    ///
    public func distanceBetween(otherPoint point:CGPoint)->CGFloat{
        let dx = point.x - x
        let dy = point.y - y
        
        return sqrt(dx*dx + dy*dy)
    }
    
    
    ///
    /// Add points together
    ///
    public func add(point point:CGPoint)->CGPoint{
        return CGPoint(x: x + point.x, y: y + point.y)
    }
    
    ///
    /// Subtract one point from the other
    ///
    public func subtract(point point:CGPoint)->CGPoint{
        return CGPoint(x: x - point.x, y: y - point.y)
    }
    
    ///
    /// Subtract one point from the other
    ///
    public func multiply(by float:CGFloat)->CGPoint{
        return CGPoint(x: x * float, y: y * float)
    }
    
    ///
    /// Interpolates linearly between two points
    ///
    public func interpolateBetween(endPoint:CGPoint, position:CGFloat, function:Interpolation = .Linear)->CGPoint{
        return CGPoint(
            x: x.interpolateBetween(endPoint.x, position: position, function: function),
            y: y.interpolateBetween(endPoint.y, position: position, function: function)
        )
    }
}