# HybridAppDemo
混合开发框架Demo

核心是 `JSBridge.js` 文件，里面封装了连接webview和H5页面的桥，因为iOS的WKWebView跟Android的webview与H5的方法调用不一样，所有 `JSBridge.js` 需要做区分。
因为每个内嵌的H5都要与Native进行交互，所以建议iOS和Android共同维护一个桥 `JSBridge.js` ，客户端在加载H5页面的时候注入这段脚本，这样每次加载H5的时候就不用下载这个JS文件了。

* Android的webView可以直接在H5的window注入一个Bridge instance，从而实现方法的相互调用。

* iOS的WKWebView无法获取 `JSContext` ，所以无法像Android那样注入桥对象，只能通过消息发送来实现方法调用。H5可以有2种方式来发送消息给native，native通过拦截消息来做出相应。
一种是通过调用JS方法 `prompt()`, 因为默认WKWebView是不处理弹窗的，需要自己实现 `WKUIDelegate` 来做出弹窗处理，那么这样就可以根据H5传过来的弹窗信息来解决是弹窗还是调用native API。
另一种是通过调用JS方法 `window.webkit.messageHandlers.<name>.postMessage(<messageBody>)` ，这个方法是WKWebView文档上提供的。本身WKWebView可以通过 `WKUserContentController` 往H5注入自定义JS，只需给WKWebView通过方法 `- (void)addScriptMessageHandler:(id <WKScriptMessageHandler>)scriptMessageHandler name:(NSString *)name`设定一个消息接收者，就可以接收来自H5的消息。
