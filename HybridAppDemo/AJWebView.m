//
//  AJWebView.m
//  HybridAppDemo
//
//  Created by Aboo on 2017/2/20.
//  Copyright © 2017年 Aboo. All rights reserved.
//

#import "AJWebView.h"
#import "Utils.h"
#import "JSBridgeApi.h"

@interface AJWebView()
@property (strong, nonatomic) JSBridgeApi *jsBridgeApi;
@end

@implementation AJWebView

-(instancetype)initWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration
{
    NSString *jsBridgePath = [[NSBundle mainBundle] pathForResource:@"JSBridge" ofType:@"js"];
    NSString *jsBridge = [NSString stringWithContentsOfFile:jsBridgePath
                                                   encoding:NSUTF8StringEncoding
                                                      error:nil];
    
    jsBridge = [@"_WKFlag='_H5JSBridge';" stringByAppendingString:jsBridge];
    WKUserScript *script = [[WKUserScript alloc] initWithSource:jsBridge
                                                  injectionTime:WKUserScriptInjectionTimeAtDocumentStart
                                               forMainFrameOnly:YES];
    [configuration.userContentController addUserScript:script];
    
    self = [super initWithFrame:frame configuration: configuration];
    
    if (self) {
        self.jsBridgeApi = [[JSBridgeApi alloc] init];
        self.jsBridgeApi.webPage = self;
        
        [configuration.userContentController addScriptMessageHandler:self.jsBridgeApi name:@"H5Bridge"];
    }
    return self;
}

#pragma mark - JS处理

// 本地调H5
-(void)callH5WithMethod:(NSString *)methodName args:(NSDictionary *)args completionHandler:(void (^)(NSString *))completionHandler
{
    NSString *script = @"";
    if(!args){
        script = [NSString stringWithFormat:@"%@()",methodName];
    }else{
        script = [NSString stringWithFormat:@"%@(%@)",methodName, [Utils objToJsonString:args]];
    }
    
    [self evaluateJavaScript:script completionHandler:^(id value,NSError * error){
        if(completionHandler){
            completionHandler(value);
        }
    }];
}

@end
