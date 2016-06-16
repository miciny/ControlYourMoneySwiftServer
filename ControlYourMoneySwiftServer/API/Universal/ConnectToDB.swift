//
//  ConnectToDB.swift
//  SwiftServerTest
//
//  Created by maocaiyuan on 16/6/8.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//
import PerfectLib
import MySQL

class ConnectToDB: NSObject {
    let mysql = MySQL()
    
    //连接数据库
    func connectToDB() -> sqlErrorType{
        let connect = mysql.connect(LocalHOST, user: LocalUSER, password: LocalPASSWORD)  //连接数据库
        
        //数据库连接错误
        if !connect {
            print("cannot connect mysql!")
            return sqlErrorType.cannotReachSQL
        }
        
        //选择数据库的库
        let sres = mysql.selectDatabase(LocalSCHEME)
        if !sres {
            print("cannot select the table!")
            return sqlErrorType.cannotReachSQLDB
        }
        
        mysql.query("set names utf8")  //设置连接的编码，非常重要！！！！
        return sqlErrorType.connectOK
    }
    
    //检查数据看连接状态
    func checkConnect(response: WebResponse) -> NSMutableDictionary {
        var dataArray = NSMutableDictionary()
        let connectStatus = connectToDB()
        
        switch connectStatus {
        case .connectOK:
            return dataArray
        case .cannotReachSQL:
            dataArray = Error.setErrorSQl(.cannotReachSQL, response: response)
            return dataArray
        case .cannotReachSQLDB:
            dataArray = Error.setErrorSQl(.cannotReachSQLDB, response: response)
            return dataArray
        }
    }
    
    //执行查询，返回结果
    func executeSelectQuery(query: String) -> MySQL.Results?{
        
        defer{
            mysql.storeResults()?.close()
        }
        
        //如果连接上了
        let myQuery = query
        //执行查询
        let sres = mysql.query(myQuery)
        if !sres {
            print("myQuery error \(myQuery)")
            return nil
        }
        //获得结果
        let results = mysql.storeResults()!
        return results
    }

    //执行操作，返回是否正确
    func executeNoResultQuery(query: String) -> Bool{
        
        //如果连接上了
        let myQuery = query
        //执行
        let sres = mysql.query(myQuery)
        if !sres {
            print("myQuery error \(myQuery)")
            return false
        }
        return true
    }
    
    func closeMySQL(){
        mysql.close()
    }
    
    //检查数据库是否有此用户
    func isAlreadyInDB(account: String) -> Bool{
        let isQuery = "select * from \(entityNameOfUserInfo) where account=\"\(account)\""
        
        if let result = executeSelectQuery(isQuery){
            if result.numRows() == 1{
                return true
            }else{
                return false
            }
        }else{
            return false
        }
    }
    
    //获取用户id
    func getUserID(account: String) -> String?{
    
        let isQuery = "select id from \(entityNameOfUserInfo) where account=\"\(account)\""
        
        if let result = executeSelectQuery(isQuery){
            if result.numRows() == 1{
                let userID = result.next()
                return userID![0]
            }else{
                return nil
            }
        }else{
            return nil
        }
    }
}
