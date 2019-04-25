//
//  DrawViewDemo.h
//  TotalTest
//
//  Created by libx on 2019/4/16.
//  Copyright © 2019 lifeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^EditImageSuccess) (UIImage *_Nonnull image);

NS_ASSUME_NONNULL_BEGIN

@interface DrawViewDemo : UIViewController
@property (nonatomic, strong) UIImage *editImage;


@property (nonatomic, copy)EditImageSuccess success;

@end

NS_ASSUME_NONNULL_END
