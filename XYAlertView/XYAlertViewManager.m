//
//  XYAlertViewManager.m
//  DDMates
//
//  Created by Samuel Liu on 7/25/12.
//  Copyright (c) 2012 TelenavSoftware, Inc. All rights reserved.
//

#import "XYAlertViewManager.h"
#import "XYLoadingView.h"
#import "XYAlertView.h"
#import "XYInputView.h"
#import "GCPlaceholderTextView.h"

#define AlertViewWidth 280.0f
#define AlertViewHeight 175.0f

CGRect XYScreenBounds()
{
    CGRect bounds = [UIScreen mainScreen].bounds;
    UIInterfaceOrientation orient = [UIApplication sharedApplication].statusBarOrientation;
    if (UIDeviceOrientationUnknown == orient)
        orient = UIDeviceOrientationPortrait;

    if (UIInterfaceOrientationIsLandscape(orient))
    {
        CGFloat width = bounds.size.width;
        bounds.size.width = bounds.size.height;
        bounds.size.height = width;
    }
    return bounds;
}

@implementation XYAlertViewManager

static XYAlertViewManager *sharedAlertViewManager = nil;

+(XYAlertViewManager*)sharedAlertViewManager
{
    @synchronized(self)
    {
        if(!sharedAlertViewManager)
            sharedAlertViewManager = [[XYAlertViewManager alloc] init];
    }
    
    return sharedAlertViewManager;
}

-(id)init 
{
    self = [super init];
    if(self)
    {
        _alertViewQueue = [[NSMutableArray alloc] init];
        _isDismissing = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didChangeOrientation:)
                                                     name:UIApplicationDidChangeStatusBarOrientationNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [_alertViewQueue removeAllObjects];
    [_loadingTimer invalidate];
}

#pragma mark - UIApplicationDidChangeStatusBarOrientationNotification

-(void)didChangeOrientation:(NSNotification*)notification
{
//    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if(_alertViewQueue.count > 0)
    {
        CGRect screenBounds = XYScreenBounds();
        _blackBG.frame = CGRectMake(0, 0, screenBounds.size.width, screenBounds.size.height);
        _alertView.center = CGPointMake(screenBounds.size.width / 2, screenBounds.size.height / 2);
        _loadingLabel.frame = CGRectMake(0, _alertView.frame.origin.y + _alertView.frame.size.height + 10, screenBounds.size.width, 30);
    }
}

#pragma mark - private

-(UIImage*)buttonImageByStyle:(XYButtonStyle)style state:(UIControlState)state
{
    switch(style)
    {
        default:
        case XYButtonStyleGray:
            return [[UIImage imageNamed:(state == UIControlStateNormal ? @"alertView_button_gray.png" : @"alertView_button_gray_pressed.png")] stretchableImageWithLeftCapWidth:22 topCapHeight:22];
        case XYButtonStyleGreen:
            return [[UIImage imageNamed:(state == UIControlStateNormal ? @"alertView_button_green.png" : @"alertView_button_green_pressed.png")] stretchableImageWithLeftCapWidth:22 topCapHeight:22];
    }
}

-(void)prepareLoadingToDisplay:(XYLoadingView*)entity
{
    CGRect screenBounds = XYScreenBounds();
    if(!_blackBG)
    {
        _blackBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenBounds.size.width, screenBounds.size.height)];
        _blackBG.backgroundColor = [UIColor blackColor];
        _blackBG.opaque = YES;
        _blackBG.alpha = 0.5f;
        _blackBG.userInteractionEnabled = YES;
    }
    
    _blackBG.frame = CGRectMake(0, 0, screenBounds.size.width, screenBounds.size.height);
    
    _alertView = nil;
    _alertView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alertView_loading.png"]];
    _alertView.center = CGPointMake(screenBounds.size.width / 2, screenBounds.size.height / 2);
    
    _loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenBounds.size.width, 30)];
    _loadingLabel.textAlignment = UITextAlignmentCenter;
    _loadingLabel.backgroundColor = [UIColor clearColor];
    _loadingLabel.textColor = [UIColor whiteColor];
    _loadingLabel.font = [UIFont boldSystemFontOfSize:14];
    _loadingLabel.text = entity.message;
    _loadingLabel.numberOfLines = 2;
}

