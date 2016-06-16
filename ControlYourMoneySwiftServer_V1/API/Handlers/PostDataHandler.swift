//
//  PostData.swift
//  SwiftServerTest
//
//  Created by maocaiyuan on 16/6/1.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import Foundation
import PerfectLib
import MySQL

//================================================================
/*
 -MARK : 用户上传数据
 */
//================================================================


//post请求
class PostDataHandler: RequestHandler {
    
    var request : WebRequest!
    var response: WebResponse!
    var dict = NSMutableDictionary()
    
    func handleRequest(request: WebRequest, response: WebResponse) {
        print("\(NSDate()) post data got a request")
        
        self.request = request
        self.response = response
        
        self.response.addHeader("Content-Type", value: "application/json")
        self.response.addHeader("Content-Type", value: "text/html; charset=utf-8")
        
        //延迟调用，写在前边，不然return执行前 也没法儿调用
        defer{
            let tee = Funcs.dicToJsonStr(dict)
            self.response.appendBodyString(tee)  //获取数据
            
            print("\(NSDate()) post data request finished")
            
            self.response.requestCompletedCallback()
        }
        
        //没有上传数据
        if self.request.postBodyString == "" {
            dict = Funcs.getStatus(ResultType.noData, response: self.response)
            return
        }
        
        let insertData = InsertDataToDB()
        if insertData.insertDataToDB(request.postBodyString){
            //成功
            dict = Funcs.getStatus(ResultType.OK, response: self.response)
        }else{
            //上传失败
            dict = Funcs.getStatus(ResultType.postFailed, response: self.response)
        }
    }
}
