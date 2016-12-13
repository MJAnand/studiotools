//
//  ReproCheck.swift
//  StudioTools
//
//  Created by Tim Colley on 09/08/2016.
//  Copyright © 2016 GRJ. All rights reserved.
//

import Foundation

class ReproCheck : NSObject
{
    init(filesForArgs: [String], outputFile: String) {
        
        //NO PATHS REQUIRED THIS IS PURE OSA
        //CREATE A FOR EACH HERE TO HANDLE INCOMING ARRAY OF FILES
        let adaptor = PythonAdaptor()
        var outputFiles = [String]()
        var home = NSHomeDirectory()
        home = home + "/Desktop"
        print(home)
        print("\n\n\n")
        for file in filesForArgs {
            print(file)
            var myScript: String = "with timeout of 604800 seconds\n"
            myScript += "tell application \"Adobe InDesign CC 2017\"\n"
            myScript += "set user interaction level of script preferences to never interact\n"
            myScript += "activate without showing window\n"
            myScript += "set myProfile to preflight profile 3\n"
            myScript += "set objWorkingDocument to open (\"\(file)\")\n"
            myScript += "set myProcess to make preflight process with properties {target object:objWorkingDocument, applied profile:myProfile}\n"
            myScript += "wait for process myProcess\n"
            myScript += "set results to process results of myProcess\n"
            myScript += "if ((results as string) contains \"Errors Found\") then\n"
            myScript += "save report myProcess to \"\(file)preflight_report.pdf\"\n"
            //myScript += "print \path to desktop as String && "preflight_report.pdf\"\n"
            myScript += "else\n"
            myScript += "--display alert \"No Errors Found :-)\"\n"
            myScript += "end if\n"
            myScript += "delete myProcess\n"
            myScript += "close objWorkingDocument saving no\n"
            myScript += "end tell\n"
            myScript += "end timeout"
            var error: NSDictionary?
            let scriptObject = NSAppleScript(source: myScript)
            print(myScript)
        
            if let output: NSAppleEventDescriptor = scriptObject!.executeAndReturnError(&error)
            {
                print(output.stringValue)
            } else if (error != nil) {
                print("error: \(error)") //BUG OUT IF ERROR
            }
            let oFile = file + "preflight_report.pdf"
            outputFiles.append(oFile)
        }
        
        adaptor.executeJoin(outputFiles, outputFile: (home + "/Preflight"))
        let fileManager = NSFileManager.defaultManager()
        for file in outputFiles {
            let oFile = file //+ "preflight_report.pdf"
            outputFiles.append(oFile)
            do { try fileManager.removeItemAtPath(oFile) }
            catch let error as NSError { print("File Deletion Failure:   \(error)") }
        }
        
        print("[ReproCheck] . Moving Report File...")
        do { try fileManager.moveItemAtPath(home + "/Preflight.pdf" , toPath: outputFile + "Preflight_Report.pdf") }
        catch let error as NSError { print("File Move Error!: \(error)") }

        
        //END FOR EACH HERE
        
    }
}