-(void)prepareAlertToDisplay:(XYAlertView*)entity
{
    CGRect screenBounds = XYScreenBounds();
    if(!_blackBG)
    {
        _blackBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenBounds.size.width, screenBounds.size.height)];
        _blackBG.backgroundColor = [UIColor blackColor];
        _blackBG.opaque = YES;
        _blackBG.alpha = 0.5f;
        _blackBG.userInteractionEnabled = YES;
    }
    
    _blackBG.frame = CGRectMake(0, 0, screenBounds.size.width, screenBounds.size.height);

    _alertView = nil;
    _alertView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"alertView_bg.png"] stretchableImageWithLeftCapWidth:34 topCapHeight:44]];
    _alertView.userInteractionEnabled = YES;
    _alertView.frame = CGRectMake(0, 0, AlertViewWidth, AlertViewHeight);
    _alertView.center = CGPointMake(screenBounds.size.width / 2, screenBounds.size.height / 2);

    UILabel *_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 15, 240, 30)];
    _titleLabel.textAlignment = UITextAlignmentLeft;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont boldSystemFontOfSize:20];
    _titleLabel.text = entity.title;
    [_alertView addSubview:_titleLabel];
    
    UILabel *_messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 35, 240, 60)];
    _messageLabel.textAlignment = UITextAlignmentLeft;
    _messageLabel.backgroundColor = [UIColor clearColor];
    _messageLabel.textColor = [UIColor whiteColor];
    _messageLabel.font = [UIFont boldSystemFontOfSize:14];
    _messageLabel.lineBreakMode = UILineBreakModeWordWrap;
    _messageLabel.numberOfLines = 3;
    _messageLabel.text = entity.message;
    [_alertView addSubview:_messageLabel];

    float buttonWidth = (AlertViewWidth - 100.0f) / entity.buttons.count;
    float buttonPadding = 100.0f / (entity.buttons.count - 1 + 2 * 2);
    
    for(int i = 0; i < entity.buttons.count; i++)
    {
        NSString *buttonTitle = [entity.buttons objectAtIndex:i];
        XYButtonStyle style = [[entity.buttonsStyle objectAtIndex:i] intValue];

        UIButton *_button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setTitle:buttonTitle forState:UIControlStateNormal];
        _button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _button.titleLabel.shadowOffset = CGSizeMake(1, 1);
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_button setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_button setBackgroundImage:[self buttonImageByStyle:style state:UIControlStateNormal]
                           forState:UIControlStateNormal];
        [_button setBackgroundImage:[self buttonImageByStyle:style state:UIControlStateHighlighted]
                           forState:UIControlStateHighlighted];

        _button.frame = CGRectMake(buttonPadding * 2 + buttonWidth * i + buttonPadding * i, 107,
                                   buttonWidth, 44);
        _button.tag = i;

        [_button addTarget:self action:@selector(onButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_alertView addSubview:_button];
    }
}

