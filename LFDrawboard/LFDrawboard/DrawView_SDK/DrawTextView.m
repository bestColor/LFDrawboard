//
//  DrawTextView.m
//  TotalTest
//
//  Created by libx on 2019/4/16.
//  Copyright © 2019 lifeng. All rights reserved.
//

#import "DrawTextView.h"

@interface DrawTextView()<UITextViewDelegate,UIGestureRecognizerDelegate>

///上一次缩放比例,默认为1
@property (nonatomic, assign) CGFloat lastScale;
///最大缩放比例,默认为2
@property (nonatomic, assign) CGFloat maxScale;
///最小缩放比例,默认为1
@property (nonatomic, assign) CGFloat minScale;

@end

@implementation DrawTextView

- (void)dealloc
{
    _delegate = nil;
}

- (instancetype)initWithTextColor:(UIColor *)color text:(NSString *)text
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        //设置缩放比例
        self.lastScale = 1;
        self.minScale = 0.8;
        self.maxScale = 2;
        
        _textColor = color;
        _text = text;
        
        CGSize size = [self getSizeWithContent:text];
        
        self.frame = CGRectMake( ([UIScreen mainScreen].bounds.size.width - 20 - size.width)/2.0, 0, size.width+10, size.height + 10);
    
        _label = [[UILabel alloc] initWithFrame:self.bounds];
        _label.backgroundColor = [UIColor clearColor];
        _label.font = [UIFont systemFontOfSize:25];
        _label.textColor = color;
        _label.numberOfLines = 0;
        _label.text = text;
        _label.userInteractionEnabled = YES;
        _label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_label];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        pan.delegate = self;
        [self addGestureRecognizer:pan];
        
        [tap requireGestureRecognizerToFail:pan];
        
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
        pinch.delegate = self;
        [self addGestureRecognizer:pinch];
        
        UIRotationGestureRecognizer *rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateView:)];
        [self addGestureRecognizer:rotationGestureRecognizer];

        
    }
    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return YES;
    
}

- (void)tap:(UITapGestureRecognizer *)tap
{
    if (_delegate) {
        [_delegate tapMe:self];
    }
}

- (void)pan:(UIPanGestureRecognizer *)pan
{
    
    //获取偏移量
    // 返回的是相对于最原始的手指的偏移量
    CGPoint transP = [pan translationInView:self];
    
    // 移动图片控件
    self.transform = CGAffineTransformTranslate(self.transform, transP.x, transP.y);
    
    // 复位,表示相对上一次
    [pan setTranslation:CGPointZero inView:self];
}

- (void)rotateView:(UIRotationGestureRecognizer *)gs
{
    self.transform = CGAffineTransformRotate(self.transform, gs.rotation);
    // 复位
    gs.rotation = 0;
}

- (void)pinch:(UIPinchGestureRecognizer *)pinch
{
    switch (pinch.state) {
        case UIGestureRecognizerStateBegan://缩放开始
        case UIGestureRecognizerStateChanged://缩放改变
        {
            CGFloat currentScale = [[self.layer valueForKeyPath:@"transform.scale"] floatValue];
            CGFloat newScale = pinch.scale - self.lastScale + 1;
            newScale = MIN(newScale, self.maxScale / currentScale);
            newScale = MAX(newScale, self.minScale / currentScale);
            
            self.transform = CGAffineTransformScale(self.transform, newScale, newScale);
            
            self.lastScale = pinch.scale;
        }
            break;
        case UIGestureRecognizerStateEnded://缩放结束
            self.lastScale = 1;
            break;
            
        default:
            break;
    }
}

- (CGSize)getSizeWithContent:(NSString *)text
{
    
    CGRect contentBounds = [text boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, 1000)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:25]
                                                                                  forKey:NSFontAttributeName]
                                              context:nil];
    return contentBounds.size;
    
}

@end
