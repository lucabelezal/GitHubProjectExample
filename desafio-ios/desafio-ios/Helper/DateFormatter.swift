//
//  DateFormatter.swift
//  desafio-ios
//
//  Created by Lucas Nascimento on 18/12/2017.
//  Copyright © 2017 Lucas Nascimento. All rights reserved.
//

import Foundation

class Helper{
    
    static func convertDateFormatter(date: String) -> String
    {
        let dateFormatterr = DateFormatter()
        dateFormatterr.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatterr.date(from: date)
        
        dateFormatterr.dateFormat = "dd/MM/yyyy"
        let dateString = dateFormatterr.string(from: date!)
        print(dateString)
        
        return dateString
    }
}
