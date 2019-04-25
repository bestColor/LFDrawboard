//
//  DrawEditTextView.h
//  TotalTest
//
//  Created by libx on 2019/4/16.
//  Copyright © 2019 lifeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawTextView.h"

#define kMaxTextCount = 100

typedef void (^EditSuccess)(DrawTextView * _Nonnull tv, BOOL isNewView, BOOL isCancel);

NS_ASSUME_NONNULL_BEGIN

@interface DrawEditTextView : UIView

@property (nonatomic, copy)EditSuccess success;

// 是点击已经存在的view，还是新的view
- (void)show:(DrawTextView * _Nullable)drawTextView;
- (void)hide;

@end

NS_ASSUME_NONNULL_END
