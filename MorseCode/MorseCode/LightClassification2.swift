//
//  LightClassification2.swift
//  MorseCode
//
//  Created by Jonathan Huang on 10/14/23.
//
// Given a 3D array of binary thresholded values of 1s and 0s, figure out which one is part is flickering, read from that graph, and return a list of 1s and 0s.
import Foundation
import Vision

func stringToArr(strArr: String) -> [Int] {
       let results = strArr
                     .trimmingCharacters(in: CharacterSet(charactersIn: "[]"))
                     .components(separatedBy:", ")
                     .map { return Int($0.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))!}
       return results
   }
//output from Max plugs into here, imagine panes of 2D arrays

//
func detectFlicker(in array3D: [[[Int]]]) -> [Int]? {
    
    //makes sure that input is not null
    let depth = array3D.count
    guard depth > 0 else {
        return nil
    }
    
    //GENERAL GOALS:
    // Iterate through entire 2D array and procure time histories (Done through . Have a similarity threshold with surroundings with a cutoff. Ex: given two arrays that represent light history, how similar do they have to be (figured out through testing but can start with like 90% or something.


    // Group similar pixels. Out of y x y pixels, just average 1 and 0 by frame so if there are more 1s, the light source is on and vice versa
    // lightGroupings is a hashmap of all pixels organized into groups
    let lightGroupings = makeGroups(in: array3D)
    
    //Return is disabled for testing
    //return pickLightSource(in: lightGroupings)
    return [1]
    //
    
}

//Creates groups based off similarity
func makeGroups(in array3D: [[[Int]]]) -> [String : [[[Int]]]] {
    let depth = array3D.count
    let rows = array3D[0].count
    let cols = array3D[0][0].count
    
    // LightGroupings: Key is a 1D light history array (in string format), Value is a 2D array that represents every pixel and their light histories
    var lightGroupings: [String : [[[Int]]]] = [:]
    
    
    // Iterate through rows and columns
    for row in 0..<rows {
        for col in 0..<cols {
            
            var lightHistory = [Int]() //int array
            
            // Populate lightHistory with data from array3D
            for layer in 0..<depth {
                lightHistory.append(array3D[layer][row][col])
            }
            
            let groups = lightGroupings.keys
            var foundGroup = false
            
            // Iterate through the existing groups
            for group in groups {
                
                // Need to convert string array to array and plug array form into comparePixel
                if comparePixels(in: stringToArr(strArr: group), arr1: lightHistory) {
                    // Group below needs to be an array -> string
                    if var existingValue = lightGroupings[group] {
                        existingValue.append([lightHistory]) //dummy variable just to append to
                        lightGroupings.updateValue(existingValue, forKey: group)
                    }
                    foundGroup = true
                    break
                }
            }
            
            // If no matching group is found, create a new entry
            if !foundGroup {
                //lighthistory below needs to be a string for key and array for value
                lightGroupings[lightHistory.description] = [[lightHistory]]
            }
        }
    }
    
    // Update the keys to be the average of all lightHistories of that group
    var updatedLightGroupings: [String : [[[Int]]]] = [:]
    //lightGroupings below need to be an array
    for (_, value) in lightGroupings {
        let avgKey = getAvg(in: value.flatMap { $0 }) // Flatten the last two dimensions of the 3D array to make it 2D
        // avgKey below has to be a string
        updatedLightGroupings[avgKey.description] = value
    }
    
    return updatedLightGroupings
}


func comparePixels(in arr0: [Int], arr1: [Int]) -> Bool {
    let leniancy = 0.9 //How similar the light histories have to be with each other in order to satisfy grouping
    
    var same = 0.0
    for index in 0..<arr0.count {
        if (arr0[index] == arr1[index]) {
            same += 1.0
        }
    }
    
    let similarity = same / Double(arr0.count)

    return similarity > leniancy
}

// Gets the average of the array of 1D arrays that are grouped by flicker rate (2D array). Returns a 1D array of the avg
func getAvg(in array2D: [[Int]]) -> [Int] {
    
    let rows = array2D.count
    let cols = array2D[0].count
    
    var avgHistory = [Int]()

    
    for col in 0..<cols {
        var numOnes = 0
        var numZeros = 0
        for row in 0..<rows {
            if (array2D[row][col] == 1) {
                numOnes += 1
            } else {
                numZeros += 1
            }
        }
        if numZeros > numOnes {
            avgHistory.append(0)
        } else {
            avgHistory.append(1)
        }
    }
    
    return avgHistory
}


// A little bit cheap, but analyze the keys/averages of the groupings and see if there is a pattern of 3 bits and 1 bit for dashes/dots

//Intuition: create a hashmap per key that has key: frequency of occurrances, value: # of contiguous 1s. At the end, sort
// 1) one is arond 3x the difference of the other
// 2) you hit the end and you just take the best you can do

//Deleted pickLightSource

