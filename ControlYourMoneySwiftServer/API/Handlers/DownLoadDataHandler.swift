//
//  DownLoadData.swift
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
 -MARK : 用户下载数据，返回给用户一个json格式的字符串
 */
//================================================================

class DownLoadDataHandler: RequestHandler {
    
    let acceptPara = ["account", "token", "time"]  //可接受的参数
    
    var dataArray = NSMutableDictionary()
    var dict = NSMutableDictionary()
    
    var request : WebRequest!
    var response: WebResponse!
    
    func handleRequest(request: WebRequest, response: WebResponse) {
        print("\(NSDate()) download data got a request")
        
        self.request = request
        self.response = response
        
        self.response.addHeader("Content-Type", value: "application/json")
        self.response.addHeader("Content-Type", value: "text/html; charset=utf-8")
        
        //延迟调用，写在前边，不然return执行前 也没法儿调用
        defer{
            dataArray = dict
            let tee = Funcs.dicToJsonStr(dataArray)
            self.response.appendBodyString(tee)  //获取数据
            
            print("\(NSDate()) download data request finished")
            
            self.response.requestCompletedCallback()
        }
        
        dict = Params.checkParas(acceptPara, request: self.request, response: self.response)
        
        if dict.count != 0{
            return
        }
        //参数正确
        let account = request.param("account")! as String
        print(account)
        getData(account)
    }
    
    //连接数据库
    func getData(account: String){
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
        
        //获取id
        if let id = connectDB.getUserID(account){
            let entityNames = [entityNameOfCash, entityNameOfPayName, entityNameOfIncome,
                               entityNameOfIncomeName, entityNameOfTotal, entityNameOfCost,
                               entityNameOfCreditAccount,entityNameOfCredit]
            let getData = GetDataToDic()
            dict = Funcs.getStatus(ResultType.OK, response: self.response)
            
            let count = entityNames.count
            for i in 0 ..< count {
                let query = "SELECT * FROM \(entityNames[i]) WHERE id=\"\(id)\""
                //执行查询,获得结果
                if let results = connectDB.executeSelectQuery(query){
                    let array = getData.setDataToArray(results, type: entityNames[i])
                    
                    dict.setValue(array, forKey: entityNames[i])
                    
                }else{ //查询出错
                    dict = Funcs.getStatus(ResultType.queryError, response: self.response)
                    return
                }
            }
            
        }else{ //没有获取到id
            dict = Funcs.getStatus(ResultType.NoUser, response: self.response)
        }
    }
}
