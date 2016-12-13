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
        
        var bundlepath = String(NSBundle.mainBundle())
        bundlepath = bundlepath.stringByReplacingOccurrencesOfString("> (loaded)", withString: "")
        bundlepath = bundlepath.stringByReplacingOccurrencesOfString("NSBundle <", withString: "")
       
        var myScript: String = "with timeout of 604800 seconds\n"
        myScript += "tell application \"Adobe InDesign CC 2015\"\n"
        myScript += "activate\n"
        myScript += "set js to \"#include '\"\n"
        myScript += "set js to js & \"\(String(bundlepath))/Contents/Resources/ImageReport.jsx';\"\n"
        myScript += "set js to js & \"main(arguments);\"\n"
        myScript += "do script js with arguments {\(filesForArgs)} language javascript\n"
        myScript += "end tell\n"
        myScript += "end timeout\n"
        var error: NSDictionary?
        let scriptObject = NSAppleScript(source: myScript)
        print(myScript)
        
        if let output: NSAppleEventDescriptor = scriptObject!.executeAndReturnError(
            &error) {
                print(output.stringValue)
        } else if (error != nil) {
            print("error: \(error)")
        }
        
    }
}
