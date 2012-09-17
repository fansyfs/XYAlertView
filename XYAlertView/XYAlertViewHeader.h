//
//  XYAlertViewHeader.h
//
//  Created by Samuel on 7/27/12.
//  Copyright (c) 2012 Telenavsoftware. All rights reserved.
//

#ifndef XYAlertViewDemo_XYAlertViewHeader_h
#define XYAlertViewDemo_XYAlertViewHeader_h

#import "XYAlertView.h"
#import "XYLoadingView.h"
#import "XYInputView.h"
#import "XYAlertViewManager.h"

#define XYShowAlert(_MSG_) [[XYAlertViewManager sharedAlertViewManager] showAlertView:_MSG_]
#define XYShowLoading(_MSG_) [[XYAlertViewManager sharedAlertViewManager] showLoadingView:_MSG_]

#endif
