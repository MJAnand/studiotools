//
//  util.swift
//  StudioTools
//
//  Created by Tim Colley on 22/12/2015.
//  Copyright © 2015 GRJ. All rights reserved.
//

/*!

    @class Util
    @author Tim Colley
    @abstract Utility Class containing addon items for working with text, dates, numbers and opening verious dialogue boxes
    @updated 2016-01-08

*/

import Foundation
import Cocoa

class Util: NSObject {
    
    /*!
    
        @function convertNSDateToString
        @author Tim Colley
        @abstract Converts an NSDate object to Human readable date and time
        @param theDate NSDate
        @returns String
        @updated 2016-01-08
    
    */
    func convertNSDateToString(theDate: NSDate) -> String {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.stringFromDate(theDate)
        return date
    }
    
    /*!
    
        @function convertStringToNSDate
        @author Tim Colley
        @abstract Converts a properly formatted (DD-MM-YYYY) String object to an NSDate object
        @param theDate String
        @returns NSDate
        @updated 2016-01-08
    
    */
    func convertStringToNSDate(theDate: String) -> NSDate {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let stringDate = dateFormatter.dateFromString(theDate)
        return stringDate!
    }
    
    /*!
    
        @function displayAlert
        @author Tim Colley
        @abstract Displays a pop-up alert dialogue box
        @param alertText String
        @updated 2016-01-08
    
    */
    func displayAlert(alertText: String){
        let myPopup: NSAlert = NSAlert()
        myPopup.messageText = alertText
        myPopup.informativeText = ""
        myPopup.alertStyle = NSAlertStyle.Warning
        myPopup.runModal()
    }
    
    /*!
    
        @function intToString
        @author Tim Colley
        @abstract Converts an integer to a string
        @param number Int
        @returns String
        @updated 2016-01-08
    
    */
    func intToString(number: Int) -> String{
        let num2 = number as NSNumber
        return num2.stringValue
    }
    
    /*!
    
        @function convertBoolToString
        @author Tim Colley
        @abstract Converts a Booean object to a String object, returns standard True or False
        @param theValue Bool
        @returns String
        @updated 2016-01-08
    
    */
    func convertBoolToString(theValue: Bool) -> String {
        
        switch theValue {
        
        case true:
            return "true"
            
        case false:
            return "false"
            
        }
    }
}
