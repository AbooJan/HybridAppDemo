//
//  Utils.h
//  HybridAppDemo
//
//  Created by Aboo on 2017/2/7.
//  Copyright © 2017年 Aboo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

+ (NSString *)objToJsonString:(id)obj;
+ (NSDictionary *)jsonStringToDic:(NSString *)jsonStr;

@end
