//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Qazi on 04/06/2015.
//  Copyright (c) 2015 Qazi. All rights reserved.
//

import Foundation
/**
*  Model class to save the details related to recorded audio
*/
class RecordedAudio: NSObject{
    var filePathUrl: NSURL!
    var title: String!
    /**
    Initialization function for Recorded Audio model
    
    :param: filePath save the path in the model object
    :param: title    name of the file saved as audio
    
    :returns: return the created instance
    */
    init(filePath: NSURL, title: String) {
        self.title   = title
        self.filePathUrl = filePath

    }
}