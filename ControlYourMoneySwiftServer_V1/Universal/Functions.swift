//
//  Funcs.swift
//  SwiftServerTest
//
//  Created by maocaiyuan on 16/5/31.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import Foundation

class Functions: NSObject {
    //获取当前时间
    class func getTime() -> NSDate{
        let now = NSDate()
        //        let zoon = NSTimeZone.systemTimeZone()
        //        let interval : NSInteger = zoon.secondsFromGMTForDate(now)
        //        return now.dateByAddingTimeInterval(Double(interval))
        return now
    }
    
    //时间转为字符串
    class func dateToString(date : NSDate) -> String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        // Date 转 String
        return dateFormatter.stringFromDate(date)
    }
    
    class func dateToStringNoHH(date : NSDate) -> String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        // Date 转 String
        return dateFormatter.stringFromDate(date)
    }
    
    //自定义的dateToString
    class func dateToStringBySelf(date : NSDate, str:String) -> String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = str
        // Date 转 String
        return dateFormatter.stringFromDate(date)
    }
    
    class func stringToDate(dateStr : String) -> NSDate{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        // String to Date
        return dateFormatter.dateFromString(dateStr)!
    }
    
    class func stringToDateBySelf(dateStr : String, formate: String) -> NSDate{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = formate
        // String to Date
        return dateFormatter.dateFromString(dateStr)!
    }
    
    class func stringToDateNoHH(dateStr : String) -> NSDate{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        // String to Date
        return dateFormatter.dateFromString(dateStr)!
    }
    
    //判断字符串为数字
    class func stringIsInt(str: String) -> Bool{
        let scan = NSScanner(string: str)
        var i = Int32()
        return scan.scanInt(&i) && scan.atEnd
    }
    
    //判断字符串为浮点型
    func stringIsFloat(str: String) -> Bool{
        let scan = NSScanner(string: str)
        var f = Float()
        return scan.scanFloat(&f) && scan.atEnd
    }

}


