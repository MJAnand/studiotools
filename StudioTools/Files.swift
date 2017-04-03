//
//  Files.swift
//  StudioTools
//
//  Created by Tim Colley on 09/08/2016.
//  Copyright © 2016 GRJ. All rights reserved.
//
//  Container class for files that need processing
//  allows for manipulation, data requests and sorting
//

import Foundation

open class Files : NSObject
{
    var filesList: [File] = []
    
    func addFile(_ name: String, type: String, path: String){
        filesList.append(File(fn: name, ft: type, fp: path))
    }
    
    func removeFile(_ index: Int)
    {
        filesList.remove(at: index)
    }
    
    func removeAll()
    {
        filesList.removeAll()
    }
    
    func sortFiles()
    {
        ///////////////////////////////
        //                           //
        //  Sorting algorythem here  //
        //                           //
        ///////////////////////////////
    }
    
    func retunCollectionSize() -> Int
    {
        return filesList.count
    }
    
    func returnFileAtIndex(_ index: Int) -> File
    {
        return filesList[index]
    }
    
    func returnFiles() -> [File]
    {
        return filesList
    }
    
    func returnSimpleCollection() -> [String]
    {
        var filesCollection: [String] = []
        
        for file in filesList
        {
            filesCollection.append(file.returnFullPath())
        }
        return filesCollection
    }
}
