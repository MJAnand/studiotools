//
//  ViewController.swift
//  StudioTools
//
//  Created by Tim Colley on 09/08/2016.
//  Copyright © 2016 GRJ. All rights reserved.
//

import Cocoa
import Python

public class ViewController: NSViewController {
    let utils = Util()
    var job = Job()
    var systemNotification = SystemNotifications()
    var fileTag: String = ""
    var startPageNumber: Double = 1.00
    var tag = ""
    var destButtonFolder = ""
    
    @IBOutlet weak var rdoEb300: NSButton!
    @IBOutlet weak var rdoEb72: NSButton!
    @IBOutlet weak var chkEnableFNOverride: NSButton!
    @IBOutlet weak var chkEnableSplit: NSButton!
    @IBOutlet weak var lblFileNaming: NSTextField!
    @IBOutlet weak var lblPageNumbering: NSTextField!
    @IBOutlet weak var txtFileNameOverrideValue: NSTextField!
    @IBOutlet weak var chkEnableTags: NSButton!
    @IBOutlet weak var rdoTag1st: NSButton!
    @IBOutlet weak var rdoTag2nd: NSButton!
    @IBOutlet weak var rdoTag3rd: NSButton!
    @IBOutlet weak var rdoTagFinal: NSButton!
    @IBOutlet weak var rdoTagPrint: NSButton!
    @IBOutlet weak var rdoTagResupply: NSButton!
    @IBOutlet weak var txtStartNumber: NSTextField!
    @IBOutlet weak var spnPgNum: NSStepper!
    @IBOutlet weak var chkAddNumbering: NSButton!
    @IBOutlet weak var rdoSplitFiles: NSButton!
    @IBOutlet weak var rdoCombineFiles: NSButton!
    @IBOutlet weak var chkSpreads: NSButton!
    @IBOutlet weak var btnOpenDestination: NSButton!
    @IBOutlet weak var btnClear: NSButton!
    @IBOutlet weak var btnExit: NSButton!
    @IBOutlet weak var lblProcessPercentage: NSTextField!
    @IBOutlet weak var pbProgress: NSProgressIndicator!
    @IBOutlet weak var lblStatus: NSTextField!
    @IBOutlet weak var btnConvert: NSButton!
    @IBOutlet weak var btnRepro: NSButton!
    @IBOutlet weak var btnReport: NSButton!
    @IBOutlet weak var rdoRetainName: NSButton!
    
    override public func viewDidLoad() {
        super.viewDidLoad();
        resetWindow();
        var aasLocation = (NSFileManager.defaultManager().URLsForDirectory(.ApplicationSupportDirectory, inDomains: .UserDomainMask)[0]).absoluteString
        aasLocation = aasLocation!.stringByReplacingOccurrencesOfString("file://", withString: "")
        aasLocation = aasLocation!.stringByReplacingOccurrencesOfString("%20", withString: " ")
        aasLocation = aasLocation! + "StudioTools 2/"
        
        var bundlepath = String(NSBundle.mainBundle())
        bundlepath = bundlepath.stringByReplacingOccurrencesOfString("> (loaded)", withString: "")
        bundlepath = bundlepath.stringByReplacingOccurrencesOfString("NSBundle <", withString: "")
        
        print(aasLocation! + ", " + bundlepath + "/Contents/Resources/Application Support/")
    }
    override public var representedObject: AnyObject? { didSet { } }
    
    @IBAction func onQuit(sender: AnyObject)             { exit(0); }
    @IBAction func onExportPDF(sender: AnyObject)        { mainButtonController(1); resetWindow()}
    @IBAction func onPreflight(sender: AnyObject)        { mainButtonController(2); lockOptions()}
    @IBAction func onImageReport(sender: AnyObject)      { mainButtonController(3); lockOptions()}
    @IBAction func onClear(sender: AnyObject)            { resetWindow(); }
    @IBAction func onExecute(sender: AnyObject)          { executeJob(); }
    @IBOutlet weak var rdoTag: NSButton!
    
