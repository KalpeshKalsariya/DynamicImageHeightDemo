//
//  Utility.swift
//  DynamicImageHeightDemo
//
//  Created by  Kalpesh on 19/04/25.
//

import Foundation
import UIKit

// Singleton Class for Utilities
class BannerUtility {
    
    static let shared = BannerUtility()
    
    private init() {}
    
    static let betweenMargin: CGFloat = 10
    static let mainPadding: CGFloat = 40
    
    // Global function to calculate banner size based on layout and aspect ratio
    static func getBannerSize(rowIndex: Int, fileWidth: CGFloat, fileHeight: CGFloat, moduleLayout: String) -> CGSize {
        // Convert layout string to integer
        let mModuleLayout = Int(moduleLayout) ?? 0
        
        // Calculate available width on screen
        let availWidth = UIScreen.main.bounds.width - mainPadding
        let tempWidth = (availWidth - betweenMargin) / 3
        var width: CGFloat = 0.0
        
        switch mModuleLayout {
        case 1:
            width = availWidth
        case 2:
            width = (availWidth - betweenMargin) / 2
        case 3:
            width = (availWidth - (2 * betweenMargin)) / 3
        case 4:
            width = (rowIndex % 2 != 0) ? tempWidth : tempWidth * 2
        case 5:
            width = (rowIndex % 2 != 0) ? tempWidth * 2 : tempWidth
        default:
            break
        }
        
        // Calculate height using aspect ratio
        let height = (width * fileHeight) / fileWidth
        return CGSize(width: width, height: height + 10)
    }
}
