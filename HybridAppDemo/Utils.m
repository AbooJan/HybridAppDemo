//
//  Utils.m
//  HybridAppDemo
//
//  Created by Aboo on 2017/2/7.
//  Copyright © 2017年 Aboo. All rights reserved.
//

#import "Utils.h"

@interface Utils()

@end

@implementation Utils


+ (NSString *)objToJsonString:(id)obj
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:0 error:&error];
    
    if (!jsonData) {
        return @"{}";
        
    }else{
        
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    return jsonString;
}

+ (NSDictionary *)jsonStringToDic:(NSString *)jsonStr
{
    if (jsonStr == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err){
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end