    func mainButtonController(ButtonID: Int)
    {
         switch (ButtonID) {
            case 1:    btnConvert.state = NSOnState;  btnRepro.state = NSOffState; btnReport.state = NSOffState;
            case 2:    btnConvert.state = NSOffState; btnRepro.state = NSOnState;  btnReport.state = NSOffState;
            case 3:    btnConvert.state = NSOffState; btnRepro.state = NSOffState; btnReport.state = NSOnState;
            default:   btnConvert.state = NSOnState;  btnRepro.state = NSOffState; btnReport.state = NSOffState;
        }
    }
    
    @IBAction func splitOrCombine(sender: AnyObject) {
        
        if (rdoSplitFiles.state == NSOnState) {
            rdoCombineFiles.state = NSOffState
            rdoRetainName.state = NSOffState
            txtStartNumber.enabled = true
            spnPgNum.enabled = true
            chkEnableFNOverride.enabled = false
            txtFileNameOverrideValue.enabled = false
        } else if (rdoCombineFiles.state == NSOnState) {
            rdoSplitFiles.state = NSOffState
            rdoRetainName.state = NSOffState
            txtStartNumber.enabled = false
            spnPgNum.enabled = false
            chkEnableFNOverride.enabled = true
            txtFileNameOverrideValue.enabled = false
        } else {
            rdoCombineFiles.state = NSOffState
            rdoSplitFiles.state = NSOffState
            txtStartNumber.enabled = false
            spnPgNum.enabled = false
            chkEnableFNOverride.enabled = false
            txtFileNameOverrideValue.enabled = false
        }
    }
    
    @IBAction func onSpin(sender: AnyObject) {
        txtStartNumber.stringValue = String(spnPgNum.stringValue)
        if (txtStartNumber.stringValue.characters.count < 2) { txtStartNumber.stringValue = "00" + txtStartNumber.stringValue; }
        if (txtStartNumber.stringValue.characters.count < 3) { txtStartNumber.stringValue = "0" + txtStartNumber.stringValue;  }
    }
    
    @IBAction func fnOverrideEnabler(sender: AnyObject) {
        if (chkEnableFNOverride.state == 1) { txtFileNameOverrideValue.enabled = true; txtFileNameOverrideValue.stringValue = ""; }
        if (chkEnableFNOverride.state == 0) { txtFileNameOverrideValue.enabled = false; txtFileNameOverrideValue.stringValue = "Enter New Name"; }
    }
    
    func resetWindow()
    {
        mainButtonController(1)
        txtFileNameOverrideValue.stringValue = "Enter New Name"
        txtFileNameOverrideValue.enabled = false
        txtStartNumber.stringValue = "001"
        txtStartNumber.enabled = false
        spnPgNum.enabled = false
        lblProcessPercentage.hidden = true
        pbProgress.hidden = true
        lblStatus.stringValue = "Welcome to Studiotools..."
        rdoCombineFiles.state = NSOffState
        rdoCombineFiles.enabled = true
        rdoSplitFiles.state = NSOffState
        rdoSplitFiles.enabled = true
        rdoRetainName.state = NSOnState
        rdoRetainName.enabled = true
        chkEnableTags.state = NSOffState
        chkEnableTags.enabled = true
        chkEnableFNOverride.enabled = true
        chkSpreads.enabled = true
        rdoTag1st.enabled = true
        rdoTag2nd.enabled = true
        rdoTag3rd.enabled = true
        rdoTagFinal.enabled = true
        rdoTagPrint.enabled = true
        rdoTagResupply.enabled = true
        fileTag = ""
        //lblPageNumbering color change

    }
    
