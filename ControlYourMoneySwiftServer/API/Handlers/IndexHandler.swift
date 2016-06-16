//
//  Index.swift
//  SwiftServerTest
//
//  Created by maocaiyuan on 16/4/28.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import Foundation
import PerfectLib

//================================================================
/*
    -MARK : 用于没输入参数时的显示
*/
//================================================================

//一个类处理一个请求
class IndexHandler: RequestHandler {
    func handleRequest(request: WebRequest, response: WebResponse) {
        response.addHeader("Content-Type", value: "application/json")
        response.addHeader("Content-Type", value: "text/html; charset=utf-8")
        response.appendBodyString("请输入参数")
        response.requestCompletedCallback()
    }
}