//
//  AFNetwokingVC.h
//  MANetworkingDemo
//
//  Created by ma on 2020/8/11.
//  Copyright © 2020 com.ma. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AFNetwokingVC : UIViewController

@end

NS_ASSUME_NONNULL_END

/*
HTTPS与HTTP的不同点
前面涉及到的GET和POST都属于HTTP请求，现在苹果的APP都推荐支持HTTPS，这就需要先配置一下证书，然后在NSURLSession（或者NSURLConnection但现在新的项目基本不用了）的代理方法里面进行一些特别的操作。如果是AFNetWorking，也需要对AFHTTPRequestOperationManager对象进行一些特别的操作。
关于证书的配置，及需要的特别的操作，推荐阅读：
https://www.jianshu.com/p/97745be81d64
https://www.jianshu.com/p/459e5471e61b
https://www.jianshu.com/p/4f826c6e48ed
*/


/*
AF封装了GET和POST操作的 -- AFHTTPSessionManager
AFNetworking2.0和3.0区别很大，也是因为苹果废弃了NSURLConnection，而改用了NSURLSession
AFNetworking3.0实际上只是对NSURLSession所做的操作进行了高度封装，提供更加简洁的API供编码调用。
 */
