//
//  DrawViewDemo.m
//  TotalTest
//
//  Created by libx on 2019/4/16.
//  Copyright © 2019 lifeng. All rights reserved.
//

#import "DrawViewDemo.h"
#import "DrawImageView.h"
#import "DrawEditTextView.h"
#import "DrawTextView.h"

@interface DrawViewDemo ()<UIGestureRecognizerDelegate,DrawTextViewDelegate>

@property (nonatomic,   copy) NSArray *colors;
@property (nonatomic, strong) UIView *toolView;
@property (nonatomic, strong) UIButton *currentButton;
@property (nonatomic, assign) CGRect selectRect;
@property (nonatomic, assign) CGRect normalRect;

@property (nonatomic, strong) DrawImageView *drawViewImage;
@property (nonatomic, assign) EditStatus currentStatus;

@property (nonatomic, strong) DrawEditTextView *editTextView;

@property (nonatomic, strong) NSMutableArray *textViewArray;
@property (nonatomic, strong) DrawTextView *curDrawTextView;

@end

@implementation DrawViewDemo

- (void)dealloc
{
    for (UIView *v in self.textViewArray) {
        [v removeFromSuperview];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"使用CAShapeLayer实现的画板";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self.view addSubview:self.drawViewImage];
    
    __weak typeof(DrawViewDemo *)weakSelf = self;
    
    self.drawViewImage.status = ^(EditStatus status) {
        if (status == 1) {
            [weakSelf hideTool];
        } else {
            [weakSelf showTool];
        }
    };
    
    UIColor *color1 = [UIColor whiteColor];
    UIColor *color2 = [UIColor blackColor];
    UIColor *color3 = [UIColor colorWithRed:232/255.0 green:93/255.0 blue:88/255.0 alpha:1];
    UIColor *color4 = [UIColor colorWithRed:247/255.0 green:196/255.0 blue:67/255.0 alpha:1];
    UIColor *color5 = [UIColor colorWithRed:87/255.0 green:189/255.0 blue:106/255.0 alpha:1];
    UIColor *color6 = [UIColor colorWithRed:75/255.0 green:173/255.0 blue:248/255.0 alpha:1];
    UIColor *color7 = [UIColor colorWithRed:98/255.0 green:107/255.0 blue:232/255.0 alpha:1];
    
    _colors = @[color1,color1,color2,color3,color4,color5,color6,color7,color7];
    
    [self makeTool];

}

- (void)makeTool
{
    float itemheight = 44.0 ;
    float itemSpace = 10.0 ;
    
    UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - itemheight - 10, 44.0, itemheight, self.view.frame.size.height - 88.0)];
    toolView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:toolView];
    self.toolView = toolView;
    
    for (int i = 0; i < 9; i++) {
        UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(0, (itemheight+itemSpace)*i, itemheight, itemheight)];
        colorView.backgroundColor = [UIColor clearColor];
        colorView.tag = i;
        [self.toolView addSubview:colorView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(colorButtonClick:)];
        [colorView addGestureRecognizer:tap];
        
        if (i == 0) {
            UIButton *reverseButton = [UIButton buttonWithType:UIButtonTypeCustom];
            reverseButton.frame = colorView.bounds;
            [reverseButton setTitle:@"撤销" forState:UIControlStateNormal];
            [reverseButton setBackgroundColor:[UIColor clearColor]];
            [reverseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            reverseButton.tag = 100;
            [reverseButton.titleLabel setAdjustsFontSizeToFitWidth:YES];
            reverseButton.userInteractionEnabled = NO;
            [colorView addSubview:reverseButton];
        } else if (i == 8) {
            UIButton *fontButton = [UIButton buttonWithType:UIButtonTypeCustom];
            fontButton.frame = colorView.bounds;
            [fontButton setTitle:@"T" forState:UIControlStateNormal];
            [fontButton setBackgroundColor:[UIColor clearColor]];
            [fontButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [fontButton.titleLabel setFont:[UIFont systemFontOfSize:30 ]];
            fontButton.tag = 100;
            [fontButton.titleLabel setAdjustsFontSizeToFitWidth:YES];
            fontButton.userInteractionEnabled = NO;
            [colorView addSubview:fontButton];
        } else  {
            _normalRect = CGRectMake(10, 10, colorView.frame.size.width - 20, colorView.frame.size.height - 20);
            _selectRect = CGRectMake(8, 8, colorView.frame.size.width - 16, colorView.frame.size.height - 16);
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(10, 10, colorView.frame.size.width - 20, colorView.frame.size.height - 20);
            [button setBackgroundColor:_colors[i]];
            [button.layer setCornerRadius:button.frame.size.width/2.0];
            [button.layer setMasksToBounds:YES];
            [button.layer setBorderColor:[UIColor whiteColor].CGColor];
//            [button.layer setBorderWidth:3.0];
            button.userInteractionEnabled = NO;
            button.tag = 100;
            [button.titleLabel setAdjustsFontSizeToFitWidth:YES];
            [colorView addSubview:button];
            if (i == 1) {
                _currentButton = button;
                _currentButton.frame = _selectRect;
                [button.layer setCornerRadius:button.frame.size.width/2.0];
            }
        }
    }
    
    NSLog(@"lf");
    
    UIButton *saveButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.frame = CGRectMake(0, toolView.frame.size.height - 54.0, toolView.frame.size.width, 54.0);
    [saveButton setTitle:@"完成" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor colorWithRed:83/255.0 green:172/255.0 blue:57/255.0 alpha:1] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [saveButton.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [toolView addSubview:saveButton];
    
    UIButton *cancelButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(0, toolView.frame.size.height - 54.0 - 54.0, toolView.frame.size.width, 54.0);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:cancelButton];
}

