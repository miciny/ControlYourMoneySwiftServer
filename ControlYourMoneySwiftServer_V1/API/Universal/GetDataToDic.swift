//
//  GetDataToDic.swift
//  SwiftServerTest
//
//  Created by maocaiyuan on 16/5/31.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import MySQL

class GetDataToDic: NSObject {
    
    func setDataToArray(data: MySQL.Results, type: String) -> NSMutableArray?{
        switch type {
        case entityNameOfCash:
            return setCashDataToArray(data)
        case entityNameOfCost:
            return setCostDataToArray(data)
        case entityNameOfCredit:
            return setCreditDataToArray(data)
        case entityNameOfCreditAccount:
            return setCreditAccountDataToArray(data)
        case entityNameOfIncome:
            return setIncomeDataToArray(data)
        case entityNameOfIncomeName:
            return setIncomeNameDataToArray(data)
        case entityNameOfPayName:
            return setPayNameDataToArray(data)
        case entityNameOfTotal:
            return setCanUseDataToArray(data)
        default:
            return nil
        }
    }
    
    //现金
    private func setCashDataToArray(cash: MySQL.Results) -> NSMutableArray{
        let dic = NSMutableArray()
        let array = cash
        
        if array.numRows() == 0{
            return dic
        }
        
        while let row = array.next() {
            
            let dataDic = NSMutableDictionary()
            dataDic.setValue(row[1], forKey: cashNameOfUseNumber)
            dataDic.setValue(row[2], forKey: cashNameOfType)
            dataDic.setValue(row[3], forKey: cashNameOfUseWhere)
            dataDic.setValue(row[4], forKey: cashNameOfTime)
            
            dic.addObject(dataDic)
        }
        return dic
    }
    
    //支出类型
    private func setCostDataToArray(cost: MySQL.Results) -> NSMutableArray{
        let dic = NSMutableArray()
        let array = cost
        
        if array.numRows() == 0{
            return dic
        }
        
        while let row = array.next() {
            let dataDic = NSMutableDictionary()
            dataDic.setValue(row[1], forKey: costNameOfPeriod)
            dataDic.setValue(row[2], forKey: costNameOfNumber)
            dataDic.setValue(row[3], forKey: costNameOfName)
            dataDic.setValue(row[4], forKey: costNameOfType)
            dataDic.setValue(row[5], forKey: costNameOfTime)
            
            dic.addObject(dataDic)
        }
        return dic
    }
    
    // 信用
    private func setCreditDataToArray(credit: MySQL.Results) -> NSMutableArray{
        let dic = NSMutableArray()
        let array = credit
        
        if array.numRows() == 0{
            return dic
        }
        
        while let row = array.next() {
            let dataDic = NSMutableDictionary()
            dataDic.setValue(row[1], forKey: creditNameOfDate)
            dataDic.setValue(row[2], forKey: creditNameOfLeftPeriods)
            dataDic.setValue(row[3], forKey: creditNameOfPeriods)
            dataDic.setValue(row[4], forKey: creditNameOfNumber)
            dataDic.setValue(row[5], forKey: creditNameOfAccount)
            dataDic.setValue(row[6], forKey: creditNameOfType)
            dataDic.setValue(row[7], forKey: creditNameOfNextPayDay)
            dataDic.setValue(row[8], forKey: creditNameOfTime)
            
            dic.addObject(dataDic)
        }
        return dic
    }
    
    // 信用账号
    private func setCreditAccountDataToArray(creditAccount: MySQL.Results) -> NSMutableArray{
        let dic = NSMutableArray()
        let array = creditAccount
        
        if array.numRows() == 0{
            return dic
        }
        
        while let row = array.next() {
            let dataDic = NSMutableDictionary()
            dataDic.setValue(row[1], forKey: creditAccountNameOfName)
            dataDic.setValue(row[2], forKey: creditAccountNameOfTime)
            
            dic.addObject(dataDic)
        }
        return dic
    }
    
    // 收入
    private func setIncomeDataToArray(income: MySQL.Results) -> NSMutableArray{
        let dic = NSMutableArray()
        let array = income
        
        if array.numRows() == 0{
            return dic
        }
        
        while let row = array.next() {
            let dataDic = NSMutableDictionary()
            dataDic.setValue(row[1], forKey: incomeOfNumber)
            dataDic.setValue(row[2], forKey: incomeOfName)
            dataDic.setValue(row[3], forKey: incomeOfTime)
            
            dic.addObject(dataDic)
        }
        return dic
    }
    
    // 收入来源
    private func setIncomeNameDataToArray(incomeName: MySQL.Results) -> NSMutableArray{
        let dic = NSMutableArray()
        let array = incomeName
        
        if array.numRows() == 0{
            return dic
        }
        
        while let row = array.next() {
            let dataDic = NSMutableDictionary()
            dataDic.setValue(row[1], forKey: incomeNameOfName)
            dataDic.setValue(row[2], forKey: incomeNameOfTime)
            
            dic.addObject(dataDic)
        }
        return dic
    }
    
    // 支出类型
    private func setPayNameDataToArray(payName: MySQL.Results) -> NSMutableArray{
        let dic = NSMutableArray()
        let array = payName
        
        if array.numRows() == 0{
            return dic
        }
        
        while let row = array.next() {
            let dataDic = NSMutableDictionary()
            dataDic.setValue(row[1], forKey: payNameNameOfName)
            dataDic.setValue(row[2], forKey: payNameNameOfTime)
            
            dic.addObject(dataDic)
        }
        return dic
    }
    
    //余额
    private func setCanUseDataToArray(canuse: MySQL.Results) -> NSMutableArray{
        let dic = NSMutableArray()
        let array = canuse
        
        if array.numRows() == 0{
            return dic
        }
        
        while let row = array.next() {
            let dataDic = NSMutableDictionary()
            dataDic.setValue(row[1], forKey: totalNameOfCanUse)
            dataDic.setValue(row[2], forKey: totalNameOfTime)
            
            dic.addObject(dataDic)
        }
        return dic
    }
}
