//
//  Universal.swift
//  SwiftServerTest
//
//  Created by maocaiyuan on 16/4/28.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import Foundation
import PerfectLib

//发生错误时，提供一个错误代码，返回一个字典
/*
 301: 没有写参数
 302: 有不可接受的参数
 303: 参数为空
 304: 参数缺失
*/
//参数错误

enum paraErrorType{
    case noPara   //301
    case unacceptablePara  //302
    case badPara  //303
    case lessPara  //304
}

//sql错误
enum sqlErrorType{
    case cannotReachSQL  //连不上数据库 400
    case cannotReachSQLDB //连不上数据库里指定的库 401
    case connectOK //连接正常
}

class Error: NSObject{
    
    //参数错误
    class func setErrorData(error: paraErrorType, response: WebResponse) -> NSMutableDictionary{
        
        let dict = NSMutableDictionary()
        
        dict.setValue("false", forKey: "success")
        
        switch error {
        case .noPara:  //没有参数
            dict.setValue("301", forKey: "code")
            dict.setValue("参数为空", forKey: "message")

            response.setStatus(301, message: "no para")
        case .unacceptablePara:
            dict.setValue("302", forKey: "code")
            dict.setValue("参数错误", forKey: "message")

            response.setStatus(302, message: "para error")
        case .badPara:
            dict.setValue("303", forKey: "code")
            dict.setValue("参数为空", forKey: "message")

            response.setStatus(303, message: "no para")
        case .lessPara:
            dict.setValue("304", forKey: "code")
            dict.setValue("参数错误", forKey: "message")
            
            response.setStatus(304, message: "para error")
        }
        
        return dict
    }
    
    
    //链接数据库错误
    class func setErrorSQl(error: sqlErrorType, response: WebResponse) -> NSMutableDictionary{
        let dict = NSMutableDictionary()
        
        switch error {
        case .cannotReachSQL:
            response.setStatus(400, message: "connect db error")
            
            dict.setValue("false", forKey: "success")
            dict.setValue("400", forKey: "code")
            dict.setValue("连接数据库出错", forKey: "message")
            
        case .cannotReachSQLDB:
            response.setStatus(401, message: "connect db tabel error")
            
            dict.setValue("false", forKey: "success")
            dict.setValue("401", forKey: "code")
            dict.setValue("连接数据库里指定库出错", forKey: "message")
        case .connectOK:
            break
        }
        return dict
    }

}
