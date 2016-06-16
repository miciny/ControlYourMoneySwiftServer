//
//  GetUserInfo.swift
//  SwiftServerTest
//
//  Created by maocaiyuan on 16/6/2.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//
import Foundation
import PerfectLib
import MySQL

class GetUserInfoHandler: RequestHandler {
    let acceptPara = ["account", "token", "time"]  //可接受的参数
    
    var dataArray = NSMutableDictionary()
    var dict = NSMutableDictionary()
    
    var request : WebRequest!
    var response: WebResponse!
    
    func handleRequest(request: WebRequest, response: WebResponse) {
        print("\(NSDate()) get user Info got a request")
        
        self.request = request
        self.response = response
        
        self.response.addHeader("Content-Type", value: "application/json")
        self.response.addHeader("Content-Type", value: "text/html; charset=utf-8")
        
        //延迟调用，写在前边，不然return执行前 也没法儿调用
        defer{
            dataArray = dict
            let tee = Funcs.dicToJsonStr(dataArray)
            self.response.appendBodyString(tee)  //获取数据
            
            print("\(NSDate()) get user Info request finished")
            
            self.response.requestCompletedCallback()
        }
        
        //检查参数
        dict = Params.checkParas(acceptPara, request: self.request, response: self.response)
        if dict.count != 0{
            return
        }
        
        //参数正确，执行查询
        let account = request.param("account")! as String
        print(account)
        let query = "SELECT * FROM \(entityNameOfUserInfo) WHERE account=\"\(account)\""
        getData(query)
    }
    
    //连接数据库，执行查询
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
                
                let dic = NSMutableArray()
                while let row = results.next() {
                    let dataDic = NSMutableDictionary()
                    dataDic.setValue(row[2], forKey: userNameOfName)
                    dataDic.setValue(row[3], forKey: userNameOfNickname)
                    dataDic.setValue(row[4], forKey: userNameOfPW)
                    dataDic.setValue(row[5], forKey: userNameOfTime)
                    dataDic.setValue(row[6], forKey: userNameOfSex)
                    dataDic.setValue(row[7], forKey: userNameOfPic)
                    dataDic.setValue(row[8], forKey: userNameOfAddress)
                    dataDic.setValue(row[9], forKey: userNameOfMotto)
                    dataDic.setValue(row[10], forKey: userNameOfLocation)
                    dataDic.setValue(row[11], forKey: userNameOfHttp)
                    dataDic.setValue(row[1], forKey: userNameOfAccount)
                    
                    dic.addObject(dataDic)
                }
                dict.setValue(dic, forKey: "data")
            }else{
                dict = Funcs.getStatus(ResultType.NoUser, response: self.response)
            }
        }else{
            dict = Funcs.getStatus(ResultType.queryError, response: self.response)
        }
    }
}
