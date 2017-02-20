//
//  JSBridgeApi.m
//  HybridAppDemo
//
//  Created by Aboo on 2017/2/7.
//  Copyright © 2017年 Aboo. All rights reserved.
//

#import "JSBridgeApi.h"
#import "Utils.h"


@implementation JSBridgeApi


#pragma mark - Native Api

- (void)userLogin:(NSDictionary *)args
{
    if (args) {
        
        NSString *account = [args valueForKey:@"account"];
        NSString *pw = [args valueForKey:@"pw"];
        
        NSLog(@"H5传参：%@ - %@", account, pw);
    }
}

- (void)startToLocation:(NSDictionary *)args :(BridgeCallbackHandler)callbackHandler
{
    if (args) {
        
        NSString *token = [args valueForKey:@"token"];
        NSString *city = [args valueForKey:@"city"];
        
        NSLog(@"H5传参：%@ - %@", token, city);
    }
    
    NSDictionary *callbackParamsDic = @{@"lot":@"12.33", @"lon":@"90.55"};
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        callbackHandler(callbackParamsDic);
    });
    
}

- (void)exitPage:(NSDictionary *)args
{
    NSLog(@"推出当前页面");
    
}

- (void)log:(NSDictionary *)args
{
    if (args) {
        NSString *logMsg = [args valueForKey:@"log"];
        NSLog(@"#H5-Console-LOG#: %@", logMsg);
    }
}


#pragma mark - Message Handler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    NSString *bridgeName = message.name;
    
    NSDictionary *postMsg = [Utils jsonStringToDic:message.body];
    NSString *paramsJson = [postMsg valueForKey:@"params"];
    NSString *funcName = [postMsg valueForKey:@"funcName"];

    [self call:funcName args:paramsJson];
    
}


#pragma mark - JS处理

// H5调本地
-(void)call:(NSString *)method args:(NSString *)args
{
    SEL sel = NSSelectorFromString([method stringByAppendingString:@":"]);
    SEL selContainCallack = NSSelectorFromString([method stringByAppendingString:@"::"]);
    
    NSDictionary *paramsDic;
    if (args == nil || args.length == 0) {
        // 无参数
        paramsDic = @{};
    }else{
        paramsDic = [Utils jsonStringToDic:args];
    }
    
    if([self respondsToSelector:selContainCallack]){
        
        // 回调H5
        BridgeCallbackHandler callbackHandler = ^(NSDictionary *callbackParams){
            
            if (callbackParams == nil) {
                callbackParams = @{};
            }
            
            // onCallback(v) 是已定义好的统一回调方法
            [self.webPage callH5WithMethod:@"onCallback" args:callbackParams completionHandler:nil];
        };
        
        _Pragma("clang diagnostic push");
        _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"");
        
        // 调用本地方法
        [self performSelector:selContainCallack withObject:paramsDic withObject:callbackHandler];
        
        _Pragma("clang diagnostic pop");
        
    }else if([self respondsToSelector:sel]){
        
        _Pragma("clang diagnostic push");
        _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"");
        
        // 调用本地方法
        [self performSelector:sel withObject:paramsDic];
        
        _Pragma("clang diagnostic pop");
        
    }else{
        // 没有定义方法
    }

}

@end
