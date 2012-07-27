//
//  XYLoadingView.h
//
//  Created by Samuel Liu on 7/25/12.
//  Copyright (c) 2012 Telenavsoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYAlertViewManager.h"

@interface XYLoadingView : NSObject

@property (copy, nonatomic) NSString *message;

+(id)loadingViewWithMessage:(NSString *)message;
-(id)initWithMessaege:(NSString *)message;

-(void)show;
-(void)dismiss;
-(void)dismissWithMessage:(NSString*)message;

@end
