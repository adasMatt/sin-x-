//
//  Tests_macOS.swift
//  Tests macOS
//
//  Created by Matthew Adas on 2/12/21.
//
//An example from Dr Terry:
//https://github.com/jterry94/Circle-With-Unit-Tests/blob/main/Tests%20macOS/Tests_macOS.swift
//in circle-with-unit-tests nothing is changed, only functions are added here

import XCTest

class Tests_macOS: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
/* idk do I need testOperators for sin
     func testOperators() throws {
             
             let exponent = 5.2↑2.0
             
             XCTAssertEqual(exponent, pow(5.2,2.0), accuracy: 1E-15)
             
             let factorial = 5❗️
             
             XCTAssertEqual(factorial, (1*2*3*4*5))
             
             let factorialDouble = 5.0❗️
             
             XCTAssertEqual(factorialDouble, (1.0*2.0*3.0*4.0*5.0), accuracy: 1E-15)
             
             let trickyFactorial = Double.pi❗️
             
             XCTAssertEqual(trickyFactorial, (7.1880827289760327021), accuracy: 5E-15)
             

             // Use recording to get started writing UI tests.
             // Use XCTAssert and related functions to verify your tests produce the correct results.
         }
     */
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func testSine() throws {
        
        let plotDataModel = PlotDataClass(fromLine: true)
        
        let sinCalculator = Sin_X_Calculator()
        
        sinCalculator.plotDataModel = plotDataModel
        
        //x = pi/2
        let piOverTwo = Double.pi / 2.0
        //the error after 12th term equals 1.0000000000000002
        let sin90 = sinCalculator.calculate_sin_x(x: piOverTwo)
        
        XCTAssertEqual(sin90, 1.0, accuracy: 1.0E-10)
        
        //x = pi/3
        let piOverThree = Double.pi / 3.0
        
        let sin60 = sinCalculator.calculate_sin_x(x: piOverThree)
        
        XCTAssertEqual(sin60, sin(piOverThree), accuracy: 1.0E-10)
        
        
    }
    /*
         func testCos() throws {
             
             let plotDataModel = PlotDataClass(fromLine: true)
             
             let cosCalculate = Cos_X_Calculator()
             
             cosCalculate.plotDataModel = plotDataModel
             
             let cos45 = cosCalculate.calculate_cos_x(x: 45.0*Double.pi/180.0)
             
             XCTAssertEqual(cos45, cos(45.0*Double.pi/180.0), accuracy: 5E-15)
             
             let cosPlus2Pi = cosCalculate.calculate_cos_x(x: (45.0*Double.pi/180.0)+2.0*Double.pi)
             
             XCTAssertEqual(cosPlus2Pi, cos(45.0*Double.pi/180.0), accuracy: 5E-15)
             
             let cosMinus2Pi = cosCalculate.calculate_cos_x(x: (45.0*Double.pi/180.0)-2.0*Double.pi)
             
             XCTAssertEqual(cosMinus2Pi, cos(45.0*Double.pi/180.0), accuracy: 5E-15)
             
             
     }
     */
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
