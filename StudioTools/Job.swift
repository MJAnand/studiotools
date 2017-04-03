//
//  Job.swift
//  StudioTools
//
//  Created by Tim Colley on 09/08/2016.
//  Copyright © 2016 GRJ. All rights reserved.
//
//
// Object container class for the Files object, provides functionl linkage between the source data
// and the applescript adaptor classes. also handles output locations and passes these to the adaptors
//
// if an error occurs during execution, the error is thrown here and handled by the error handler class
//

import Foundation
import Darwin
import AppKit

open class Job : NSObject
{
    //Load all modules for global access (we don't know at this point the requirement)
    let utils = Util()
    var myFiles = Files()
    var path: String!
    var filename: String!
    var filetype: String!
    
    //
    // Populate the Job with the array of files
    //
    func addFilesToJob() -> Int
    {
        let dialog = NSOpenPanel()
        
        dialog.title                   = "Choose your .indd file(s)"
        dialog.showsResizeIndicator    = true
        dialog.showsHiddenFiles        = false
        dialog.canChooseDirectories    = true
        dialog.canCreateDirectories    = true
        dialog.allowsMultipleSelection = true
        dialog.allowedFileTypes        = ["indd"]
        //utils.displayAlert("Opening")
        if (dialog.runModal() == NSModalResponseOK) {
            let results = dialog.urls // Pathnames of the files
            if (results.count > 0) {
                myFiles.removeAll()
                for result in results
                {
                    path = (result.deletingLastPathComponent().absoluteString) as String
                    path = path.replacingOccurrences(of: "file://", with: "")
                    path = path.replacingOccurrences(of: "%20", with: " ")
                    filename = result.lastPathComponent as String
                    filename = filename.replacingOccurrences(of: ".indd", with: "")
                    filetype = "indd"
                    myFiles.addFile(filename, type: filetype, path: path)
                }
            }
        } else {
            return -1 //Error - User Canceled
        }
        return 0 //Files Added ok
    }
    
    //
    // Populate the Job with the array of files
    //
    func getDestinationFolder() -> String
    {
        let dialog = NSOpenPanel()
        var destination = ""
        
        dialog.title                   = "Select Destination"
        dialog.showsResizeIndicator    = true
        dialog.showsHiddenFiles        = false
        dialog.canChooseDirectories    = true
        dialog.canCreateDirectories    = true
        dialog.allowsMultipleSelection = false
        dialog.canChooseFiles          = false
        
        if (dialog.runModal() == NSModalResponseOK) {
            let result = dialog.url // Pathnames of the files
                destination = result!.absoluteString
                destination = destination.replacingOccurrences(of: "file://", with: "")
                destination = destination.replacingOccurrences(of: "%20", with: " ")
        } else {
             //Error - User Canceled
        }
        return destination
    }

    
    //func executeConvert() -> Int
    ///{
    //           return 0
    //}
    
    func executeReproCheck(_ files: String) -> String
    {
        //addFilesToJob()
        let filesCollection: [String] = myFiles.returnSimpleCollection()
        let outputLocation = self.getDestinationFolder()
        _ = ReproCheck(filesForArgs: filesCollection, outputFile: outputLocation)
        return outputLocation
    }
    
    func executeImageReport(_ files: String)
    {
        _ = ImageReport(filesForArgs: files)
    }
    
    
    //return a simple string of the files
    func toString() -> String
    {
        var output = ""
        
        for file in (myFiles.returnFiles())
        {
            output += "File: "
            output += file.returnFullPath()
            output += "\n"
        }
        return output
    }
    
}
