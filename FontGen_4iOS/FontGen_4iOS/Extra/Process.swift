//
//  Process.swift
//  FontGen_4iOS
//
//  Created by Tom on 2020/2/26.
//  Copyright © 2020 Tom. All rights reserved.
//

import Foundation

func generateConfigFromFont(font:Font,outputPath:String){
    let sampleURL = Bundle.main.url(forResource: "sample", withExtension: "xml")!
    guard let sampleText = try? String(contentsOf: sampleURL, encoding: .utf8) else {return}
    var output = ""
    output = sampleText.replacingOccurrences(of: "%FONT_NAME%", with: font.fileName)
    output = output.replacingOccurrences(of: "%FONT_PAYLOAD_UUID%", with: font.fontPayloadUUID)
    output = output.replacingOccurrences(of: "%PROFILE_PAYLOAD_UUID%", with: font.profilePayloadUUID)
    output = output.replacingOccurrences(of: "%PROFILE_UUID%", with: font.profileUUID)
    
    guard let fontData = try? Data(contentsOf: URL(fileURLWithPath: font.filePath)) else {return}
    let fontDataString = fontData.base64EncodedString()
    output = output.replacingOccurrences(of: "%FONT_BASE64_DATA%", with: fontDataString)
    
    var outputURL = URL(fileURLWithPath: outputPath).appendingPathComponent(font.fileName+".mobileconfig")
    
    try? output.write(to: outputURL, atomically: false, encoding: .utf8)
    
}
