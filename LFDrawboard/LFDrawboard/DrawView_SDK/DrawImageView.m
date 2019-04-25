//
//  DrawImageView.m
//  TotalTest
//
//  Created by libx on 2019/4/16.
//  Copyright © 2019 lifeng. All rights reserved.
//

#import "DrawImageView.h"

@interface DrawImageView()

@property (nonatomic, strong) CAShapeLayer *currentLayer;         // 当前的涂层，为什么用多个layer，主要是为了实现撤销操作
@property (nonatomic, strong) UIBezierPath *currentShapePath;     // 贝塞尔路径
@property (nonatomic, strong) NSMutableArray *layerArray;         // 所有的layer的数据源

@end

@implementation DrawImageView
{
    CGPoint pts[5];
    uint ctr;
}

- (void)dealloc
{
    NSLog(@"绘画界面释放");
    for (CAShapeLayer *layer in self.layerArray) {
        [layer removeFromSuperlayer];
    }
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.lineWidth = 5.0f;
        self.lineColor = [UIColor whiteColor];
    }
    return self;
}

- (UIImage *)save
{
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:context];
    UIImage *getImage = UIGraphicsGetImageFromCurrentImageContext();
    UIImageWriteToSavedPhotosAlbum(getImage, nil, nil, nil);
    UIGraphicsEndImageContext();
    
    /// 这里要保存到对应的沙盒路径里
    
    return getImage;

}

- (void)EditResultBlockWithGetImage:(EditResuleBlock)resultBlock
{
    UIImage *image = [self save];
    resultBlock(1, image);
}

- (void)revoke
{
    NSLog(@"撤销");
    
    if (self.layerArray.count <= 1) {
        [self clear];
        return;
    }
    
    id layer = [self.layerArray lastObject];
    [layer removeFromSuperlayer];
    
    [self.layerArray removeLastObject];
}

- (void)clear
{
    NSLog(@"清除");
    
    [self.layerArray makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [self.layerArray removeAllObjects];
}

- (CAShapeLayer *)createCurrentLayer
{
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = self.bounds;
    layer.lineWidth = self.lineWidth;
    layer.strokeColor = self.lineColor.CGColor;
    layer.lineCap = kCALineCapRound;
    layer.lineJoin = kCALineJoinRound;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.shouldRasterize = YES;
    
    [self.layer addSublayer:layer];
    
    [self.layerArray addObject:layer];

    return layer;
}


- (void)setLineColor:(UIColor *)lineColor
{
    _lineColor = lineColor;
}

- (void)setLineWidth:(float)lineWidth
{
    _lineWidth = lineWidth;
}

- (UIBezierPath *)makeDrawPath {
    UIBezierPath *drawPath = [UIBezierPath bezierPath];
    drawPath.lineCapStyle = kCGLineCapRound;
    drawPath.lineJoinStyle = kCGLineJoinRound;
    
    return drawPath;
}

- (NSMutableArray *)layerArray
{
    if (!_layerArray) {
        _layerArray = [[NSMutableArray alloc] init];
    }
    return _layerArray;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint startPoint = [touch locationInView:self];
    
    ctr = 0;
    pts[0] = startPoint;
    
    self.currentLayer = [self createCurrentLayer];
    self.currentShapePath = [self makeDrawPath];
    
    self.status(EditLineStart);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    uint count = ctr;
    if (count <= 4)
    {
        for (int i = 4; i > count; i--)
        {
            [self touchesMoved:touches withEvent:event];
        }
        ctr = 0;
    }
    else
    {
        [self touchesMoved:touches withEvent:event];
    }
    self.status(EditStop);

}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self];
    
    ctr++;
    pts[ctr] = currentPoint;
    
    if (ctr == 4)
    {
        pts[3] = CGPointMake((pts[2].x + pts[4].x)/2.0, (pts[2].y + pts[4].y)/2.0);
        
        [self.currentShapePath moveToPoint:pts[0]];
        [self.currentShapePath addCurveToPoint:pts[3] controlPoint1:pts[1] controlPoint2:pts[2]];
        pts[0] = pts[3];
        pts[1] = pts[4];
        ctr = 1;
        
        self.currentLayer.path = self.currentShapePath.CGPath;
    }    
}



@end