    func lockOptions()
    {
        txtFileNameOverrideValue.stringValue = "Enter New Name"
        txtFileNameOverrideValue.enabled = false
        txtStartNumber.stringValue = "001"
        txtStartNumber.enabled = false
        spnPgNum.enabled = false
        lblProcessPercentage.hidden = true
        pbProgress.hidden = true
        lblStatus.stringValue = "Welcome to Studiotools..."
        rdoTag1st.enabled = false
        rdoTag2nd.enabled = false
        rdoTag3rd.enabled = false
        rdoTagFinal.enabled = false
        rdoTagPrint.enabled = false
        rdoTagResupply.enabled = false
        rdoCombineFiles.enabled = false
        rdoSplitFiles.enabled = false
        chkEnableTags.enabled = false
        chkEnableFNOverride.enabled = false
        chkSpreads.enabled = false
        rdoRetainName.enabled = false
        fileTag = ""
        //lblPageNumbering color change
    }
    
    func executeJob()
    {
        if (btnConvert.state == NSOnState) {
            
            lblStatus.stringValue = "Running Export..."
            job.addFilesToJob()
            let filesCollection: [File] = job.myFiles.returnFiles()
            if (filesCollection.count > 0)
            {
                let destinationPath = job.getDestinationFolder()
                if (destinationPath != "")
                {
                    let converter = ConvertToPDF()
                    let step = floor(Double((100/(filesCollection.count))))
                    pbProgress.hidden = false
                    lblProcessPercentage.hidden = false
                    pbProgress.minValue = 0
                    pbProgress.maxValue = 100
                    var counter: Double = 0
                    let stringNumber = txtStartNumber.stringValue
                    var startNum: Int!
                    startNum = Int(stringNumber)
                    var outputFiles: [String] = []
                    outputFiles.removeAll()
                    var opf = ""
                    print("\n\n")
                    print("[ViewController] . Running Export...\r")
                    for file in filesCollection
                    {
                        lblStatus.stringValue = "Processing : \(file.getFileName()).\(file.getFileType())"
                        let fn = file.returnFullPath()
                        var ep = "Approval Quality Output (Pages)"
                        tag = ""
                        ep = "Approval Quality Output (Pages)"
                        
                            if (rdoTag1st.state      == NSOnState) {
                                ep = "Approval Quality Output (Pages)";
                                if (chkEnableTags.state == NSOnState) { tag = " [1st Approval]"; }
                                if (chkSpreads.state == NSOnState) { ep = "Approval Quality Output (Spreads)" }
                            }
                            if (rdoTag2nd.state      == NSOnState) {
                                ep = "Approval Quality Output (Pages)";
                                if (chkEnableTags.state == NSOnState) { tag = " [2nd Approval]"; }
                                if (chkSpreads.state == NSOnState) { ep = "Approval Quality Output (Spreads)" }
                            }
                            if (rdoTag3rd.state      == NSOnState) {
                                ep = "Approval Quality Output (Pages)";
                                if (chkEnableTags.state == NSOnState) { tag = " [3rd Approval]"; }
                                if (chkSpreads.state == NSOnState) { ep = "Approval Quality Output (Spreads)" }
                            }
                            if (rdoTagFinal.state    == NSOnState) {
                                ep = "Print Quality Output (Pages)";
                                if (chkEnableTags.state == NSOnState) { tag = " [Final Approval]"; }
                                if (chkSpreads.state == NSOnState) { ep = "Print Quality Output (Spreads)" }
                            }
                            if (rdoTagPrint.state    == NSOnState) {
                                ep = "Print Quality Output (Pages)";
                                if (chkEnableTags.state == NSOnState) { tag = " [Print File]"; }
                                if (chkSpreads.state == NSOnState) { ep = "Print Quality Output (Spreads)" }
                            }
                            if (rdoTagResupply.state == NSOnState) {
                                ep = "Print Quality Output (Pages)";
                                if (chkEnableTags.state == NSOnState) { tag = " [Print Resupply]"; }
                                if (chkSpreads.state == NSOnState) { ep = "Print Quality Output (Spreads)" }
                            }
                            if (rdoEb72.state == NSOnState) {
                                ep = "eBrochure72 (Pages)";
                                if (chkEnableTags.state == NSOnState) { tag = " [72DPI eBrochure]"; }
                                if (chkSpreads.state == NSOnState) { ep = "eBrochure72 (Spreads)" }
                           }
                           if (rdoEb300.state == NSOnState) {
                               ep = "eBrochure300 (Pages)";
                               if (chkEnableTags.state == NSOnState) { tag = " [300DPI eBrochure]"; }
                               if (chkSpreads.state == NSOnState) { ep = "eBrochure300 (Spreads)" }
                           }
                        
                        opf = destinationPath + file.getFileName() + ".tmp"
                        counter += step
                        pbProgress.incrementBy(step)
                        lblProcessPercentage.stringValue = (String(format:"%.0f", counter) + "%")
                        outputFiles.append(opf)
                        converter.convertFile(fn, outputFilename: opf, exportProfile: ep)
                    }
                    let adaptor = PythonAdaptor()
                    if (rdoCombineFiles.state == NSOnState) {
                        lblStatus.stringValue = "Post-Processing: Combining files..."
                        if (chkEnableFNOverride.state == NSOnState) {
                            adaptor.executeJoin(outputFiles, outputFile: (destinationPath + txtFileNameOverrideValue.stringValue + tag))
                            let fileManager = NSFileManager.defaultManager()
                            print("[ViewController] . Erasing .tmp Files...")
                            for file in outputFiles {
                                do { try fileManager.removeItemAtPath(file) }
                                catch let error as NSError { print("[ViewController] . File Deletion Failure:   \(error)") }
                            }

                    } else if (rdoCombineFiles.state == NSOnState) {
                            adaptor.executeJoin(outputFiles, outputFile: (destinationPath + filesCollection[0].fileName + tag))
                            let fileManager = NSFileManager.defaultManager()
                            print("[ViewController] . Erasing .tmp Files...")
                            for file in outputFiles {
                                do { try fileManager.removeItemAtPath(file) }
                                catch let error as NSError { print("[ViewController] . File Deletion Failure:   \(error)") }
                            }
                    }
                    
                                            }
                    if (rdoSplitFiles.state == NSOnState) {
                        lblStatus.stringValue = "Post-Processing: Breaking down..."
                        adaptor.executeJoin(outputFiles, outputFile: (destinationPath + filesCollection[0].fileName + tag))
                        let fileManager = NSFileManager.defaultManager()
                        for file in outputFiles {
                            do { try fileManager.removeItemAtPath(file) }
                            catch let error as NSError { print("[ViewController] . File Deletion Failure:   \(error)") }
                        }
                        adaptor.executeSplit((destinationPath + filesCollection[0].fileName + tag), startNumber: startNum)
                        do { try fileManager.removeItemAtPath(destinationPath + filesCollection[0].fileName + tag + ".pdf") }
                            catch let error as NSError { print("[ViewController] . File Deletion Failure:   \(error)") }
                        }
                    }
                
                if (rdoRetainName.state == NSOnState){
                    let fileManager = NSFileManager.defaultManager()
                    for file in filesCollection {
                        print("[ViewController] . Renaming .tmp Files...")
                        do { try fileManager.moveItemAtPath(destinationPath + file.getFileName() + ".tmp" , toPath: destinationPath + file.getFileName() + tag + ".pdf") }
                            catch _ as NSError { print("[ViewController] . File Rename Error!: Item alredy exists")
                                do {
                                print("[ViewController] . Removing Item and resaving...")
                                try fileManager.removeItemAtPath(destinationPath + file.getFileName() + tag + ".pdf")
                                try fileManager.moveItemAtPath(destinationPath + file.getFileName() + ".tmp" , toPath: destinationPath + file.getFileName() + tag + ".pdf")
                                }
                                catch _ as NSError { print("[ViewController] . File replace error, either you don't have permission or the item no longer exists. Please check the destination folder and try again.") }
                            }
                    }
                }
                if (chkEnableFNOverride.state == NSOnState) {
                    let fileManager = NSFileManager.defaultManager()
                        print("[ViewController] . Renaming .tmp Files...")
                        do { try fileManager.moveItemAtPath((destinationPath + filesCollection[0].fileName + tag) + ".pdf" , toPath: destinationPath + txtFileNameOverrideValue.stringValue + tag + ".pdf") }
                        catch let error as NSError { print("File Rename Error!: \(error)")
                    }
                }
                
                    pbProgress.doubleValue = 100
                    lblProcessPercentage.stringValue = "100%"
                    lblStatus.stringValue = "Process Complete."
                    print("[ViewController] . Complete.")
                    destButtonFolder = destinationPath
                    systemNotification.push("Convert to PDF process complete.")
                } else{
                    lblStatus.stringValue = "Cancelled at destination selection."
                }
            } else {
                lblStatus.stringValue = "Cancelled at File selection."
            }
        
        if (btnRepro.state == NSOnState) {
            lblStatus.stringValue = "Running PreFlight..."
            job.addFilesToJob()
            let filesCollection: [File] = job.myFiles.filesList
            if (filesCollection.count > 0)
            {
                var filesForArgs = ""
                for file in filesCollection {
                    filesForArgs += "\"\(file.filePath)\(file.fileName).\(file.fileType)\"" + ", "
                }
                //trim the last two chars from the string - the last entry doesn't need ", "
                filesForArgs = filesForArgs.substringToIndex(filesForArgs.endIndex.predecessor())
                filesForArgs = filesForArgs.substringToIndex(filesForArgs.endIndex.predecessor())
                destButtonFolder = job.executeReproCheck(filesForArgs)
                resetWindow()
                systemNotification.push("Your Preflight is complete.")
            }
        }
        
        if (btnReport.state == NSOnState) {
            lblStatus.stringValue = "Running ImageReport..."
            //add each of the items we need to pass
            job.addFilesToJob()
            let filesCollection: [File] = job.myFiles.filesList
            if (filesCollection.count > 0)
            {
                    var filesForArgs = ""
                    for file in filesCollection {
                        filesForArgs += "\"\(file.filePath)\(file.fileName).\(file.fileType)\"" + ", "
                    }
               // print(filesForArgs)
                    //trim the last two chars from the string - the last entry doesn't need ", "
                    filesForArgs = filesForArgs.substringToIndex(filesForArgs.endIndex.predecessor())
                    filesForArgs = filesForArgs.substringToIndex(filesForArgs.endIndex.predecessor())
                    job.executeImageReport(filesForArgs)
                    resetWindow()
                    destButtonFolder = ""
                    systemNotification.push("Your ImageReport is complete\nyou may now print or export it.")
            }
        }
        
    }
    
    @IBAction func enableTagging(sender: AnyObject) {
            }
    
    
    @IBAction func selectFileTag(sender: AnyObject) {
        if (rdoTag1st.state == NSOnState)       { fileTag = " [1st Approval]";   }
        if (rdoTag2nd.state == NSOnState)       { fileTag = " [2nd Approval]";   }
        if (rdoTag3rd.state == NSOnState)       { fileTag = " [3rd Approval]";   }
        if (rdoTagFinal.state == NSOnState)     { fileTag = " [Final Approval]"; }
        if (rdoTagPrint.state == NSOnState)     { fileTag = " [Print File]";     }
        if (rdoTagResupply.state == NSOnState)  { fileTag = " [Resupply]";       }
        
    }
    
    @IBAction func btnOpenLoc(sender: AnyObject) {
        
        NSWorkspace.sharedWorkspace().selectFile(nil, inFileViewerRootedAtPath: destButtonFolder)
        
    }
    
}



