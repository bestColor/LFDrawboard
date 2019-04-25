//
//  DrawEditTextView.m
//  TotalTest
//
//  Created by libx on 2019/4/16.
//  Copyright © 2019 lifeng. All rights reserved.
//

#import "DrawEditTextView.h"

#define kTVFontSize 25*kSCREEN_SPACE

@interface DrawEditTextView()<UITextViewDelegate>
@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, assign) CGRect showRect;
@property (nonatomic, assign) CGRect hideRect;

@property (nonatomic, strong) DrawTextView *currentView;    // 当前正在编辑的模型view
@property (nonatomic, assign) BOOL isNewView;               // 是否是新的view

@property (nonatomic, assign) float maxHeightOfTV;          // TV的最高高度
@property (nonatomic, assign) float keyboardheight;         // 键盘的高度

@property (nonatomic, strong) NSArray *colors;              // 颜色数据源
@property (nonatomic, strong) NSMutableArray *colorButtons; // 颜色button数据源
@property (nonatomic, assign) CGRect selectRect;            // 颜色按钮选中尺寸
@property (nonatomic, assign) CGRect normalRect;            // 颜色按钮默认尺寸
@property (nonatomic, strong) UIButton *curColorButton;     // 当前颜色选中的按钮


@end

@implementation DrawEditTextView

- (void)dealloc
{
    NSLog(@"字体编辑界面的键盘界面释放");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


/// 当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];

    float height = keyboardRect.size.height + 44 ;
    

    _keyboardheight = height;
    _maxHeightOfTV = [UIScreen mainScreen].bounds.size.height - height - 44.0;
}

/// 当键盘消失
- (void)keyboardHideShow:(NSNotification *)noti
{
    NSLog(@"haha");
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        UIColor *color1 = [UIColor whiteColor];
        UIColor *color2 = [UIColor blackColor];
        UIColor *color3 = [UIColor colorWithRed:232/255.0 green:93/255.0 blue:88/255.0 alpha:1];
        UIColor *color4 = [UIColor colorWithRed:247/255.0 green:196/255.0 blue:67/255.0 alpha:1];
        UIColor *color5 = [UIColor colorWithRed:87/255.0 green:189/255.0 blue:106/255.0 alpha:1];
        UIColor *color6 = [UIColor colorWithRed:75/255.0 green:173/255.0 blue:248/255.0 alpha:1];
        UIColor *color7 = [UIColor colorWithRed:98/255.0 green:107/255.0 blue:232/255.0 alpha:1];
        
        _colors = @[color1,color2,color3,color4,color5,color6,color7];
        
        
        //增加监听，当键盘出现或改变时收出消息
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardHideShow:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        _maxHeightOfTV = 300;
        _isNewView = NO;
        [self makeView];
    }
    return self;
}

- (void)makeView
{
    self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    
    self.hideRect = self.frame;
    self.showRect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    UIButton *saveButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.frame = CGRectMake(self.frame.size.width - 64, 10, 64, 54.0);
    [saveButton setTitle:@"完成" forState:UIControlStateNormal];
    [saveButton.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [saveButton setTitleColor:[UIColor colorWithRed:83/255.0 green:172/255.0 blue:57/255.0 alpha:1] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:saveButton];
    
    UIButton *cancelButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(0, 10, 64, 54.0);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelButton];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 150, self.frame.size.width - 20, 30)];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.font = [UIFont systemFontOfSize:25];
    _textView.textColor = [UIColor whiteColor];
    _textView.delegate = self;
    _textView.textAlignment = NSTextAlignmentCenter;
    _textView.returnKeyType = UIReturnKeyDone;
    _textView.scrollEnabled = NO;
    [self addSubview:_textView];
    
    
    float itemheight = 44.0 ;
    float itemSpace = 20.0 ;
    
    UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, itemheight)];
    toolView.backgroundColor = [UIColor clearColor];
    _textView.inputAccessoryView = toolView;
    
    for (int i = 0; i < _colors.count; i++) {
        UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake((itemheight + itemSpace) * i, 0, itemheight, itemheight)];
        colorView.backgroundColor = [UIColor clearColor];
        colorView.tag = i;
        [toolView addSubview:colorView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(colorButtonClick:)];
        [colorView addGestureRecognizer:tap];
        
        
        _normalRect = CGRectMake(10, 10, colorView.frame.size.width - 20, colorView.frame.size.height - 20);
        _selectRect = CGRectMake(8, 8, colorView.frame.size.width - 16, colorView.frame.size.height - 16);
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10, 10, colorView.frame.size.width - 20, colorView.frame.size.height - 20);
        [button setBackgroundColor:_colors[i]];
        [button.layer setCornerRadius:button.frame.size.width/2.0];
        [button.layer setMasksToBounds:YES];
