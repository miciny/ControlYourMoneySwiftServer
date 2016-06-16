//
//  PostUserIconHandler.swift
//  SwiftServerTest
//
//  Created by maocaiyuan on 16/6/6.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import Foundation
import PerfectLib
import MySQL

class PostUserIconHandler: RequestHandler {
    var request : WebRequest!
    var response: WebResponse!
    var dict = NSMutableDictionary()
    
    func handleRequest(request: WebRequest, response: WebResponse) {
        print("\(NSDate()) post user icon got a request")
        
        self.request = request
        self.response = response
        
        self.response.addHeader("Content-Type", value: "application/json")
        self.response.addHeader("Content-Type", value: "text/html; charset=utf-8")
        
        //延迟调用，写在前边，不然return执行前 也没法儿调用
        defer{
            let tee = Funcs.dicToJsonStr(dict)
            self.response.appendBodyString(tee)  //获取数据
            
            print("\(NSDate()) post user icon request finished")
            
            self.response.requestCompletedCallback()
        }
        
        //没有上传数据
        if self.request.fileUploads.count == 0 {
            dict = Funcs.getStatus(ResultType.noData, response: self.response)
            return
        }
        
        //获取上传的文件
        let uploads = request.fileUploads
        let uploadFile = uploads[0]
        let file = uploadFile
        
        if SavePicToLocal.saveUserIconToLocal(file){
            //成功
            dict = Funcs.getStatus(ResultType.OK, response: self.response)
        }else{
            //失败
            dict = Funcs.getStatus(ResultType.postFailed, response: self.response)
        }
    }

}
