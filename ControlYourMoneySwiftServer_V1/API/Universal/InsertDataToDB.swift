//
//  InsertDataToDB.swift
//  SwiftServerTest
//
//  Created by maocaiyuan on 16/6/1.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import MySQL
import SwiftyJSON

class InsertDataToDB: NSObject {
    
//====================================================================================
    //用户头像地址上传到服务器
    func insertUserPicStrToDB(path: String, account: String) -> Bool{
        
        //捆绑
        let connectDB = ConnectToDB()
        defer{
            connectDB.closeMySQL()
        }
        
        //连接数据库
        let dict = connectDB.connectToDB()
        if dict != sqlErrorType.connectOK{
            return false
        }
        
        //是否有这个账号了
        let isAlready = connectDB.isAlreadyInDB(account)
        
        var query = ""
        if isAlready {
            query = "UPDATE \(entityNameOfUserInfo) SET pic=\"\(path)\" WHERE account=\"\(account)\""
        }else{
            return false
        }
        
        //执行查询
        return connectDB.executeNoResultQuery(query)
    }

//====================================================================================
    //用户数据上传到服务器
    func insertUserDataToDB(JSONStr: String) -> Bool{
        //捆绑
        let connectDB = ConnectToDB()
        defer{
            connectDB.closeMySQL()
        }
        
        //连接数据库
        let dict = connectDB.connectToDB()
        if dict != sqlErrorType.connectOK{
            return false
        }
        
        //获取上传的用户数据
        let json = JSON(Funcs.strToJson(JSONStr))
        let alljson = json["data"][entityNameOfUserInfo][0]
        
        //不能为空
        guard alljson != nil else{
            return true
        }
        
        //首先获取用户名，检查
        let row = alljson
        let account = row[userNameOfAccount].stringValue
        print(account)
        //判断是否有此用户了
        let isAlready = connectDB.isAlreadyInDB(account)
       
        var query = ""
        if isAlready {
            let name = row[userNameOfName].stringValue
            let address = row[userNameOfAddress].stringValue
            let location = row[userNameOfLocation].stringValue
            let pw = row[userNameOfPW].stringValue
            let sex = row[userNameOfSex].stringValue
            let create_time = row[userNameOfTime].stringValue
            let motto = row[userNameOfMotto].stringValue
            let http = row[userNameOfHttp].stringValue
            
            query = "UPDATE \(entityNameOfUserInfo) SET name=\"\(name)\", address=\"\(address)\",location=\"\(location)\",pw=\"\(pw)\",sex=\"\(sex)\",create_time=\"\(create_time)\",motto=\"\(motto)\",http=\"\(http)\" WHERE account=\"\(account)\""
        }else{
            print("post user data error")
            return false
        }
        
        //执行查询
        return connectDB.executeNoResultQuery(query)
    }
    
//====================================================================================
    //金额数据上传到服务器
    func insertDataToDB(JSONStr: String) -> Bool{
        var succes = true
        
        //捆绑
        let connectDB = ConnectToDB()
        defer{
            connectDB.closeMySQL()
        }
        
        //连接数据库
        let dict = connectDB.connectToDB()
        if dict != sqlErrorType.connectOK{
            return false
        }
        
        //获得的数据
        let json = JSON(Funcs.strToJson(JSONStr))
        let alljson = json["data"]
        let account = json["account"].stringValue
        print(account)
        
        // 获取id
        if let id = connectDB.getUserID(account){
            deleteAllMoneyData(id, mysql: connectDB.mysql)
            
            //保证每个都执行了
            let cashJson = alljson[entityNameOfCash]
            if !insertCashDB(cashJson, id: id, mysql: connectDB.mysql){
                succes = false
            }
            
            let totalJson = alljson[entityNameOfTotal]
            if !insertTotalDB(totalJson, id: id, mysql: connectDB.mysql){
                succes = false
            }
            
            //先插入name，应该有外键
            let incomeNameJson = alljson[entityNameOfIncomeName]
            if !insertIncomeNameDB(incomeNameJson, id: id, mysql: connectDB.mysql){
                succes = false
            }
            
            let incomeJson = alljson[entityNameOfIncome]
            if !insertIncomeDB(incomeJson, id: id, mysql: connectDB.mysql){
                succes = false
            }
            
            let costJson = alljson[entityNameOfCost]
            if !insertCostDB(costJson, id: id, mysql: connectDB.mysql){
                succes = false
            }
            
            let payNameJson = alljson[entityNameOfPayName]
            if !insertPayNameDB(payNameJson, id: id, mysql: connectDB.mysql){
                succes = false
            }
            
            let creditJson = alljson[entityNameOfCredit]
            if !insertCreditDB(creditJson, id: id, mysql: connectDB.mysql){
                succes = false
            }
            
            let creditAccountJson = alljson[entityNameOfCreditAccount]
            if !insertCreditAccountDB(creditAccountJson, id: id, mysql: connectDB.mysql){
                succes = false
            }
        }else{
            return false
        }
        
        return succes
    }

//====================================================================================
    //删除所有数据
    private func deleteAllMoneyData(id: String, mysql: MySQL){
        //删除数据
        mysql.query("delete from \(entityNameOfCash) where id=\"\(id)\"")
        mysql.query("delete from \(entityNameOfCost) where id=\"\(id)\"")
        mysql.query("delete from \(entityNameOfTotal) where id=\"\(id)\"")
        mysql.query("delete from \(entityNameOfCredit) where id=\"\(id)\"")
        mysql.query("delete from \(entityNameOfIncome) where id=\"\(id)\"")
        mysql.query("delete from \(entityNameOfPayName) where id=\"\(id)\"")
        mysql.query("delete from \(entityNameOfIncomeName) where id=\"\(id)\"")
        mysql.query("delete from \(entityNameOfCreditAccount) where id=\"\(id)\"")
    
    }
    
//====================================================================================
    //cash
    private func insertCashDB(data: JSON, id: String, mysql: MySQL) -> Bool{
        var done = true
        
        guard data != nil else{
            return done
        }
        
        for i in 0 ..< data.count{
            
            let row = data[i]
            
            let time = row[cashNameOfTime].stringValue
            let type = row[cashNameOfType].stringValue
            let useWhere = row[cashNameOfUseWhere].stringValue
            let useNumber = row[cashNameOfUseNumber].stringValue
            
            let query = "INSERT INTO \(entityNameOfCash) VALUES (\"\(id)\", \"\(useNumber)\", \"\(type)\", \"\(useWhere)\", \"\(time)\")"

            //执行查询
            let sres2 = mysql.query(query)
            if !sres2 {
                print("query error 1")
                done = false
            }
        }
        return done
    }
    
