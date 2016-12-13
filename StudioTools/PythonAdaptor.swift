//
//  PythonAdaptor.swift
//  StudioTools
//
//  Created by Tim Colley on 11/08/2016.
//  Copyright © 2016 GRJ. All rights reserved.
//

import Foundation

class PythonAdaptor: NSObject {
    
    let utils = Util()
    
    func executeJoin(inputFiles: [String], outputFile: String) {
    
        print("[PythonAdaptor] . Launching Script: /Library/Application Support/Studiotools 2/Python/join.py \r")
        print("[PythonAdaptor] . Combining PDF Files to: \(outputFile).pdf \r")
        let task = NSTask()
        task.launchPath = "/usr/bin/python"
        var args = ["/Library/Application Support/Studiotools 2/Python/join.py", "-v", "-o", "\(outputFile).pdf"]
        for file in inputFiles { args.append(file) }
        task.arguments = args
        task.launch()
        sleep(60)
        task.waitUntilExit()
    }
    
    func executeSplit(inputFile: String, startNumber: Int) {
        
        print("[PythonAdaptor] . Launching Script: /Library/Application Support/Studiotools 2/Python/split.py \r")
        print("[PythonAdaptor] . Breaking out PDF Files from: \(inputFile).pdf starting numbering at \(startNumber) \r")
        let task = NSTask()
        task.launchPath = "/usr/bin/python"
        let args = ["/Library/Application Support/Studiotools 2/Python/split.py", "\(inputFile).pdf", "\(startNumber)"]
        task.arguments = args
        task.launch()
        sleep(60)
        task.waitUntilExit()
    }
}
