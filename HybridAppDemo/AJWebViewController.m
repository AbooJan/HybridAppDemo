//
//  AJWebViewController.m
//  HybridAppDemo
//
//  Created by Aboo on 2017/2/20.
//  Copyright © 2017年 Aboo. All rights reserved.
//

#import "AJWebViewController.h"
#import "AJWebView.h"
#import "Utils.h"

@interface AJWebViewController ()<WKUIDelegate>
{
    AJWebView *_webPage;
}
@end

@implementation AJWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    _webPage = [[AJWebView alloc] initWithFrame:CGRectMake(0.0, 80.0, screenSize.width, screenSize.height-80.0)];
    _webPage.UIDelegate = self;
    [self.view addSubview:_webPage];
    
    
    // 加载测试页面
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"test"
                                                          ofType:@"html"];
    NSString * htmlContent = [NSString stringWithContentsOfFile:htmlPath
                                                       encoding:NSUTF8StringEncoding
                                                          error:nil];
    [_webPage loadHTMLString:htmlContent baseURL:baseURL];
    
    
    // test 
    UIButton *testBtn1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [testBtn1 addTarget:self action:@selector(test1) forControlEvents:UIControlEventTouchUpInside];
    [testBtn1 setTitle:@"test1" forState:UIControlStateNormal];
    testBtn1.frame = CGRectMake(0.0, 20.0, 40.0, 40.0);
    [self.view addSubview:testBtn1];
    
    UIButton *testBtn2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [testBtn2 addTarget:self action:@selector(test2) forControlEvents:UIControlEventTouchUpInside];
    [testBtn2 setTitle:@"test2" forState:UIControlStateNormal];
    testBtn2.frame = CGRectMake(45.0, 20.0, 40.0, 40.0);
    [self.view addSubview:testBtn2];
}

- (void)test1
{
    NSDictionary *args = @{@"arg1":@"1234566", @"arg2":@"666666"};
    [_webPage callH5WithMethod:@"test1" args:args completionHandler:^(NSString *returnValue) {
        NSLog(@"H5 back: %@", returnValue);
    }];
}

- (void)test2
{
    [_webPage callH5WithMethod:@"test2" args:nil completionHandler:nil];
}


#pragma mark - UIDelegate

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable result))completionHandler
{
    // 这里是调用JS方法：prompt("",""); 触发
    
    UIAlertController *alertPage = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertPage addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"text input";
        textField.text = @"default";
    }];
    
    UITextField *inputTF = [alertPage.textFields firstObject];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"prompt cancel");
        completionHandler(@"empty");
    }];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"prompt confirm");
        completionHandler(inputTF.text);
        
    }];
    
    [alertPage addAction:cancelAction];
    [alertPage addAction:confirmAction];
    
    [self showViewController:alertPage sender:nil];
    
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    // 这里是调用JS方法：alert(''); 触发
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"alet cancel");
        completionHandler();
    }];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"alert confirm");
        completionHandler();
    }];
    
    UIAlertController *alertPage = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertPage addAction:cancelAction];
    [alertPage addAction:confirmAction];
    
    [self showViewController:alertPage sender:nil];
    
}

-(void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler
{
    // 这里是调用JS方法：confirm(''); 触发
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"alet cancel");
        completionHandler(NO);
    }];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"alert confirm");
        completionHandler(YES);
    }];
    
    UIAlertController *alertPage = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertPage addAction:cancelAction];
    [alertPage addAction:confirmAction];
    
    [self showViewController:alertPage sender:nil];
    
}
@end
