//
//  ImageReport.swift
//  StudioTools
//
//  Created by Tim Colley on 09/08/2016.
//  Copyright © 2016 GRJ. All rights reserved.
//

import Foundation

class ImageReport : NSObject
{
    init(filesForArgs: String) {
        
        var bundlepath = String(describing: Bundle.main)
        bundlepath = bundlepath.replacingOccurrences(of: "> (loaded)", with: "")
        bundlepath = bundlepath.replacingOccurrences(of: "NSBundle <", with: "")
       
        var myScript: String = "with timeout of 604800 seconds\n"
        myScript += "tell application \"Adobe InDesign CC\"\n"
        myScript +=  "set user interaction level of script preferences to never interact \n"
        myScript += "activate\n"
        myScript += "set js to \"#include '\"\n"
        myScript += "set js to js & \"\(String(describing: String(bundlepath)))/Contents/Resources/ImageReport.jsx';\"\n"
        myScript += "set js to js & \"main(arguments);\"\n"
        myScript += "do script js with arguments {\(filesForArgs)} language javascript\n"
        myScript += "end tell\n"
        myScript += "end timeout\n"
        var error: NSDictionary?
        let scriptObject = NSAppleScript(source: myScript)
        print(myScript)
        
        if let output: NSAppleEventDescriptor = scriptObject!.executeAndReturnError(
            &error) {
                print(output.stringValue ?? " ")
        } else if (error != nil) {
            print("error: \(String(describing: error))")
        }
        
    }
}
