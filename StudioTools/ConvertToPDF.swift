//
//  ConvertToPDF.swift
//  StudioTools
//
//  Created by Tim Colley on 09/08/2016.
//  Copyright © 2016 GRJ. All rights reserved.
//

import Foundation


class ConvertToPDF : NSObject
{
    let utils = Util()
    func convertFile(_ inputFilename: String, outputFilename: String, exportProfile: String)
    {
        print("[AppleScript] . Pushing PDF to \(outputFilename) using profile: \(exportProfile) \r")
        var myScript: String = ""
        myScript +=  "with timeout of 86400 seconds \n"
        myScript +=  "tell application \"Adobe InDesign CC\" \n"
        myScript +=  "activate without showing window\n"
        myScript +=  "set user interaction level of script preferences to never interact \n"
        myScript +=  "set objWorkingDocument to open (\"" + inputFilename + "\") \n"
        myScript +=  "set properties of PDF export preferences to properties of PDF export preset \"" + exportProfile + "\"\r"
        myScript +=  "set page range of PDF export preferences to all pages \n"
        myScript +=  "tell objWorkingDocument \n"
        myScript +=  "export format PDF type to \"" + outputFilename + "\" with replacing \n"
        myScript +=  "close objWorkingDocument saving no \n"
        myScript +=  "end tell \n"
        myScript +=  "end tell \n"
        myScript +=  "end timeout \n"
        
        var error: NSDictionary?
        let scriptObject = NSAppleScript(source: myScript)
        
        if let output: NSAppleEventDescriptor = scriptObject!.executeAndReturnError(
            &error) {
                print("[AppleScript] . errors: \(String(describing: output.stringValue)) \r")
        } else if (error != nil) {
            let debugtest = error.debugDescription
            //utils.displayAlert(error.debugDescription)
            if (debugtest.range(of: "Cannot open the document") != nil) {
            utils.displayAlert("The File \"\(outputFilename)\" is Locked or Inaccessable and StudioTools can't continue until the lock is released. \n\nPlease check to be sure no-one else is using this file and click OK to try this file again.")
                print("[AppleScript] . File is Locked! Restarting Push Process for this file.\n")
                self.convertFile(inputFilename, outputFilename: outputFilename, exportProfile: exportProfile)
            }
            else {
                    utils.displayAlert("There is an issue with your StudioTools Support Files.\n\nEither the PDF or PreFlight profiles are missing or have not been installed correctly.\n\nPlease Contact Tim Colley (timcolley@greatrail.com) for assistance.")
                    print("[AppleScript] . Export profiles/Priflight profiles not configured, bugging out.")
                }
            
        }
        
    }
}
