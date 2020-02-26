//
//  Font.swift
//  FontGen_4iOS
//
//  Created by Tom on 2020/2/26.
//  Copyright © 2020 Tom. All rights reserved.
//

import Foundation
//namespace FontGen_iOS
//{
//    class Font
//    {
//        public string fileName { get; set; }
//        public string filePath { get; set; }
//        public string profileUUID { get; set; }
//        public string fontPayloadUUID { get; set; }
//        public string profilePayloadUUID { get; set; }
//        public string fixedFileName { get; }
//
//        public override string ToString()
//        {
//            return filePath;
//        }
//
//        public Font(string path) {
//            filePath = path;
//            string[] dirSeperators = path.Split(System.IO.Path.DirectorySeparatorChar);
//            fileName = dirSeperators.Last();
//            fixedFileName = fileName;
//            profileUUID = System.Guid.NewGuid().ToString();
//            fontPayloadUUID = System.Guid.NewGuid().ToString();
//            profilePayloadUUID = System.Guid.NewGuid().ToString();
//        }
//    }
//}

class Font{
    var fileName:String!
    var filePath:String!
    var profileUUID:String!
    var fontPayloadUUID:String!
    var profilePayloadUUID:String!
    let fixedFileName:String!
    
    public init(path:String){
        fileName = String(path.split(separator: "/").last ?? "NONAME.ttf")
        filePath = path
        fixedFileName = fileName
        profileUUID = UUID().uuidString
        fontPayloadUUID = UUID().uuidString
        profilePayloadUUID = UUID().uuidString
    }
}
