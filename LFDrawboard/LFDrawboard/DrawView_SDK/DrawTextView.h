//
//  DrawTextView.h
//  TotalTest
//
//  Created by libx on 2019/4/16.
//  Copyright © 2019 lifeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DrawTextViewDelegate <NSObject>
- (void)tapMe:(UIView *_Nonnull)tap;
@end

NS_ASSUME_NONNULL_BEGIN

@interface DrawTextView : UIView

@property (nonatomic, strong) UIColor * _Nullable textColor;
@property (nonatomic,   copy) NSString * _Nullable text;
@property (nonatomic, strong) UILabel *label;

@property (nonatomic,   weak) id<DrawTextViewDelegate>delegate;

- (instancetype)initWithTextColor:(UIColor *)color text:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