-(void)prepareInputToDisplay:(XYInputView*)entity
{
    CGRect screenBounds = XYScreenBounds();
    if(!_blackBG)
    {
        _blackBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenBounds.size.width, screenBounds.size.height)];
        _blackBG.backgroundColor = [UIColor blackColor];
        _blackBG.opaque = YES;
        _blackBG.alpha = 0.5f;
        _blackBG.userInteractionEnabled = YES;
    }
    
    _blackBG.frame = CGRectMake(0, 0, screenBounds.size.width, screenBounds.size.height);
    
    _alertView = nil;
    _alertView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"alertView_bg.png"] stretchableImageWithLeftCapWidth:34 topCapHeight:44]];
    _alertView.userInteractionEnabled = YES;
    _alertView.frame = CGRectMake(0, 0, AlertViewWidth, AlertViewHeight + 20);
    _alertView.center = CGPointMake(screenBounds.size.width / 2, screenBounds.size.height / 2);

    if(entity.title && entity.message)
    {
        UILabel *_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 10, 240, 30)];
        _titleLabel.textAlignment = UITextAlignmentLeft;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:20];
        _titleLabel.text = entity.title;
        [_alertView addSubview:_titleLabel];
        
        UILabel *_messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 40, 240, 20)];
        _messageLabel.textAlignment = UITextAlignmentLeft;
        _messageLabel.backgroundColor = [UIColor clearColor];
        _messageLabel.textColor = [UIColor whiteColor];
        _messageLabel.font = [UIFont systemFontOfSize:14];
        _messageLabel.lineBreakMode = UILineBreakModeWordWrap;
        _messageLabel.numberOfLines = 1;
        _messageLabel.text = entity.message;
        [_alertView addSubview:_messageLabel];
        
        _textView = [[GCPlaceholderTextView alloc] initWithFrame:CGRectMake(30, 68, 220, 34)];
        _textView.backgroundColor = [UIColor clearColor];
        
        UIImageView *_inputBGView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"alertView_input_bg.png"] stretchableImageWithLeftCapWidth:50 topCapHeight:17]];
        _inputBGView.frame = CGRectMake(20, 68, 240, 34);
        [_alertView addSubview:_inputBGView];
    }
    else
    {
        _textView = [[GCPlaceholderTextView alloc] initWithFrame:CGRectMake(20, 15, 240, 95)];
        _textView.backgroundColor = [UIColor whiteColor];
    }

    _textView.returnKeyType = UIReturnKeyDone;
    _textView.delegate = self;
    _textView.placeholder = entity.placeholder;
    _textView.font = [UIFont systemFontOfSize:14];
    _textView.text = entity.initialText;

    [_alertView addSubview:_textView];
    
    float buttonWidth = (AlertViewWidth - 100.0f) / entity.buttons.count;
    float buttonPadding = 100.0f / (entity.buttons.count - 1 + 2 * 2);
    
    for(int i = 0; i < entity.buttons.count; i++)
    {
        NSString *buttonTitle = [entity.buttons objectAtIndex:i];
        XYButtonStyle style = [[entity.buttonsStyle objectAtIndex:i] intValue];
        
        UIButton *_button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setTitle:buttonTitle forState:UIControlStateNormal];
        _button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _button.titleLabel.shadowOffset = CGSizeMake(1, 1);
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_button setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_button setBackgroundImage:[self buttonImageByStyle:style state:UIControlStateNormal]
                           forState:UIControlStateNormal];
        [_button setBackgroundImage:[self buttonImageByStyle:style state:UIControlStateHighlighted]
                           forState:UIControlStateHighlighted];
        
        _button.frame = CGRectMake(buttonPadding * 2 + buttonWidth * i + buttonPadding * i, 127,
                                   buttonWidth, 44);
        _button.tag = i;
        
        [_button addTarget:self action:@selector(onButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_alertView addSubview:_button];
    }
}

-(void)updateLoadingAnimation
{
    CGAffineTransform transform = _alertView.transform;
    transform = CGAffineTransformRotate(transform, M_PI / 20);
    _alertView.transform = transform;
}

-(void)checkoutInStackAlertView
{
    if(_alertViewQueue.count > 0)
    {
        id entity = [_alertViewQueue lastObject];

        [_loadingTimer invalidate];
        _loadingTimer = nil;
        [_alertView removeFromSuperview];
        [_blackBG removeFromSuperview];
        [_loadingLabel removeFromSuperview];
        
        if([entity isKindOfClass:[XYAlertView class]])
        {
            [self prepareAlertToDisplay:entity];
            [self showAlertViewWithAnimation:entity];
        }
        else if([entity isKindOfClass:[XYLoadingView class]])
        {
            [self prepareLoadingToDisplay:entity];
            [self showLoadingViewWithAnimation:entity];
        }
        else if([entity isKindOfClass:[XYInputView class]])
        {
            [self prepareInputToDisplay:entity];
            [self showInputViewWithAnimation:entity];
        }
    }
}

