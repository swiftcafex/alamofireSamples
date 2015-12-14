
import UIKit
import Alamofire

//: SwiftCafe 提供教程 [http://swiftcafe.io](http://swiftcafe.io)
//:
//: 微信公众号 swiftcafex
//:
//: ![](http://swiftcafe.io/images/qrcode.jpg)
//:
//: GitHub 地址 [https://github.com/swiftcafex/alamofireSamples](https://github.com/swiftcafex/alamofireSamples)

//: 简单 GET 请求
Alamofire.request(.GET, "https://swiftcafe.io")


//: 处理 GET 请求的响应
Alamofire.request(.GET, "https://httpbin.org/get", parameters: ["foo": "bar"])
    .responseJSON { response in
        
        print(response.request)  // 请求对象
        print(response.response) // 响应对象
        print(response.data)     // 服务端返回的数据
        
        if let JSON = response.result.value {
            print("JSON: \(JSON)")
        }
        
}


//: 还可以将响应方法的调用链接起来
Alamofire.request(.GET, "https://httpbin.org/get")
    .responseString { response in
        print("Response String: \(response.result.value)")
    }
    .responseJSON { response in
        print("Response JSON: \(response.result.value)")
}



//: 上传文件

let fileURL = NSBundle.mainBundle().URLForResource("alamofire", withExtension: "png")
Alamofire.upload(.POST, "https://httpbin.org/post", file: fileURL!)


//: 检测上传文件进度

Alamofire.upload(.POST, "https://httpbin.org/post", file: fileURL!)
    .progress { bytesWritten, totalBytesWritten, totalBytesExpectedToWrite in
        print(totalBytesWritten)
        
        // This closure is NOT called on the main queue for performance
        // reasons. To update your ui, dispatch to the main queue.
        dispatch_async(dispatch_get_main_queue()) {
            print("Total bytes written on main queue: \(totalBytesWritten)")
        }
    }
    .responseJSON { response in
        debugPrint(response)
}

//: 上传 MultipartFormData 类型的数据

Alamofire.upload(
    .POST,
    "https://httpbin.org/post",
    multipartFormData: { multipartFormData in
        multipartFormData.appendBodyPart(fileURL: unicornImageURL, name: "unicorn")
        multipartFormData.appendBodyPart(fileURL: rainbowImageURL, name: "rainbow")
    },
    encodingCompletion: { encodingResult in
        switch encodingResult {
        case .Success(let upload, _, _):
            upload.responseJSON { response in
                debugPrint(response)
            }
        case .Failure(let encodingError):
            print(encodingError)
        }
    }
)

//: 下载文件

Alamofire.download(.GET, "https://httpbin.org/stream/100") { temporaryURL, response in
    let fileManager = NSFileManager.defaultManager()
    let directoryURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
    let pathComponent = response.suggestedFilename
    
    return directoryURL.URLByAppendingPathComponent(pathComponent!)
}

//: 设置默认下载位置

let destination = Alamofire.Request.suggestedDownloadDestination(directory: .DocumentDirectory, domain: .UserDomainMask)
Alamofire.download(.GET, "https://httpbin.org/stream/100", destination: destination)

//: 检测下载进度

Alamofire.download(.GET, "https://httpbin.org/stream/100", destination: destination)
    .progress { bytesRead, totalBytesRead, totalBytesExpectedToRead in
        print(totalBytesRead)
        
        dispatch_async(dispatch_get_main_queue()) {
            print("Total bytes read on main queue: \(totalBytesRead)")
        }
    }
    .response { _, _, _, error in
        if let error = error {
            print("Failed with error: \(error)")
        } else {
            print("Downloaded file successfully")
        }
}

//: HTTP 验证

let user = "user"
let password = "password"

Alamofire.request(.GET, "https://httpbin.org/basic-auth/\(user)/\(password)")
    .authenticate(user: user, password: password)
    .responseJSON { response in
        debugPrint(response)
}

//: HTTP 响应状态信息识别

Alamofire.request(.GET, "https://httpbin.org/get", parameters: ["foo": "bar"])
    .validate(statusCode: 200..<300)
    .validate(contentType: ["application/json"])
    .response { response in
        print(response)
}

Alamofire.request(.GET, "https://httpbin.org/get", parameters: ["foo": "bar"])
    .validate()
    .responseJSON { response in
        switch response.result {
        case .Success:
            print("Validation Successful")
        case .Failure(let error):
            print(error)
        }
}

//: 调试状态

let request = Alamofire.request(.GET, "https://httpbin.org/ip")

debugPrint(request)
// GET https://httpbin.org/ip (200)



//: SwiftCafe 提供教程 [http://swiftcafe.io](http://swiftcafe.io)
//:
//: 微信公众号 swiftcafex
//:
//: ![](http://swiftcafe.io/images/qrcode.jpg)
//:
//: GitHub 地址 [https://github.com/swiftcafex/alamofireSamples](https://github.com/swiftcafex/alamofireSamples)
