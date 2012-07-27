//
//  XYAlertViewManager.h
//  DDMates
//
//  Created by Samuel Liu on 7/25/12.
//  Copyright (c) 2012 TelenavSoftware, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

CGRect XYScreenBounds();

@class XYAlertView;
@class XYLoadingView;

@interface XYAlertViewManager : NSObject
{
    NSMutableArray *_alertViewQueue;
    id _currentAlertView;

    UIImageView *_alertView;
    UIView *_blackBG;
    UILabel *_loadingLabel;

    NSTimer *_loadingTimer;
    
    Boolean _isDismissing;
}

+(XYAlertViewManager*)sharedAlertViewManager;

-(XYAlertView*)showAlertView:(NSString*)message;
-(XYLoadingView*)showLoadingView:(NSString*)message;

-(void)show:(id)entity;
-(void)dismiss:(id)entity;
-(void)dismiss:(id)entity button:(int)buttonIndex;
-(void)dismissLoadingView:(id)entity withFailedMessage:(NSString*)message;
-(void)cleanupAllViews;

@end