-(void)onButtonTapped:(id)sender
{
    [self dismiss:[_alertViewQueue lastObject] button:((UIButton*)sender).tag];
}

#pragma mark - animation

-(void)showAlertViewWithAnimation:(id)entity
{
    if([entity isKindOfClass:[XYAlertView class]])
    {
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        if(!keyWindow)
        {
            NSArray *windows = [UIApplication sharedApplication].windows;
            if(windows.count > 0) keyWindow = [windows lastObject];
            keyWindow = [windows objectAtIndex:0];
        }
        UIView *containerView = [[keyWindow subviews] objectAtIndex:0];
        
        _blackBG.alpha = 0.0f;
        CGRect frame = _alertView.frame;
        frame.origin.y = -AlertViewHeight;
        _alertView.frame = frame;
        [containerView addSubview:_blackBG];
        [containerView addSubview:_alertView];
        
        [UIView animateWithDuration:0.2f animations:^{
            _blackBG.alpha = 0.5f;
            _alertView.center = CGPointMake(XYScreenBounds().size.width / 2, XYScreenBounds().size.height / 2);
        }
                         completion:^(BOOL finished) {
                             
                         }];
    }
}

-(void)dismissAlertViewWithAnimation:(id)entity button:(int)buttonIndex
{
    if([entity isKindOfClass:[XYAlertView class]])
    {
        [UIView animateWithDuration:0.2f
                         animations:
         ^{
             _blackBG.alpha = 0.0f;
             CGRect frame = _alertView.frame;
             frame.origin.y = -AlertViewHeight;
             _alertView.frame = frame;
         }
                         completion:^(BOOL finished)
         {
             [_alertView removeFromSuperview];
             [_blackBG removeFromSuperview];
             
             [_alertViewQueue removeLastObject];
             _isDismissing = NO;

             if(((XYAlertView*)entity).blockAfterDismiss)
                 ((XYAlertView*)entity).blockAfterDismiss(buttonIndex);

             [self checkoutInStackAlertView];
         }];
    }
}

-(void)showLoadingViewWithAnimation:(id)entity
{
    if([entity isKindOfClass:[XYLoadingView class]])
    {
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        if(!keyWindow)
        {
            NSArray *windows = [UIApplication sharedApplication].windows;
            if(windows.count > 0) keyWindow = [windows lastObject];
            keyWindow = [windows objectAtIndex:0];
        }
        UIView *containerView = [[keyWindow subviews] objectAtIndex:0];
        
        _blackBG.alpha = 0.0f;
        CGRect frame = _alertView.frame;
        frame.origin.y = -AlertViewHeight;
        _alertView.frame = frame;
        frame = _loadingLabel.frame;
        frame.origin.y = XYScreenBounds().size.height;
        _loadingLabel.frame = frame;
        [containerView addSubview:_blackBG];
        [containerView addSubview:_alertView];
        [containerView addSubview:_loadingLabel];
        
        _loadingTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(updateLoadingAnimation) userInfo:nil repeats:YES];
        
        [UIView animateWithDuration:0.2f animations:^{
            _blackBG.alpha = 0.5f;
            _alertView.center = CGPointMake(XYScreenBounds().size.width / 2, XYScreenBounds().size.height / 2);
            CGRect frame = _loadingLabel.frame;
            frame.origin.y = _alertView.frame.origin.y + _alertView.frame.size.height + 10;
            _loadingLabel.frame = frame;
        }
                         completion:^(BOOL finished) {
                         }];
    }
}

