//
//  PerfectHandlers.swift
//  SwiftServerTest
//
//  Created by maocaiyuan on 16/4/27.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

import Foundation
import PerfectLib
import MySQL

//SELECT * FROM xpop_shop WHERE shop_name="堒胖服装店"

// This function is required. The Perfect framework expects to find this function
// to do initialization
public func PerfectServerModuleInit() {
    
    // Install the built-in routing handler.
    // This is required by Perfect to initialize everything
    
    Routing.Handler.registerGlobally()
    
    //api
    Routing.Routes["GET", ["/api"]] = { _ in
        return IndexHandler()
    }
    
    //login
    Routing.Routes["GET", ["/api/login"]] = { _ in
        return LoginHandler()
    }
    
    //get user info
    Routing.Routes["GET", ["/api/user"]] = { _ in
        return GetUserInfoHandler()
    }
    
    //post user info
    Routing.Routes["POST", ["/api/user"]] = { _ in
        return PostUserInfoHandler()
    }
    
    //post user icon
    Routing.Routes["POST", ["/api/user/icon"]] = { _ in
        return PostUserIconHandler()
    }
    
    //get user icon
    Routing.Routes["GET", ["/api/user/icon"]] = { _ in
        return GetUserIconHandler()
    }
    
    //download
    Routing.Routes["GET", ["/api/sync"]] = { _ in
        return DownLoadDataHandler()
    }
    
    //post data
    Routing.Routes["POST", ["/api/sync"]] = { _ in
        return PostDataHandler()
    }
}
