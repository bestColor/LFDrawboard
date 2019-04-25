//
//  DrawImageView.h
//  TotalTest
//
//  Created by libx on 2019/4/16.
//  Copyright © 2019 lifeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    EditLineStart = 1,
    EditStop
} EditStatus;

typedef void (^EditResuleBlock)(int result, UIImage * _Nullable image);          // result = -1为取消，其他为点击完成
typedef void (^EditStatusBlock)(EditStatus status);

NS_ASSUME_NONNULL_BEGIN

@interface DrawImageView : UIImageView

@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) float lineWidth;

@property (nonatomic, copy) EditStatusBlock status;

- (void)revoke;
- (void)clear;

- (void)EditResultBlockWithGetImage:(EditResuleBlock)resultBlock;

@end

NS_ASSUME_NONNULL_END
