//
//  DetabTests.swift
//  SmarkDown
//
//  Copyright © 2016 Swift Studies. All rights reserved.
//

import XCTest
@testable import PipMath

class NumbersFloatTests: XCTestCase {

    func testConstants(){
        XCTAssert(Constants.Pi == CGFloat(M_PI), "Constant for Pi is incorrect")
    }
    
    func testDegrees(){
        XCTAssert(angle(degrees: 90) == Constants.Pi / 2.0, "Angle is incorrect")
        XCTAssert(angle(degrees: 180) == Constants.Pi, "Angle is incorrect")
        XCTAssert(angle(degrees: 270) == (Constants.Pi / 2.0) * 3.0, "Angle is incorrect")
        XCTAssert(angle(degrees: 360) == Constants.Pi * 2.0, "Angle is incorrect")
    }
    
    func testLinearInterpolation(){
        XCTAssert(Interpolation.Linear.apply(start: 0.0, end: 2.0,position: 0.0) == 0.0,"Linear interpolation should be 0.0")
        XCTAssert(Interpolation.Linear.apply(start: 0.0, end: 2.0,position: 0.5) == 1.0,"Linear interpolation should be 1.0")
        XCTAssert(Interpolation.Linear.apply(start: 0.0, end: 2.0,position: 1.0) == 2.0,"Linear interpolation should be 2.0")
    }

    func testCosineInterpolation(){
        XCTAssert(Interpolation.Cosine.apply(start: 0.0, end: 2.0,position: 0.0) == 0.0,"Cosine interpolation should be 0.0")
        XCTAssert(round(Interpolation.Cosine.apply(start: 0.0, end: 2.0,position: 0.5)) == 1.0,"Cosine interpolation should be 1.0")
        XCTAssert(Interpolation.Cosine.apply(start: 0.0, end: 2.0,position: 1.0) == 2.0,"Cosine interpolation should be 2.0")
    }
    
    func testCustomInterpolation(){
        
        let customInterpolation = Interpolation.Custom(function:{return ($1-$0)*$2})
        
        XCTAssert(customInterpolation.apply(start: 0.0, end: 2.0,position: 0.0) == 0.0,"Linear interpolation should be 0.0")
        XCTAssert(customInterpolation.apply(start: 0.0, end: 2.0,position: 0.5) == 1.0,"Linear interpolation should be 1.0")
        XCTAssert(customInterpolation.apply(start: 0.0, end: 2.0,position: 1.0) == 2.0,"Linear interpolation should be 2.0")
    }
    
    func testRounded(){
        
        let testData : [CGFloat: (source:CGFloat,roundTo:Int)] = [
            10.455 : (10.455, 3),
            10.46 : (10.455, 2),
            10.5 : (10.455, 1),
        ]
        
        for (expected, parameters) in testData {
            let result = parameters.source.rounded(toDecimals: parameters.roundTo)
            XCTAssert(result == expected, "Rounding error rounding \(parameters.source) to \(parameters.roundTo) should be \(expected) but was \(result)")
        }
    }
    
    func testSmallestAngle(){
        let angle360 = angle(degrees: 360)
        let angle270 = angle(degrees: 270)
        let angle180 = angle(degrees: 180)
        let angle90  = angle(degrees: 90)
        let angle10  = angle(degrees: 10)
        
        
        var result = angle360.smallestAngleBetween(angle10).rounded()
        XCTAssert(result == angle10.rounded(), "Should be \(angle10.rounded()) but was \(result.rounded())")

        result = angle270.smallestAngleBetween(angle180).rounded()
        XCTAssert(result == 0-angle90.rounded(), "Should be \(angle90.rounded()) but was \(result.rounded())")
    }
}
