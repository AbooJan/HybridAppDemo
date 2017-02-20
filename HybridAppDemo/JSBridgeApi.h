//
//  JSBridgeApi.h
//  HybridAppDemo
//
//  Created by Aboo on 2017/2/7.
//  Copyright © 2017年 Aboo. All rights reserved.
//
//
//  Api定义：
//  有回调: #API名称#:(NSDictionary *)args :(BridgeCallbackHandler)callbackHandler
//  无回调: #API名称#:(NSDictionary *)args
//  所有的参数传入、传出都用JSON格式
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "AJWebView.h"


typedef void(^BridgeCallbackHandler)(NSDictionary *callbackParams);

@interface JSBridgeApi : NSObject <WKScriptMessageHandler>

@property (weak,nonatomic) AJWebView *webPage;


//===native api===

- (void)userLogin:(NSDictionary *)args;
- (void)startToLocation:(NSDictionary *)args :(BridgeCallbackHandler)callbackHandler;
- (void)exitPage:(NSDictionary *)args;
- (void)log:(NSDictionary *)args;

@end
