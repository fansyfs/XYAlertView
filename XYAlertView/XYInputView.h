//
//  XYInputView.h
//
//  Created by Samuel Liu on 8/25/12.
//  Copyright (c) 2012 Telenavsoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYAlertViewManager.h"

typedef void (^XYInputViewBlock)(int buttonIndex, NSString *text);

@interface XYInputView : NSObject

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *message;
@property (copy, nonatomic) NSString *initialText;
@property (copy, nonatomic) NSString *placeholder;
@property (retain, nonatomic) NSArray *buttons;
@property (readonly, nonatomic) NSMutableArray *buttonsStyle;
@property (copy, nonatomic) XYInputViewBlock blockAfterDismiss;

+(id)inputViewWithPlaceholder:(NSString*)placeholder
            initialText:(NSString*)initialText
            buttons:(NSArray*)buttonTitles
       afterDismiss:(XYInputViewBlock)block;

+(id)inputViewWithTitle:(NSString*)title
           message:(NSString*)message
       placeholder:(NSString*)placeholder
       initialText:(NSString*)initialText
           buttons:(NSArray*)buttonTitles
      afterDismiss:(XYInputViewBlock)block;

//-(id)initWithPlaceholder:(NSString*)placeholder
//       initialText:(NSString*)initialText
//           buttons:(NSArray*)buttonTitles
//      afterDismiss:(XYInputViewBlock)block;

-(id)initWithTitle:(NSString*)title
           message:(NSString*)message
       placeholder:(NSString*)placeholder
       initialText:(NSString*)initialText
           buttons:(NSArray*)buttonTitles
      afterDismiss:(XYInputViewBlock)block;

-(void)setButtonStyle:(XYButtonStyle)style atIndex:(int)index;

-(void)show;
-(void)dismiss:(int)buttonIndex;

@end
