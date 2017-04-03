//
//  ViewController.swift
//  StudioTools
//
//  Created by Tim Colley on 09/08/2016.
//  Copyright © 2016 GRJ. All rights reserved.
//

import Cocoa
import Python

open class ViewController: NSViewController {
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
    
    override open func viewDidLoad() {
        super.viewDidLoad();
        resetWindow();
        var aasLocation = (FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]).absoluteString
        aasLocation = aasLocation.replacingOccurrences(of: "file://", with: "")
        aasLocation = aasLocation.replacingOccurrences(of: "%20", with: " ")
        aasLocation = aasLocation + "StudioTools 2/"
        
        var bundlepath = String(describing: Bundle.main)
        bundlepath = bundlepath.replacingOccurrences(of: "> (loaded)", with: "")
        bundlepath = bundlepath.replacingOccurrences(of: "NSBundle <", with: "")
        
        print(aasLocation + ", " + bundlepath + "/Contents/Resources/Application Support/")
    }
    override open var representedObject: Any? { didSet { } }
    
    @IBAction func onQuit(_ sender: AnyObject)             { exit(0); }
    @IBAction func onExportPDF(_ sender: AnyObject)        { mainButtonController(1); resetWindow()}
    @IBAction func onPreflight(_ sender: AnyObject)        { mainButtonController(2); lockOptions()}
    @IBAction func onImageReport(_ sender: AnyObject)      { mainButtonController(3); lockOptions()}
    @IBAction func onClear(_ sender: AnyObject)            { resetWindow(); }
    @IBAction func onExecute(_ sender: AnyObject)          { executeJob(); }
    @IBOutlet weak var rdoTag: NSButton!
    
    func mainButtonController(_ ButtonID: Int)
    {
         switch (ButtonID) {
            case 1:    btnConvert.state = NSOnState;  btnRepro.state = NSOffState; btnReport.state = NSOffState;
            case 2:    btnConvert.state = NSOffState; btnRepro.state = NSOnState;  btnReport.state = NSOffState;
            case 3:    btnConvert.state = NSOffState; btnRepro.state = NSOffState; btnReport.state = NSOnState;
            default:   btnConvert.state = NSOnState;  btnRepro.state = NSOffState; btnReport.state = NSOffState;
        }
    }
    
    @IBAction func splitOrCombine(_ sender: AnyObject) {
        
        if (rdoSplitFiles.state == NSOnState) {
            rdoCombineFiles.state = NSOffState
            rdoRetainName.state = NSOffState
            txtStartNumber.isEnabled = true
            spnPgNum.isEnabled = true
            chkEnableFNOverride.isEnabled = false
            txtFileNameOverrideValue.isEnabled = false
        } else if (rdoCombineFiles.state == NSOnState) {
            rdoSplitFiles.state = NSOffState
            rdoRetainName.state = NSOffState
            txtStartNumber.isEnabled = false
            spnPgNum.isEnabled = false
            chkEnableFNOverride.isEnabled = true
            txtFileNameOverrideValue.isEnabled = false
        } else {
            rdoCombineFiles.state = NSOffState
            rdoSplitFiles.state = NSOffState
            txtStartNumber.isEnabled = false
            spnPgNum.isEnabled = false
            chkEnableFNOverride.isEnabled = false
            txtFileNameOverrideValue.isEnabled = false
        }
    }
    
    @IBAction func onSpin(_ sender: AnyObject) {
        txtStartNumber.stringValue = String(spnPgNum.stringValue)
        if (txtStartNumber.stringValue.characters.count < 2) { txtStartNumber.stringValue = "00" + txtStartNumber.stringValue; }
        if (txtStartNumber.stringValue.characters.count < 3) { txtStartNumber.stringValue = "0" + txtStartNumber.stringValue;  }
    }
    
    @IBAction func fnOverrideEnabler(_ sender: AnyObject) {
        if (chkEnableFNOverride.state == 1) { txtFileNameOverrideValue.isEnabled = true; txtFileNameOverrideValue.stringValue = ""; }
        if (chkEnableFNOverride.state == 0) { txtFileNameOverrideValue.isEnabled = false; txtFileNameOverrideValue.stringValue = "Enter New Name"; }
    }
    
    func resetWindow()
    {
        mainButtonController(1)
        txtFileNameOverrideValue.stringValue = "Enter New Name"
        txtFileNameOverrideValue.isEnabled = false
        txtStartNumber.stringValue = "001"
        txtStartNumber.isEnabled = false
        spnPgNum.isEnabled = false
        lblProcessPercentage.isHidden = true
        pbProgress.isHidden = true
        lblStatus.stringValue = "Welcome to Studiotools..."
        rdoCombineFiles.state = NSOffState
        rdoCombineFiles.isEnabled = true
        rdoSplitFiles.state = NSOffState
        rdoSplitFiles.isEnabled = true
        rdoRetainName.state = NSOnState
        rdoRetainName.isEnabled = true
        chkEnableTags.state = NSOffState
        chkEnableTags.isEnabled = true
        chkEnableFNOverride.isEnabled = true
        chkSpreads.isEnabled = true
        rdoTag1st.isEnabled = true
        rdoTag2nd.isEnabled = true
        rdoTag3rd.isEnabled = true
        rdoTagFinal.isEnabled = true
        rdoTagPrint.isEnabled = true
        rdoTagResupply.isEnabled = true
        fileTag = ""
        //lblPageNumbering color change

    }
    
    func lockOptions()
    {
        txtFileNameOverrideValue.stringValue = "Enter New Name"
        txtFileNameOverrideValue.isEnabled = false
        txtStartNumber.stringValue = "001"
        txtStartNumber.isEnabled = false
        spnPgNum.isEnabled = false
        lblProcessPercentage.isHidden = true
        pbProgress.isHidden = true
        lblStatus.stringValue = "Welcome to Studiotools..."
        rdoTag1st.isEnabled = false
        rdoTag2nd.isEnabled = false
        rdoTag3rd.isEnabled = false
        rdoTagFinal.isEnabled = false
        rdoTagPrint.isEnabled = false
        rdoTagResupply.isEnabled = false
        rdoCombineFiles.isEnabled = false
        rdoSplitFiles.isEnabled = false
        chkEnableTags.isEnabled = false
        chkEnableFNOverride.isEnabled = false
        chkSpreads.isEnabled = false
        rdoRetainName.isEnabled = false
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
                    pbProgress.isHidden = false
                    lblProcessPercentage.isHidden = false
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
                        pbProgress.increment(by: step)
                        lblProcessPercentage.stringValue = (String(format:"%.0f", counter) + "%")
                        outputFiles.append(opf)
                        converter.convertFile(fn, outputFilename: opf, exportProfile: ep)
                    }
                    let adaptor = PythonAdaptor()
                    if (rdoCombineFiles.state == NSOnState) {
                        lblStatus.stringValue = "Post-Processing: Combining files..."
                        if (chkEnableFNOverride.state == NSOnState) {
                            adaptor.executeJoin(outputFiles, outputFile: (destinationPath + txtFileNameOverrideValue.stringValue + tag))
                            let fileManager = FileManager.default
                            print("[ViewController] . Erasing .tmp Files...")
                            for file in outputFiles {
                                do { try fileManager.removeItem(atPath: file) }
                                catch let error as NSError { print("[ViewController] . File Deletion Failure:   \(error)") }
                            }

                    } else if (rdoCombineFiles.state == NSOnState) {
                            adaptor.executeJoin(outputFiles, outputFile: (destinationPath + filesCollection[0].fileName + tag))
                            let fileManager = FileManager.default
                            print("[ViewController] . Erasing .tmp Files...")
                            for file in outputFiles {
                                do { try fileManager.removeItem(atPath: file) }
                                catch let error as NSError { print("[ViewController] . File Deletion Failure:   \(error)") }
                            }
                    }
                    
                                            }
                    if (rdoSplitFiles.state == NSOnState) {
                        lblStatus.stringValue = "Post-Processing: Breaking down..."
                        adaptor.executeJoin(outputFiles, outputFile: (destinationPath + filesCollection[0].fileName + tag))
                        let fileManager = FileManager.default
                        for file in outputFiles {
                            do { try fileManager.removeItem(atPath: file) }
                            catch let error as NSError { print("[ViewController] . File Deletion Failure:   \(error)") }
                        }
                        adaptor.executeSplit((destinationPath + filesCollection[0].fileName + tag), startNumber: startNum)
                        do { try fileManager.removeItem(atPath: destinationPath + filesCollection[0].fileName + tag + ".pdf") }
                            catch let error as NSError { print("[ViewController] . File Deletion Failure:   \(error)") }
                        }
                    }
                
                if (rdoRetainName.state == NSOnState){
                    let fileManager = FileManager.default
                    for file in filesCollection {
                        print("[ViewController] . Renaming .tmp Files...")
                        do { try fileManager.moveItem(atPath: destinationPath + file.getFileName() + ".tmp" , toPath: destinationPath + file.getFileName() + tag + ".pdf") }
                            catch _ as NSError { print("[ViewController] . File Rename Error!: Item alredy exists")
                                do {
                                print("[ViewController] . Removing Item and resaving...")
                                try fileManager.removeItem(atPath: destinationPath + file.getFileName() + tag + ".pdf")
                                try fileManager.moveItem(atPath: destinationPath + file.getFileName() + ".tmp" , toPath: destinationPath + file.getFileName() + tag + ".pdf")
                                }
                                catch _ as NSError { print("[ViewController] . File replace error, either you don't have permission or the item no longer exists. Please check the destination folder and try again.") }
                            }
                    }
                }
                if (chkEnableFNOverride.state == NSOnState) {
                    let fileManager = FileManager.default
                        print("[ViewController] . Renaming .tmp Files...")
                        do { try fileManager.moveItem(atPath: (destinationPath + filesCollection[0].fileName + tag) + ".pdf" , toPath: destinationPath + txtFileNameOverrideValue.stringValue + tag + ".pdf") }
                        catch let error as NSError { print("File Rename Error!: \(error)")
                    }
                }
                
                    pbProgress.doubleValue = 100
                    lblProcessPercentage.stringValue = "100%"
                    lblStatus.stringValue = "Process Complete."
                    print("[ViewController] . Complete.")
                    destButtonFolder = destinationPath
                    //systemNotification.push("Convert to PDF process complete.")
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
                filesForArgs = filesForArgs.substring(to: filesForArgs.characters.index(before: filesForArgs.endIndex))
                filesForArgs = filesForArgs.substring(to: filesForArgs.characters.index(before: filesForArgs.endIndex))
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
                    filesForArgs = filesForArgs.substring(to: filesForArgs.characters.index(before: filesForArgs.endIndex))
                    filesForArgs = filesForArgs.substring(to: filesForArgs.characters.index(before: filesForArgs.endIndex))
                    job.executeImageReport(filesForArgs)
                    resetWindow()
                    destButtonFolder = ""
                    systemNotification.push("Your ImageReport is complete\nyou may now print or export it.")
            }
        }
        
    }
    
    @IBAction func enableTagging(_ sender: AnyObject) {
            }
    
    
    @IBAction func selectFileTag(_ sender: AnyObject) {
        if (rdoTag1st.state == NSOnState)       { fileTag = " [1st Approval]";   }
        if (rdoTag2nd.state == NSOnState)       { fileTag = " [2nd Approval]";   }
        if (rdoTag3rd.state == NSOnState)       { fileTag = " [3rd Approval]";   }
        if (rdoTagFinal.state == NSOnState)     { fileTag = " [Final Approval]"; }
        if (rdoTagPrint.state == NSOnState)     { fileTag = " [Print File]";     }
        if (rdoTagResupply.state == NSOnState)  { fileTag = " [Resupply]";       }
        
    }
    
    @IBAction func btnOpenLoc(_ sender: AnyObject) {
        
        NSWorkspace.shared().selectFile(nil, inFileViewerRootedAtPath: destButtonFolder)
        
    }
    
}



