//
//  Params.swift
//  SwiftServerTest
//
//  Created by maocaiyuan on 16/4/28.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import Foundation
import PerfectLib

class Params: NSObject{
    
    //返回一个查询语句的where
    class func getQuery(request: WebRequest) -> String{
        let paras = request.params()
        let parasCount = paras!.count
        var str = ""
        for i in 0 ..< parasCount{
            if i > 0{
                str += " AND " + paras![i].0 + "=" + "\"\(paras![i].1)\""
            }else{
                str += paras![i].0 + "=" + "\"\(paras![i].1)\""
            }
        }
        return str
    }
    
    //检查参数，如果返回的NSMutableDictionary有数据，则出问题了
    class func checkParas(acceptPara: [String], request: WebRequest, response: WebResponse) -> NSMutableDictionary{
        
        var dataArray = NSMutableDictionary()
        
        //如果没有参数，返回
        if request.params() == nil{
            dataArray = Error.setErrorData(paraErrorType.noPara, response: response)
            return dataArray
        }
        
        //如果参数数量错误
        if request.params()?.count != acceptPara.count{
            dataArray = Error.setErrorData(paraErrorType.lessPara, response: response)
            return dataArray
        }
        
        for para in request.params()!{
            //如果参数有错误 返回
            if !acceptPara.contains(para.0){
                dataArray = Error.setErrorData(paraErrorType.unacceptablePara, response: response)
                return dataArray
            }
            
            //参数为空，返回
            if para.1 == ""{
                dataArray = Error.setErrorData(paraErrorType.badPara, response: response)
                return dataArray
            }
        }
        
        return dataArray
    }
    
}