- (void)colorButtonClick:(UIGestureRecognizer *)tap
{
    UIButton *sender = [tap.view viewWithTag:100];
    UIColor *currentColor = sender.backgroundColor;
    if (CGColorEqualToColor(currentColor.CGColor, [UIColor clearColor].CGColor)) {
        if (tap.view.tag == 8) {
            NSLog(@"点击了添加字体");
            [self showDrawEditTextView];
        } else {
            NSLog(@"空白色，这是撤销按钮");
            [self.drawViewImage revoke];
        }
    } else {
        NSLog(@"这是选中点击的颜色了");
        if (_currentButton) {
            _currentButton.frame = _normalRect;
            [_currentButton.layer setCornerRadius:_currentButton.frame.size.width/2.0];

            _currentButton = sender;
            _currentButton.frame = _selectRect;
            [_currentButton.layer setCornerRadius:_currentButton.frame.size.width/2.0];
        }
        self.drawViewImage.lineColor = currentColor;
    }
}

- (void)saveButtonClick
{
    __weak typeof(DrawViewDemo *)weakSelf = self;
    
    for (UIView *view in self.textViewArray) {
        [self.drawViewImage addSubview:view];
    }
    

    [self.drawViewImage EditResultBlockWithGetImage:^(int result, UIImage * _Nullable image) {
        [weakSelf editSuccess:image];
        
        [weakSelf dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
}

/// 图片处理完成
- (void)editSuccess:(UIImage *)image
{
    self.success(image);
}

- (void)cancelButtonClick
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)hideTool
{
    [UIView animateWithDuration:0.25 animations:^{
        self.toolView.alpha = 0;
    }];
}

- (void)showTool
{
    [UIView animateWithDuration:0.25 animations:^{
        self.toolView.alpha = 1;
    }];
}

- (DrawImageView *)drawViewImage
{
    if (!_drawViewImage) {
        _drawViewImage = [[DrawImageView alloc] initWithFrame:self.view.bounds];
        _drawViewImage.image = self.editImage;
    }
    
    return _drawViewImage;
}

/// 添加字体相关的
- (void)showDrawEditTextView
{
    for (UIView *sub in self.textViewArray) {
        sub.alpha = 0;
    }
    _curDrawTextView = nil;
    [self.editTextView show:nil];
}

- (DrawEditTextView *)editTextView
{
    if (!_editTextView) {
        _editTextView = [[DrawEditTextView alloc] init];
        [self.view addSubview:_editTextView];
        
        __weak typeof(DrawViewDemo *)weakSelf = self;
        
        self.editTextView.success = ^(DrawTextView * _Nonnull tv, BOOL isNewView, BOOL isCancel) {
            if (isCancel) {
                for (UIView *sub in weakSelf.textViewArray) {
                    sub.alpha = 1;
                }
            } else {
                [weakSelf addNewTextView:tv isNewView:isNewView];
            }
        };
    }
    return _editTextView;
}

- (void)addNewTextView:(DrawTextView *)tv isNewView:(BOOL)isNewView
{
    for (UIView *sub in self.textViewArray) {
        sub.alpha = 1;
    }
    
    if (isNewView) {
        DrawTextView *textView = [[DrawTextView alloc] initWithTextColor:tv.textColor text:tv.text];
        textView.delegate = self;
        [self.view addSubview:textView];
        
        [textView setCenter:self.view.center];
        
        [self.textViewArray addObject:textView];

    } else {
    
        if (tv.text.length <= 0) {
            [_curDrawTextView removeFromSuperview];
            [self.textViewArray removeObject:_curDrawTextView];
            return;
        }
        
        _curDrawTextView.textColor = tv.textColor;
        _curDrawTextView.text = tv.text;
        
        CGAffineTransform oldTransform = CGAffineTransformMake(self.curDrawTextView.transform.a, self.curDrawTextView.transform.b, self.curDrawTextView.transform.c, self.curDrawTextView.transform.d, self.curDrawTextView.transform.tx, self.curDrawTextView.transform.ty);
        
        [self.curDrawTextView setTransform:CGAffineTransformIdentity];
        
        CGPoint oldCenterPoint = _curDrawTextView.center;
        
        CGSize size = [self getSizeWithContent:tv.text];
    
        self.curDrawTextView.frame = CGRectMake( ([UIScreen mainScreen].bounds.size.width - 20 - size.width)/2.0, 0, size.width+10, size.height + 10);
        self.curDrawTextView.label.frame = self.curDrawTextView.bounds;
        [self.curDrawTextView setTransform:oldTransform];
        
        [_curDrawTextView setCenter:oldCenterPoint];
        
        _curDrawTextView.label.textColor = tv.textColor;
        _curDrawTextView.label.text = tv.text;
    
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

- (NSMutableArray *)textViewArray
{
    if (!_textViewArray) {
        _textViewArray = [[NSMutableArray alloc] init];
    }
    return _textViewArray;
}


#pragma mark - DrawTextViewDelegate
- (void)tapMe:(UIView *)tap
{
    self.curDrawTextView = (DrawTextView *)tap;
    for (UIView *sub in self.textViewArray) {
        sub.alpha = 0;
    }
    [self.editTextView show:self.curDrawTextView];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