-(void)dismissLoadingViewWithAnimation:(id)entity
{
    if([entity isKindOfClass:[XYLoadingView class]])
    {
        [UIView animateWithDuration:0.2f
                         animations:
         ^{
             _blackBG.alpha = 0.0f;
             CGRect frame = _alertView.frame;
             frame.origin.y = -AlertViewHeight;
             _alertView.frame = frame;
             frame = _loadingLabel.frame;
             frame.origin.y = XYScreenBounds().size.height;
             _loadingLabel.frame = frame;
         }
                         completion:^(BOOL finished)
         {
             [_loadingTimer invalidate];
             _loadingTimer = nil;
             [_alertView removeFromSuperview];
             [_blackBG removeFromSuperview];
             [_loadingLabel removeFromSuperview];

             [_alertViewQueue removeLastObject];

             _isDismissing = NO;

             [self checkoutInStackAlertView];
         }];
    }
}

-(void)showInputViewWithAnimation:(id)entity
{
    if([entity isKindOfClass:[XYInputView class]])
    {
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        if(!keyWindow)
        {
            NSArray *windows = [UIApplication sharedApplication].windows;
            if(windows.count > 0) keyWindow = [windows lastObject];
            keyWindow = [windows objectAtIndex:0];
        }
        UIView *containerView = [[keyWindow subviews] objectAtIndex:0];
        
        _blackBG.alpha = 0.0f;
        CGRect frame = _alertView.frame;
        frame.origin.y = -AlertViewHeight;
        _alertView.frame = frame;
        [containerView addSubview:_blackBG];
        [containerView addSubview:_alertView];
        
        [UIView animateWithDuration:0.2f animations:^{
            _blackBG.alpha = 0.5f;
            _alertView.center = CGPointMake(XYScreenBounds().size.width / 2, XYScreenBounds().size.height / 2);
        }
                         completion:^(BOOL finished) {
                             
                         }];
    }
}

-(void)dismissInputViewWithAnimation:(id)entity button:(int)buttonIndex
{
    if([entity isKindOfClass:[XYInputView class]])
    {
        [UIView animateWithDuration:0.2f
                         animations:
         ^{
             _blackBG.alpha = 0.0f;
             CGRect frame = _alertView.frame;
             frame.origin.y = -AlertViewHeight;
             _alertView.frame = frame;
         }
                         completion:^(BOOL finished)
         {
             [_alertView removeFromSuperview];
             [_blackBG removeFromSuperview];
             
             [_alertViewQueue removeLastObject];
             _isDismissing = NO;
             
             if(((XYInputView*)entity).blockAfterDismiss)
                 ((XYInputView*)entity).blockAfterDismiss(buttonIndex, _textView.text);
             
             [self checkoutInStackAlertView];
         }];
    }
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"])
    {
        id entity = [_alertViewQueue lastObject];
        if(entity && [entity isKindOfClass:[XYInputView class]])
        {
            _isDismissing = YES;
            [self dismissInputViewWithAnimation:entity button:1];
            
            return NO;
        }
        else
        {
            return YES;
        }
    }
    else
    {
        return YES;
    }
}

#pragma mark - keyboard

-(void)changeLayoutByKeyboardTop:(CGFloat)keyboardTop andAnimationDuration:(double)animationDuration
{
    if(_isDismissing)
        return;

    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:animationDuration];
	
    if(_alertViewQueue.count > 0)
    {
        CGRect screenBounds = XYScreenBounds();
        _blackBG.frame = CGRectMake(0, 0, screenBounds.size.width, screenBounds.size.height);
        _alertView.center = CGPointMake(screenBounds.size.width / 2, keyboardTop / 2);
        _loadingLabel.frame = CGRectMake(0, _alertView.frame.origin.y + _alertView.frame.size.height + 10, screenBounds.size.width, 30);
    }
    
	[UIView commitAnimations];
}

-(void)keyboardWillShow:(NSNotification *)notification
{
    CGRect endRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];

	double animationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    if(animationDuration == 0) animationDuration = 0.25;
	
	[self changeLayoutByKeyboardTop:endRect.origin.y andAnimationDuration:animationDuration];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    CGRect endRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];

	double animationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    if(animationDuration == 0) animationDuration = 0.25;
	
	[self changeLayoutByKeyboardTop:endRect.origin.y andAnimationDuration:animationDuration];
}

#pragma mark - public

