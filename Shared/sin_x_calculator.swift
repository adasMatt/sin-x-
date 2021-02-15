//
//  sin_x_calculator.swift
//  sin(x)
//
//  Created by Matthew Adas on 2/12/21.
//

import Foundation
import SwiftUI
import CorePlot

// Create aliases that make it easier to pass in inputs as parameters.
typealias nthTermParameterTuple = (n: Int, x: Double)
typealias nthTermMultiplierHandler = (_ parameters: [nthTermParameterTuple]) -> Double
typealias ErrorHandler = (_ parameters: [ErrorParameterTuple]) -> Double
typealias ErrorParameterTuple = (n: Int, x: Double, sum: Double)

class Sin_X_Calculator: ObservableObject {
    
    var plotDataModel: PlotDataClass? = nil
    var plotError: Bool = false
    var sinX = 0.0
    
    
    /// calculate_sin_x
    /// - Parameter x: values of x in sin(x)
    /// - Returns: sin(x)
    /// This function limits the range of x to the first period of -π to π
    /// It calculates the value of the sine using a Taylor Series Expansion of sin(x)
    /*
                       oo                       2n - 1
                       __            n-1      x
        sin (x)  =    \        ( - 1)     --------
                      /__                 (2n - 1)!
                      n = 1
    */

    func calculate_sin_x(x: Double) -> Double {

        //var sinX = 0.0
        var xInRange = x
        //var cosX = 0.0
        let firstTerm = x
        
        if (xInRange > Double.pi) {
        
            repeat {
                xInRange -= 2.0*Double.pi
            } while xInRange > Double.pi
        
        }
        else if (xInRange < -Double.pi){
        
            repeat {
                xInRange += 2.0*Double.pi
            } while xInRange < -Double.pi
        
        }
        
        
        //sinX = calculate_sin(x: xInRange)
        //I don't believe it is beneficial to calculate sinX outside of this function since I don't have to subtract 1 and add it back after the sum
        if !plotError  {
            
            //set the Plot Parameters
            plotDataModel!.changingPlotParameters.yMax = 1.5
            plotDataModel!.changingPlotParameters.yMin = -1.5
            plotDataModel!.changingPlotParameters.xMax = 15.0
            plotDataModel!.changingPlotParameters.xMin = -1.0
            plotDataModel!.changingPlotParameters.xLabel = "n"
            plotDataModel!.changingPlotParameters.yLabel = "sin(x)"
            plotDataModel!.changingPlotParameters.lineColor = .red()
            plotDataModel!.changingPlotParameters.title = "sin(x) vs n"
            
            // Plot first point of sin
            //let dataPoint: plotDataType = [.X: 0.0, .Y: (1.0)]
            //plotDataModel!.appendData(dataPoint: [dataPoint])
        }
        else {
            
            //set the Plot Parameters
            plotDataModel!.changingPlotParameters.yMax = 18.0
            plotDataModel!.changingPlotParameters.yMin = -18.1
            plotDataModel!.changingPlotParameters.xMax = 15.0
            plotDataModel!.changingPlotParameters.xMin = -1.0
            plotDataModel!.changingPlotParameters.xLabel = "n"
            plotDataModel!.changingPlotParameters.yLabel = "Abs(log(Error))"
            plotDataModel!.changingPlotParameters.lineColor = .red()
            plotDataModel!.changingPlotParameters.title = "Error sin(x) vs n"

            var error = 0.0
                
            let actualsin_x = sin(x)
            
            //if actualsin_x != 0 then calculate the log of the error
            if(actualsin_x != 0.0){
                
                //another thing I don't need for sine
                
                //var numerator = 1.0 - actualcos_x
                var numerator = actualsin_x
                
                if(numerator == 0.0) {numerator = 1.0E-16}
                
                //wait what? This was originally the ratio between  1 - cos(x) and cos(x)?
                error = (log10(abs((numerator)/actualsin_x)))
                    
            }
            else {
                error = 0.0
            }
            // Plot first point of error
               
                let dataPoint: plotDataType = [.X: 1.0, .Y: (error)]
                plotDataModel!.appendData(dataPoint: [dataPoint])
                
        }

        // Calculate the infinite sum using the function that calculates the multiplier of the nth term in the series.
        
        sinX = calculate1DInfiniteSum(function: sinnthTermMultiplier, x: x, minimum: 1, maximum: 100, firstTerm: firstTerm, isPlotError: plotError, errorType: sinErrorCalculator  )
        
        print(sinX)
        
        return (sinX)


}

/// calculate1DInfiniteSum
/// - Parameters:
///   - function: function describing the nth term multiplier in the expansion
///   - x: value to be calculated
///   - minimum: minimum term in the sum usually 0 or 1
///   - maximum: maximum value of n in the expansion. Basically prevents an infinite loop
///   - firstTerm: First term in the expansion usually the value of the sum at the minimum
///   - isPlotError: boolean that describes whether to plot the value of the sum or the error with respect to a known value
///   - errorType: function used to calculate the log of the error when the exact value is known
/// - Returns: the value of the infite sum
func calculate1DInfiniteSum(function: nthTermMultiplierHandler, x: Double, minimum: Int, maximum: Int, firstTerm: Double, isPlotError: Bool, errorType: ErrorHandler ) -> Double {
        
        
    var plotData :[plotDataType] =  []

    var sum = 0.0
    var previousTerm = firstTerm
    var currentTerm = 0.0
    let lowerIndex = minimum + 1
        
    if isPlotError {
            
        let errorParameters: [ErrorParameterTuple] = [(n: 1, x: x, sum: previousTerm)]
            
        let error = errorType(errorParameters)
        let dataPoint: plotDataType = [.X: Double(1), .Y: (error)]
        plotData.append(contentsOf: [dataPoint])
            
            
    }
    else{
            
        let dataPoint: plotDataType = [.X: Double(minimum), .Y: (previousTerm)]
        plotData.append(contentsOf: [dataPoint])
            
        print("n is \(minimum), x is \(x), currentTerm = \(previousTerm)")
            
    }
        
        
        
    sum += firstTerm

    for n in lowerIndex...maximum {
        
        let parameters: [nthTermParameterTuple] = [(n: n, x: x)]
            
        // Calculate the infinite sum using the function that calculates the multiplier of the nth them in the series from the (n-1)th term.
        
        currentTerm = function(parameters) * previousTerm
            
        print("n is \(n), x is \(x), currentTerm = \(currentTerm)")
        sum += currentTerm
            
        print("The current ulp of sum is \(sum.ulp)")
            
        previousTerm = currentTerm
            
        if !isPlotError{
                
            let dataPoint: plotDataType = [.X: Double(n), .Y: (sum)]
            plotData.append(contentsOf: [dataPoint])
        }
        else{
                
            let errorParameters: [ErrorParameterTuple] = [(n: n, x: x, sum: sum)]
                
            let error = errorType(errorParameters)
            let dataPoint: plotDataType = [.X: Double(n), .Y: (error)]
            plotData.append(contentsOf: [dataPoint])
                
        }
            
        // Stop the summation when the current term is within machine precision of the total sum.
            
        if (abs(currentTerm) < sum.ulp){
                
            break
        }
        
        
    }

        plotDataModel!.appendData(dataPoint: plotData)
        return sum

    }
    
