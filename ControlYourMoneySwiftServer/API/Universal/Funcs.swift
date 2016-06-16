//
//  Funcs.swift
//  SwiftServerTest
//
//  Created by maocaiyuan on 16/5/31.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import PerfectLib

enum ResultType {
    case OK //成功
    case NoUser //用户信息出错（两条信息）
    case queryError //查询出错
    case noData  //没有上传数据
    case postFailed //上传失败
}

class Funcs: NSObject {
    
    //字典转为json格式的字符串
    class func dicToJsonStr(dic: NSMutableDictionary) -> String{
        let dataArray = dic
        var str = String()
        
        do {
            let dataFinal = try NSJSONSerialization.dataWithJSONObject(dataArray, options:NSJSONWritingOptions(rawValue:0))
            let string = NSString(data: dataFinal, encoding: NSUTF8StringEncoding)
            str = string as! String
            
        }catch {
            
        }
        return str
    }
    
    //字符串转成json
    class func strToJson(str: String) -> AnyObject{
        
        let data = str.dataUsingEncoding(NSUTF8StringEncoding)
        var json : AnyObject = ""
        
        do {
            let deserialized = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
            json = deserialized
            
        }catch let e as NSError{
            print(e)
        }
        
        return json
    }
    
    //根据状态 返回状态数据
    class func getStatus(resultStatus: ResultType, response: WebResponse) -> NSMutableDictionary{
        let dict = NSMutableDictionary()
        switch resultStatus {
        case .OK:
            dict.setValue("true", forKey: "success")
            dict.setValue("200", forKey: "code")
            dict.setValue("成功", forKey: "message")
            
            response.setStatus(200, message: "ok")
            
        case .NoUser:
            dict.setValue(["信息出错"], forKey: "data")
            dict.setValue("false", forKey: "success")
            dict.setValue("201", forKey: "code")
            
            response.setStatus(201, message: "user data error")
            
        case .queryError:
            dict.setValue(["查询出错"], forKey: "data")
            dict.setValue("false", forKey: "success")
            dict.setValue("202", forKey: "code")
            
            response.setStatus(202, message: "query error")
            
        case .noData:
            dict.setValue("false", forKey: "success")
            dict.setValue("305", forKey: "code")
            dict.setValue("没有上传数据", forKey: "message")
            
            response.setStatus(305, message: "no data post")
            
        case .postFailed:
            dict.setValue("false", forKey: "success")
            dict.setValue("306", forKey: "code")
            dict.setValue("上传失败", forKey: "message")
            
            response.setStatus(306, message: "upload failed")
        }
        return dict
    }
}
