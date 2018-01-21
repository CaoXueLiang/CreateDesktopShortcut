

![最终效果.gif](http://upload-images.jianshu.io/upload_images/979175-aafe024d56ecbadc.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

## 前言
如何实现像淘宝一样将店铺的快捷方式添加到桌面，实现点击桌面快捷方式直接打开淘宝跳转到指定店铺。最近项目有这个需求，记录一下如何实现的，方便以后查看。
首先来了解以下几个问题：
1. URL Schemes 是什么
2. Data URI Scheme 是什么
3. 如何创建桌面快捷方式

### 1. URL Schemes 是什么
通过对比网页链接来理解 iOS 上的 URL Schemes，应该就容易多了。
URL Schemes 有两个单词：
* URL，我们都很清楚，`http://www.apple.com` 就是个 URL，我们也叫它链接或网址；
* Schemes，表示的是一个 URL 中的一个位置——最初始的位置，即` ://`之前的那段字符。比如 `http://www.apple.com` 这个网址的 Schemes 是 **http**。

根据我们上面对 URL Schemes 的使用，我们可以很轻易地理解，在以本地应用为主的 iOS 上，我们可以像定位一个网页一样，用一种特殊的 URL 来定位一个应用甚至应用里某个具体的功能。而定位这个应用的，就应该这个应用的 URL 的 Schemes 部分，也就是开头儿那部分。比如短信，就是` sms:`。

你可以完全按照理解一个网页的 URL ——也就是它的网址——的方式来理解一个 iOS 应用的 URL，拿苹果的网站和 iOS 上的微信来做个简单对比：

|   | **网页（苹果）**  | **iOS 应用（微信）** |
|:------------- |:---------------:| -------------:|
|网站首页/打开应用    | http://www.apple.com | weixin:// |
| 子页面/具体功能      | http://www.apple.com/mac/ | weixin://dl/moments |

在这里，`http://www.apple.com` 和 `weixin://` 都声明了这是谁的地盘。然后在 `http://www.apple.com` 后面加上 `/mac` 就跳转到从属于 `http://www.apple.com` 的一个网页（Mac 页）上；同样，在 `weixin://` 后面加上 `dl/moments` 就进入了微信的一个具体的功能——朋友圈。

**但是，两者还有几个重要的区别：**
1. 所有网页都一定有网址，不管是首页还是子页。但未必所有的应用都有自己的 URL Schemes，更不是每个应用的每个功能都有相应的 URL Schemes。
2. 一个网址只对应一个网页，但并非每个 URL Schemes 都只对应一款应用。这点是因为苹果没有对 URL Schemes 有不允许重复的硬性要求。
3. 一般网页的 URL 比较好预测，而 iOS 上的 URL Schemes 因为没有统一标准，所以非常难猜，通过猜来获取 iOS 应用的 URL Schemes 是不现实的。

### 2. Data URI Scheme 是什么

优化网页效能，首要的任务是尽量减少HTTP请求（http request）的次数，例如可以直接把图像的内容嵌入到网页里面，官方名称是 [data URI scheme](http://en.wikipedia.org/wiki/Data_URI_scheme "Datra URI Scheme")。

假设你有一个图像，把它在网页上显示出来的标准方法是：
```
<img src="http://120.77.47.216/images//meilin/news_img/2018-01/18/134943_7106.jpg"/>
```

这种方式中，img标记的src属性指定了一个远程服务器上的资源。当网页加载到浏览器中 时，浏览器会针对每个外部资源都向服务器发送一次拉取资源请求，占用网络资源。如果一个网页里嵌入了过多的外部资源，这些请求会导致整个页面的加载延迟。同样的效果使用 data URI scheme 可以写为：
```
<img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAQAAAADCAIAAAA
7ljmRAAAAGElEQVQIW2P4DwcMDAxAfBvMAhEQMYgcACEHG8ELxtbPAAAAAElFTkSuQmCC" />
```
我们把图像文件的内容内置在HTML文档中，节省了一个HTTP请求。

######Data URI的格式规范
```
data:[<mime type>][;charset=<charset>][;<encoding>],<encoded data>
```
1.  data ：协议名称；
2.  [<mime type>] ：可选项，数据类型（image/png、text/plain等）
3.  [;charset=<charset>] ：可选项，源文本的字符集编码方式
4.  [;<encoding>] ：数据编码方式（默认US-ASCII，BASE64两种）
5.  ,<encoded data> ：编码后的数据

目前，Data URI scheme支持的类型有：
```
data:,                              文本数据
data:text/plain,                    文本数据
data:text/html,                     HTML代码
data:text/html;base64,              base64编码的HTML代码
data:text/css,                      CSS代码
data:text/css;base64,               base64编码的CSS代码
data:text/javascript,               Javascript代码
data:text/javascript;base64,        base64编码的Javascript代码
data:image/gif;base64,              base64编码的gif图片数据
data:image/png;base64,              base64编码的png图片数据
data:image/jpeg;base64,             base64编码的jpeg图片数据
data:image/x-icon;base64,           base64编码的icon图片数据

```

###### 设置web application样式
设置桌面快捷方式的样式，参考[苹果官方文档](https://developer.apple.com/library/content/documentation/AppleApplications/Reference/SafariWebContent/ConfiguringWebApplications/ConfiguringWebApplications.html#//apple_ref/doc/uid/TP40002051-CH3-SW4)。

设置桌面图标
```
<link rel="apple-touch-icon" sizes="167x167" href="touch-icon-ipad-retina.png">
```
设置启动图
```
<link rel="apple-touch-startup-image" href="/launch.png">
```
设置快捷方式名称
```
<meta name="apple-mobile-web-app-title" content="AppTitle">
```
设置Web应用运行时是否全屏
```
<meta name="apple-mobile-web-app-capable" content="yes">
```
设置Web应用的导航栏样式
```
<meta name="apple-mobile-web-app-status-bar-style" content="black">
```
关联到其他应用
```
<a href="tel:1-408-555-5555">Call me</a>
```
### 3. 如何创建桌面快捷方式
实现原理:  通过应用内部启动httpServer，调用safari访问localhost，同时，在主页通过跳转到新的Data URI页面。创建本地服务查看知乎上的回答：[localhost、127.0.0.1 和 本机IP 三者的区别?](https://www.zhihu.com/question/23940717)。

优点：不需要服务器，没网也能完成操作。
缺点：依赖的类库较多，而且实现较麻烦。
我对创建桌面快捷方式进行了封装，GitHub下载地址[CreateDesktopShortcut](https://github.com/CaoXueLiang/CreateDesktopShortcut)

1. 调用封装的方法添加桌面快捷方式
```
    [[CXLCreateDesktopManager sharedInsance] 
                   createDesktopWithIconImage:@"icon"
                                  launchImage:@"launch" 
                                       appTitle:@"桌面快捷方式" 
                                      URLScheme:@"CreateDesktop://xxxx"];
```

2.  在项目的Info.plist中添加URL Scheme

![添加URL Scheme.png](http://upload-images.jianshu.io/upload_images/979175-6ba2d764301104dc.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

3. 在AppDelegate中添加回调
```
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    NSLog(@"scheme : %@",[url scheme]);
    NSLog(@"url : %@",url);

   //根据@"CreateDesktop://xxxx"跳转到响应的界面

    return YES;
}
```

必须要写下面这个方法，否则第一次调用Safari可能不成功。
```
- (void)applicationDidEnterBackground:(UIApplication *)application {
    sleep(1);
}
```