    //总计
    private func insertTotalDB(data: JSON, id: String, mysql: MySQL) -> Bool{
        var done = true
        
        guard data != nil else{
            return done
        }
        
        for i in 0 ..< data.count {
            let row = data[i]
            
            let time = row[totalNameOfTime].stringValue
            let canUse = row[totalNameOfCanUse].stringValue
            
            let query = "INSERT INTO \(entityNameOfTotal) VALUES (\"\(id)\", \"\(canUse)\", \"\(time)\")"
            //执行查询
            let sres2 = mysql.query(query)
            if !sres2 {
                print("query error 2")
                done = false
            }
        }
        return done
    }
    
    //支出类型
    private func insertPayNameDB(data: JSON, id: String, mysql: MySQL) -> Bool{
        var done = true
        
        guard data != nil else{
            return done
        }
        
        for i in 0 ..< data.count {
            let row = data[i]
            
            let time = row[payNameNameOfTime].stringValue
            let name = row[payNameNameOfName].stringValue
            
            let query = "INSERT INTO \(entityNameOfPayName) VALUES (\"\(id)\", \"\(name)\", \"\(time)\")"
            //执行查询
            let sres2 = mysql.query(query)
            if !sres2 {
                print("query error 3")
                done = false
            }
        }
        return done
    }
    
