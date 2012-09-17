//
//  XYInputView.m
//
//  Created by Samuel Liu on 8/25/12.
//  Copyright (c) 2012 Telenavsoftware. All rights reserved.
//

#import "XYInputView.h"

@implementation XYInputView

@synthesize placeholder = _placeholder;
@synthesize initialText = _initialText;
@synthesize buttons = _buttons;
@synthesize buttonsStyle = _buttonsStyle;
@synthesize blockAfterDismiss = _blockAfterDismiss;

+(id)inputViewWithPlaceholder:(NSString*)placeholder
                  initialText:(NSString*)initialText
                      buttons:(NSArray*)buttonTitles
                 afterDismiss:(XYInputViewBlock)block;
{
    return [[XYInputView alloc] initWithPlaceholder:placeholder
                                  initialText:initialText
                                      buttons:buttonTitles
                                 afterDismiss:block];
}

-(id)initWithPlaceholder:(NSString*)placeholder
             initialText:(NSString*)initialText
                 buttons:(NSArray*)buttonTitles
            afterDismiss:(XYInputViewBlock)block;
{
    self = [self init];
    if(self)
    {
        self.placeholder = placeholder;
        self.initialText = initialText;
        self.buttons = buttonTitles;
        self.blockAfterDismiss = block;
    }
    return self;
}

-(void)setButtonStyle:(XYButtonStyle)style atIndex:(int)index
{
    if(index < [_buttonsStyle count])
        [_buttonsStyle replaceObjectAtIndex:index withObject:[NSNumber numberWithInt:style]];
}

-(void)setButtons:(NSArray *)buttons
{
    _buttons = buttons;
    _buttonsStyle = nil;
    _buttonsStyle = [NSMutableArray arrayWithCapacity:buttons.count];
    for (int i = 0; i < buttons.count; i++)
        [_buttonsStyle addObject:[NSNumber numberWithInt:XYButtonStyleDefault]];
}

-(void)show
{
    [[XYAlertViewManager sharedAlertViewManager] show:self];
}

-(void)dismiss:(int)buttonIndex
{
    [[XYAlertViewManager sharedAlertViewManager] dismiss:self button:buttonIndex];
}

@end
