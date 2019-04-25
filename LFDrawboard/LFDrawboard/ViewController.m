//
//  ViewController.m
//  LFDrawboard
//
//  Created by libx on 2019/4/25.
//  Copyright © 2019 libx. All rights reserved.
//

#import "ViewController.h"
#import "DrawViewDemo.h"

@interface ViewController ()

@property (nonatomic, strong)UIImageView *editImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width * 0.75)];
    iv.image = [UIImage imageNamed:@"9978.jpg"];
    [self.view addSubview:iv];
    self.editImageView = iv;

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0,100,140,82);
    [btn setCenter:self.view.center];
    [btn setTitle:@"开始涂鸦" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(addEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    

}

- (void)addEvent:(UIButton *)sender
{
    
    DrawViewDemo *dvVC = [[DrawViewDemo alloc] init];
    dvVC.editImage = [UIImage imageNamed:@"9978.jpg"];
    
    __weak typeof(ViewController *)weakSelf = self;
    
    dvVC.success = ^(UIImage * _Nonnull image) {
        weakSelf.editImageView.image = image;
    };
    
    
    [self presentViewController:dvVC animated:YES completion:^{
        
    }];
    
}


@end