    //信用账号
    private func insertCreditAccountDB(data: JSON, id: String, mysql: MySQL) -> Bool{
        var done = true
        
        guard data != nil else{
            return done
        }
        
        for i in 0 ..< data.count {
            let row = data[i]
            
            let time = row[creditAccountNameOfTime].stringValue
            let name = row[creditAccountNameOfName].stringValue
            
            let query = "INSERT INTO \(entityNameOfCreditAccount) VALUES (\"\(id)\", \"\(name)\", \"\(time)\")"
            //执行查询
            let sres2 = mysql.query(query)
            if !sres2 {
                print("query error 4")
                done = false
            }
        }
        return done
    }
    
    //信用
    private func insertCreditDB(data: JSON, id: String, mysql: MySQL) -> Bool{
        var done = true
        
        guard data != nil else{
            return done
        }
        
        for i in 0 ..< data.count {
            let row = data[i]
            
            let time = row[creditNameOfTime].stringValue
            let account = row[creditNameOfAccount].stringValue
            let date = row[creditNameOfDate].stringValue
            let type = row[creditNameOfType].stringValue
            let number = row[creditNameOfNumber].stringValue
            let periods = row[creditNameOfPeriods].stringValue
            let nextpayDay = row[creditNameOfNextPayDay].stringValue
            let leftPeriods = row[creditNameOfLeftPeriods].stringValue
            
            let query = "INSERT INTO \(entityNameOfCredit) VALUES (\"\(id)\", \"\(date)\", \"\(leftPeriods)\", \"\(periods)\", \"\(number)\", \"\(account)\", \"\(type)\", \"\(nextpayDay)\", \"\(time)\")"
            //执行查询
            let sres2 = mysql.query(query)
            if !sres2 {
                print("query error 5")
                done = false
            }
        }
        return done
    }
    
    //预计花费
    private func insertCostDB(data: JSON, id: String, mysql: MySQL) -> Bool{
        var done = true
        
        guard data != nil else{
            return done
        }
        
        for i in 0 ..< data.count {
            let row = data[i]
            
            let time = row[costNameOfTime].stringValue
            let name = row[costNameOfName].stringValue
            let type = row[costNameOfType].stringValue
            let number = row[costNameOfNumber].stringValue
            let period = row[costNameOfPeriod].stringValue
            
            let query = "INSERT INTO \(entityNameOfCost) VALUES (\"\(id)\", \"\(period)\", \"\(number)\", \"\(name)\", \"\(type)\", \"\(time)\")"
            //执行查询
            let sres2 = mysql.query(query)
            if !sres2 {
                print("query error 6")
                done = false
            }
        }
        return done
    }
    
    //收入来源
    private func insertIncomeNameDB(data: JSON, id: String, mysql: MySQL) -> Bool{
        var done = true
        
        guard data != nil else{
            return done
        }
        
        for i in 0 ..< data.count {
            let row = data[i]
            
            let time = row[incomeNameOfTime].stringValue
            let name = row[incomeNameOfName].stringValue
            
            let query = "INSERT INTO \(entityNameOfIncomeName) VALUES (\"\(id)\", \"\(name)\", \"\(time)\")"

            //执行查询
            let sres2 = mysql.query(query)
            if !sres2 {
                print("query error 7")
                done = false
            }
        }
        return done
    }
    
    //收入
    private func insertIncomeDB(data: JSON, id: String, mysql: MySQL) -> Bool{
        var done = true
        
        guard data != nil else{
            return done
        }
        
        for i in 0 ..< data.count {
            let row = data[i]
            
            let time = row[incomeOfTime].stringValue
            let name = row[incomeOfName].stringValue
            let number = row[incomeOfNumber].stringValue
            
            let query = "INSERT INTO \(entityNameOfIncome) VALUES (\"\(id)\", \"\(number)\", \"\(name)\", \"\(time)\")"
            //执行查询
            let sres2 = mysql.query(query)
            if !sres2 {
                print("query error 8")
                done = false
            }
        }
        return done
    }
}
