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