-(XYAlertView*)showAlertView:(NSString*)message
{
    XYAlertView *alertView = [XYAlertView alertViewWithTitle:@"注意"
                                                     message:message
                                                     buttons:[NSArray arrayWithObjects:@"确定", nil]
                                                afterDismiss:nil];
    [self show:alertView];
    
    return alertView;
}

-(XYLoadingView*)showLoadingView:(NSString*)message
{
    XYLoadingView *loadingView = [XYLoadingView loadingViewWithMessage:message];
    [self show:loadingView];
    
    return loadingView;
}

-(void)show:(id)entity
{
    if([entity isKindOfClass:[XYAlertView class]] ||
       [entity isKindOfClass:[XYLoadingView class]] ||
       [entity isKindOfClass:[XYInputView class]])
    {
        if(_isDismissing == YES && _alertViewQueue.count > 0)
        {
            [_alertViewQueue insertObject:entity atIndex:_alertViewQueue.count - 1];
        }
        else
        {
            [_alertViewQueue addObject:entity];
            
            [_loadingTimer invalidate];
            _loadingTimer = nil;
            [_alertView removeFromSuperview];
            [_blackBG removeFromSuperview];
            [_loadingLabel removeFromSuperview];
            
            if([entity isKindOfClass:[XYAlertView class]])
            {
                [self prepareAlertToDisplay:entity];
                [self showAlertViewWithAnimation:entity];
            }
            else if([entity isKindOfClass:[XYLoadingView class]])
            {
                [self prepareLoadingToDisplay:entity];
                [self showLoadingViewWithAnimation:entity];
            }
            else if([entity isKindOfClass:[XYInputView class]])
            {
                [self prepareInputToDisplay:entity];
                [self showInputViewWithAnimation:entity];
            }
        }
    }
}

-(void)dismiss:(id)entity
{
    [self dismiss:entity button:0];
}

-(void)dismiss:(id)entity button:(int)buttonIndex
{
    if(_alertViewQueue.count <= 0)
        return;

    if([entity isKindOfClass:[XYAlertView class]] ||
       [entity isKindOfClass:[XYLoadingView class]] ||
       [entity isKindOfClass:[XYInputView class]])
    {
        _isDismissing = YES;
        
        [_textView resignFirstResponder];

        if([entity isEqual:[_alertViewQueue lastObject]])
        {
            if([entity isKindOfClass:[XYAlertView class]])
                [self dismissAlertViewWithAnimation:entity button:buttonIndex];
            else if([entity isKindOfClass:[XYLoadingView class]])
                [self dismissLoadingViewWithAnimation:entity];
            else if([entity isKindOfClass:[XYInputView class]])
                [self dismissInputViewWithAnimation:entity button:buttonIndex];
        }
        else
        {
            [_alertViewQueue removeObject:entity];
            if([entity isKindOfClass:[XYAlertView class]])
                ((XYAlertView*)entity).blockAfterDismiss(buttonIndex);
        }
    }
}

-(void)dismissLoadingView:(id)entity withFailedMessage:(NSString*)message
{
    if(_alertViewQueue.count <= 0)
        return;
    
    if([entity isEqual:[_alertViewQueue lastObject]] && [entity isKindOfClass:[XYLoadingView class]])
    {
        _isDismissing = YES;

        XYAlertView *alertView = [XYAlertView alertViewWithTitle:@"注意"
                                                         message:message
                                                         buttons:[NSArray arrayWithObjects:@"确定", nil]
                                                    afterDismiss:nil];
        
        [_alertViewQueue insertObject:alertView atIndex:_alertViewQueue.count - 1];

        [self dismissLoadingViewWithAnimation:entity];
    }
}

-(void)cleanupAllViews
{
    [_loadingTimer invalidate];
    _loadingTimer = nil;
    [_alertView removeFromSuperview];
    _alertView = nil;
    [_blackBG removeFromSuperview];
    [_loadingLabel removeFromSuperview];
    [_textView resignFirstResponder];

    [_alertViewQueue removeAllObjects];
}

@end
