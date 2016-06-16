//
//  GetUserIconHandler.swift
//  SwiftServerTest
//
//  Created by maocaiyuan on 16/6/6.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//
import Foundation
import PerfectLib
import MySQL

class GetUserIconHandler: RequestHandler {
    let acceptPara = ["account", "token", "time"]  //可接受的参数
    
    var dataArray = NSMutableDictionary()
    var dict = NSMutableDictionary()
    
    var request : WebRequest!
    var response: WebResponse!
    
    var imageData: NSData?
    
    func handleRequest(request: WebRequest, response: WebResponse) {
        
        print("\(NSDate()) download user icon got a request")
        self.request = request
        self.response = response
        
        //延迟调用，写在前边，不然return执行前 也没法儿调用
        defer{
            dataArray = dict
            if let data = imageData { //返回字节数据
                let count = data.length / sizeof(UInt8)
                var array = [UInt8](count: count, repeatedValue: 0)
                // copy bytes into array
                data.getBytes(&array, length:count * sizeof(UInt8))
              
                self.response.appendBodyBytes(array)
            }else{
                //由于返回的是字节数据，header也不要加载在里面
                self.response.addHeader("Content-Type", value: "application/json")
                self.response.addHeader("Content-Type", value: "text/html; charset=utf-8")
                
                let tee = Funcs.dicToJsonStr(dataArray)
                self.response.appendBodyString(tee)  //获取数据
            }
            
            print("\(NSDate()) download user icon request finished")
            self.response.requestCompletedCallback()
        }
        
        dict = Params.checkParas(acceptPara, request: self.request, response: self.response)
        
        if dict.count != 0{
            return
        }
        
        //参数正确
        let account = request.param("account")! as String
        print(account)
        let query = "SELECT pic FROM \(entityNameOfUserInfo) WHERE account=\"\(account)\""
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
        
        //执行查询,获得结果
        if let results = connectDB.executeSelectQuery(query){
            if results.numRows() == 1 {
                let imagePath = results.next()![0]
                if NSFileManager.defaultManager().fileExistsAtPath(imagePath) {
                    imageData = NSData(contentsOfFile: imagePath)!
                }
                //成功
                dict = Funcs.getStatus(ResultType.OK, response: self.response)
            }else{
                dict = Funcs.getStatus(ResultType.NoUser, response: self.response)
            }
        }
    }
}
