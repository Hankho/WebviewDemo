//
//  ImageRep.swift
//  XCwebview
//
//  Created by Hankho on 2018/3/9.
//  Copyright © 2018年 Hankho. All rights reserved.
//

import Foundation
import ObjectMapper

class ImageRep:Mappable {
    /**companyCode*/
    
    var downloadUrl:String!
    var result:String!
    var version:String!
    var img:[String]!
    init() {}
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    
    func mapping(map: Map) {
        downloadUrl <- map["downloadUrl"]
        result <- map["result"]
        version <- map["version"]
        img <- map["img"]
    }
    
}

