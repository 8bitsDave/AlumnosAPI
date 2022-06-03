//
//  File.swift
//  
//
//  Created by Julio César Fernández Muñoz on 1/6/22.
//

import Foundation

extension DateFormatter {
    static let formatter:DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}
