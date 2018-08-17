### 基本说明

1、该控件为二维码扫描控件；<br/>
2、包含一个控制器类与一个视图类；<br/>
2.1、控制器SAScanCtrl负责AV流的捕获与输出；<br/>
2.2、视图类SAScanView将AV流渲染出来，附加辅助标识与动画；<br/>
3、使用时只需要调用控制器的initWithBlock:方法即可，block中输出扫描结果；<br/>
4、主类为控制器，使用时可以可配合导航控制器通过push或present的方式使用；

---
### 集成方式
#### 1、pod方式(推荐)
A、查找当前最新版本：终端中切换到工程根目录，输入`pod search sascan` <br/>
B、在工程的Podfile文件中添加`pod 'SAScan', '~> x.x.x'`，比如：<br/>
```
target 'MyApp' do
  pod 'SAScan', '~> 0.0.7';
end
```
C、保存Podfile的更改后，更新pod：`pod update`

#### 2、以库的形式集成
A、下载git项目中的SAScan目录，在需要使用的地方直接`imprt "SAScanCtrl.h"`即可

---
### 使用示例
```
SAScanCtrl *scan = [[SAScanCtrl alloc] initWithBlock:^(NSString *string) {
    // 处理扫描后的输出结果
    NSLog(@"%@", string);
}];
[self.navigationController pushViewController:scan animated:YES];
```

---
### 问题反馈
1、该组件能独立存在，无侵入性零偶合，并且一行代码即可调用，使用简单；<br/>
2、该控件为本人曾经项目中的一个功能，后发现多个项目中都有这种需要；<br/>
3、现在大多数项目中都会使用到cocoaPods，大都数第三方都通过该方式集成；<br/>
4、项目中多次被用到，又不想Copy来Copy去，闲暇之余上传了该组件；<br/>
5、本人非科班出身，类似驾校除名自学成才的那种，不足之处欢迎吐槽；<br/>