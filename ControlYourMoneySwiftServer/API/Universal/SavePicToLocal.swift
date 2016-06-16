//
//  SavePicToLocal.swift
//  SwiftServerTest
//
//  Created by maocaiyuan on 16/6/6.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//
import Foundation
import PerfectLib

class SavePicToLocal: NSObject {
    //保存用户图片到本地
    class func saveUserIconToLocal(uploadFile: MimeReader.BodySpec) -> Bool{
      
        let iconDirPath = getIconDirPath()
        var isSaved = false
        let picPath = iconDirPath.stringByAppendingPathComponent("\(uploadFile.fieldName).png")
        
        let nsData = NSData(contentsOfFile: (uploadFile.file?.path())!)
        do{
            try
                nsData!.writeToFile(picPath, options: .AtomicWrite)
                isSaved = true
        }catch let error as NSError{
            print(error)
            isSaved = false
        }
        
        let insertData = InsertDataToDB()
        insertData.insertUserPicStrToDB(picPath, account: uploadFile.fieldName)
        
        print(uploadFile.fieldName)
        print("user icon save? \(isSaved)")
        return isSaved
    }
    
    //获取头像存储路径
    class func getIconDirPath() -> AnyObject{
        let deskPath = getDeskPath()
        let iconDirPath = deskPath.stringByAppendingPathComponent("CYM_UserIcon")
        return iconDirPath
    }
    
    //获取桌面路径
    class func getDeskPath() -> AnyObject{
        let deskPaths = NSSearchPathForDirectoriesInDomains(.DesktopDirectory, .UserDomainMask, true)
        let deskPath = deskPaths[0]
        return deskPath
    }
}