    //need to change all of this to sine still
    /// sinnthTermMultiplier
    /// - Parameter parameters: Tuple containing the value of x and n
    /// - Returns: nth term multiplier (first term on the right side of the equation below)
    ///
    //                               2
    //      th                    -x                     th
    //    n   term  =         ------------    *   (n - 1)    term
    //                       (2n-2) * (2n-1)
    //
    ///
    func sinnthTermMultiplier(parameters: [nthTermParameterTuple])-> Double{
        
        var nthTermMultiplier = 0.0
        let n = Double(parameters[0].n)
        let x = parameters[0].x
        
        let denominator = (2.0 * n - 2) * (2.0 * n - 1)
        
        nthTermMultiplier =  -1.0 / (denominator) * (x↑2.0)
        
        return (nthTermMultiplier)
        
    }
    
    /// sinErrorCalculator
        /// - Parameter parameters: Tuple containing the parameters necessary to calculate the error form the true value of the function
        /// - Returns: log10(error) This is effectively the negative of the number of digits to which the calculation is "true."
        func sinErrorCalculator(parameters: [ErrorParameterTuple])-> Double{
            
            var error = 0.0
            _ = Double(parameters[0].n)
            let x = parameters[0].x
            let sum = parameters[0].sum
            
            let actualsin_x = sin(x)
            
            if(actualsin_x != 0.0){
                
                var numerator = sum - actualsin_x
                
                if(numerator == 0.0) {numerator = sum.ulp}
                
                error = (log10(abs((numerator)/actualsin_x)))
                
                
            }
            else {
                error = 0.0
            }
            
            return (error)
            
        }
}
