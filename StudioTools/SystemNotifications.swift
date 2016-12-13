//
//  SystemNotifications.swift
//  StudioTools
//
//  Created by Tim Colley on 11/08/2016.
//  Copyright © 2016 GRJ. All rights reserved.
//

import Foundation

class SystemNotifications: NSObject {
    
    func push (message: String)
    {
        do {
            // create a User Notification
            let notification = NSUserNotification.init()
            
            // set the title and the informative text
            notification.title = "StudioTools"
            notification.informativeText = message
            
            // use the default sound for a notification
            notification.soundName = NSUserNotificationDefaultSoundName
            
            // if the user chooses to display the notification as an alert, give it an action button called "View"
            notification.hasActionButton = true
            notification.actionButtonTitle = "View"
            
            // Deliver the notification through the User Notification Center
            NSUserNotificationCenter.defaultUserNotificationCenter().deliverNotification(notification)
        }
    }
}