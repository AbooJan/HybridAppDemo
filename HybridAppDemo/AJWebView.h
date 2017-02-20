//
//  AJWebView.h
//  HybridAppDemo
//
//  Created by Aboo on 2017/2/20.
//  Copyright © 2017年 Aboo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface AJWebView : WKWebView
-(void)callH5WithMethod:(NSString *)methodName args:(NSDictionary *)args completionHandler:(void (^)(NSString *))completionHandler;
@end
