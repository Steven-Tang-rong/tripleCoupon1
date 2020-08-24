//
//  Post.swift
//  tripleCoupon
//
//  Created by TANG,QI-RONG on 2020/8/16.
//  Copyright © 2020 Steven. All rights reserved.
//

import Foundation

struct PostData: Codable {
    
    let hsnCd: String
    let hsnNm: String
    let townCd: String?
    let townNm: String
    let storeCd: String
    let storeNm: String
    let addr: String
    let zipCd: String
    let tel: String?
    let busiTime: String
    let busiMemo: String
    let longitude: String
    let latitude: String
    let total: String
    let updateTime: String
    let lowLine: String
}
