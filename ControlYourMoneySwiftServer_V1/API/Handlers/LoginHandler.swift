//
//  Login.swift
//  SwiftServerTest
//
//  Created by maocaiyuan on 16/5/31.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import Foundation
import PerfectLib
import MySQL

//================================================================
/*
 -MARK : 用户登陆
 */
//================================================================

class LoginHandler: RequestHandler {
    let acceptPara = ["account", "pw"]  //可接受的参数
 
    var dataArray = NSMutableDictionary()
    var dict = NSMutableDictionary()
    
    var request : WebRequest!
    var response: WebResponse!
    
    func handleRequest(request: WebRequest, response: WebResponse) {
        print("\(NSDate()) login got a request")
        
        self.request = request
        self.response = response
        
        self.response.addHeader("Content-Type", value: "application/json")
        self.response.addHeader("Content-Type", value: "text/html; charset=utf-8")
        
        //延迟调用，写在前边，不然return执行前 也没法儿调用
        defer{
            dataArray = dict
            let tee = Funcs.dicToJsonStr(dataArray)
            self.response.appendBodyString(tee)  //获取数据
            
            print("\(NSDate()) login request finished\n")
            
            self.response.requestCompletedCallback()
        }
        
        dict = Params.checkParas(acceptPara, request: self.request, response: self.response)
        
        if dict.count != 0{
            return
        }
        
        //参数正确
        let str = Params.getQuery(self.request)
        let query = "SELECT * FROM \(entityNameOfUserInfo) WHERE \(str)"
        print(query)
        getData(query)
    }
    
    //连接数据库
    func getData(query: String){
        
        //捆绑
        let connectDB = ConnectToDB()
        defer{
            connectDB.closeMySQL()
        }
        
        //连接数据库
        dict = connectDB.checkConnect(self.response)
        if dict.count > 0{
            return
        }
                
        //执行查询 获得结果
        if let results = connectDB.executeSelectQuery(query){
            if results.numRows() == 1 {
                
                dict = Funcs.getStatus(ResultType.OK, response: self.response)
        
            }else{
                dict = Funcs.getStatus(ResultType.NoUser, response: self.response)
            }
        }else{
            dict = Funcs.getStatus(ResultType.queryError, response: self.response)
        }
    }
}
