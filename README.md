仿QQ/微信拍照后的涂鸦和添加标签功能

1. 使用 CAShapeLayer + UIBezierPath来实现涂鸦功能，内存压力微乎其微。
2. 实现了涂鸦，颜色，撤销功能，撤销功能使用cashaperlayer实现，内存无压力。
3. 实现了添加标签功能，标签可以放大，缩小，旋转，变颜色，完全仿照QQ/微信的逻辑。


使用方法简单： 
         

           DrawViewDemo *dvVC = [[DrawViewDemo alloc] init];
    dvVC.editImage = [UIImage imageNamed:@"9978.jpg"];
    
    __weak typeof(ViewController *)weakSelf = self;
    
    dvVC.success = ^(UIImage * _Nonnull image) {
        weakSelf.editImageView.image = image;
    };
    
    
    [self presentViewController:dvVC animated:YES completion:^{
        
    }];

在github上获取了好多，最近不忙，终于有时间来奉献了。希望对需要的人有帮助。

另 https://github.com/bestColor/TotalTest.git 这个地址是我平常整理的第三方和例子，需要的拿去，主要功能有

    [_noteArray addObjectsFromArray:@[@"讯飞长时间语音识别+存储语音pcm文件和播放",
                                      @"任意拖动的小图标-AssistiveTouch",
                                      @"ios的指示器动画-非常好用的第三方",
                                      @"DBConnect使用例子",
                                      @"代理-Alamofire-cell-mode-MJRefresh的Swift版本学习",
                                      @"Swift调用OC代码",
                                      @"OC调用Swift代码",
                                      @"轮播banner图",
                                      @"轮播图-支持各种效果-大小-3D等效果",
                                      @"一个标签选择器",
                                      @"一款自定义动画的alertView",
                                      @"识别身份证信息-不支持ipad",
                                      @"面向协议编程的自己写的demo",
                                      @"获取心率值-将手指放在摄像头上",
                                      @"使用CAShapeLayer实现的涂鸦画板",
                                      @"DoubleSliderViewController"]];
