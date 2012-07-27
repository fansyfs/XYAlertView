//
//  XYAlertView.m
//
//  Created by Samuel Liu on 7/25/12.
//  Copyright (c) 2012 Telenavsoftware. All rights reserved.
//

#import "XYAlertView.h"

@implementation XYAlertView

@synthesize title = _title;
@synthesize message = _message;
@synthesize buttons = _buttons;
@synthesize buttonsStyle = _buttonsStyle;
@synthesize blockAfterDismiss = _blockAfterDismiss;

+(id)alertViewWithTitle:(NSString*)title
            message:(NSString*)message
            buttons:(NSArray*)buttonTitles
       afterDismiss:(XYAlertViewBlock)block
{
    return [[XYAlertView alloc] initWithTitle:title message:message buttons:buttonTitles afterDismiss:block];
}

-(id)initWithTitle:(NSString*)title
           message:(NSString*)message
           buttons:(NSArray*)buttonTitles
      afterDismiss:(XYAlertViewBlock)block
{
    self = [self init];
    if(self)
    {
        self.title = title;
        self.message = message;
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