//        [button.layer setBorderColor:[UIColor whiteColor].CGColor];
//        [button.layer setBorderWidth:3.0];
        button.userInteractionEnabled = NO;
        button.tag = 100;
        [colorView addSubview:button];
        [self.colorButtons addObject:button];
        if (i == 1) {
            _curColorButton = button;
            _curColorButton.frame = _selectRect;
            [button.layer setCornerRadius:button.frame.size.width/2.0];
        }
    }
}

- (void)colorButtonClick:(UIGestureRecognizer *)tap
{
    UIButton *sender = [tap.view viewWithTag:100];
    UIColor *currentColor = sender.backgroundColor;
    NSLog(@"这是选中点击的字体颜色了");
    if (_curColorButton) {
        _curColorButton.frame = _normalRect;
        [_curColorButton.layer setCornerRadius:_curColorButton.frame.size.width/2.0];
        
        _curColorButton = sender;
        _curColorButton.frame = _selectRect;
        [_curColorButton.layer setCornerRadius:_curColorButton.frame.size.width/2.0];
    }
    
    _textView.textColor = currentColor;
}

- (void)saveButtonClick
{
    _currentView.textColor = _textView.textColor;

    self.success(_currentView, _isNewView, NO);
    [self hide];
}

- (void)cancelButtonClick
{
    self.success(_currentView, _isNewView, YES);
    [self hide];
}

/// 更新tv的frame
- (void)updateTVFrame
{
    dispatch_async(dispatch_get_main_queue(), ^{
        CGSize size = CGSizeMake(0, 30);
        if (self.currentView.text.length) {
            size = [self getSizeWithContent:self.currentView.text];
        }
        
        float y = (([UIScreen mainScreen].bounds.size.height - self.keyboardheight) - size.height) / 2.0 + 44.0;
        
        self.textView.frame = CGRectMake(10, y, self.textView.frame.size.width, size.height+10);
        
        if (self.textView.text.length) {
            [self updateTextView:self.textView];
        }
    });
}

/// 默认选中的颜色
- (void)selectedColor:(DrawTextView *)tv
{
    [self updateTVFrame];
    
    // 这里设置选中的颜色
    if (_curColorButton) {
        _curColorButton.frame = _normalRect;
        [_curColorButton.layer setCornerRadius:_curColorButton.frame.size.width/2.0];
    }
    
    for (UIButton *sender in self.colorButtons) {
        NSLog(@"sender = %@ - %@",sender.backgroundColor,tv.textColor);
        if (CGColorEqualToColor(sender.backgroundColor.CGColor, tv.textColor.CGColor)) {
            _curColorButton = sender;
            _curColorButton.frame = _selectRect;
            [_curColorButton.layer setCornerRadius:_curColorButton.frame.size.width/2.0];
            break;
        }
    }

}

/// 获取tv的size
- (CGSize)getSizeWithContent:(NSString *)text
{
    
    CGRect contentBounds = [text boundingRectWithSize:CGSizeMake(_textView.frame.size.width, _maxHeightOfTV)
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:17]
                                                                                     forKey:NSFontAttributeName]
                                                 context:nil];
    return contentBounds.size;
    
}

/// 是点击已经存在的view，还是新的view
- (void)show:(DrawTextView *)drawTextView
{
    if (drawTextView) {
        _isNewView = NO;
        _currentView = drawTextView;
        _textView.textColor = drawTextView.textColor;
        _textView.text = drawTextView.text;
    } else {
        _isNewView = YES;
        DrawTextView *newDrawTV = [[DrawTextView alloc] initWithTextColor:[UIColor whiteColor] text:@""];
        _currentView = newDrawTV;
        _textView.textColor = [UIColor whiteColor];
        _textView.text = @"";
    }
    [_textView becomeFirstResponder];
    [self selectedColor:drawTextView];


    __weak typeof(DrawEditTextView *)weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.frame = weakSelf.showRect;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hide
{
    [_textView resignFirstResponder];
    
    __weak typeof(DrawEditTextView *)weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.frame = weakSelf.hideRect;
    }];
}

- (NSMutableArray *)colorButtons
{
    if (!_colorButtons) {
        _colorButtons = [[NSMutableArray alloc] init];
    }
    return _colorButtons;
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    

    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{

    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        [self saveButtonClick];
        return NO;
    }

    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self updateTextView:textView];
}

- (void)updateTextView:(UITextView *)textView
{
    _currentView.text = textView.text;
    
    CGRect frame = textView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    if (size.height<=frame.size.height) {
        size.height=frame.size.height;
    }else{
        if (size.height >= _maxHeightOfTV)
        {
            size.height = _maxHeightOfTV;
            textView.scrollEnabled = YES;   // 允许滚动
        }
        else
        {
            textView.scrollEnabled = NO;    // 不允许滚动
        }
    }
    
    float y = (([UIScreen mainScreen].bounds.size.height - _keyboardheight) - size.height) / 2.0 + 44.0;
    textView.frame = CGRectMake(frame.origin.x, y, frame.size.width, size.height);
}

@end
