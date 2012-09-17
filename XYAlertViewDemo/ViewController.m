//
//  ViewController.m
//  XYAlertViewDemo
//
//  Created by Samuel Liu on 7/25/12.
//  Copyright (c) 2012 Telenavsoftware. All rights reserved.
//

#import "ViewController.h"
#import "XYAlertViewHeader.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(IBAction)easywayAlertView:(id)sender
{
    XYShowAlert(@"This's the simply way to show an alert!");
}

-(IBAction)easywayLoadingView:(id)sender
{
    XYLoadingView *loadingView = XYShowLoading(@"Easy Loading will gone in 5 secs...");
    
    [loadingView performSelector:@selector(dismiss) withObject:nil afterDelay:5];
}

-(IBAction)inputView:(id)sender
{
    XYInputView *inputView = [XYInputView inputViewWithPlaceholder:@"Please input something here..."
                                                       initialText:nil buttons:[NSArray arrayWithObjects:@"Cancel", @"Done", nil]
                                                      afterDismiss:^(int buttonIndex, NSString *text) {
                                                          if(buttonIndex == 1)
                                                              NSLog(@"text: %@", text);
                                                      }];
    [inputView setButtonStyle:XYButtonStyleGreen atIndex:1];
    [inputView show];
}

-(IBAction)singleAlertView:(id)sender
{
    // create an alertView
    XYAlertView *alertView = [XYAlertView alertViewWithTitle:@"Hello!"
                                                     message:@"This's the single alert view demo!"
                                                     buttons:[NSArray arrayWithObjects:@"Ok", @"Cancel", nil]
                                                afterDismiss:^(int buttonIndex) {
                                                    NSLog(@"button index: %d pressed!", buttonIndex);
                                                }];
    
    // set the second button as gray style
    [alertView setButtonStyle:XYButtonStyleGray atIndex:1];
    
    // display
    [alertView show];
}

-(IBAction)singleLoadingView:(id)sender
{
    // create a loading view
    XYLoadingView *loadingView = [XYLoadingView loadingViewWithMessage:@"Loading will complete in 5 seconds..."];
    
    // display
    [loadingView show];
    
    // dismiss loading view with popup message after 5 seconds
    [loadingView performSelector:@selector(dismissWithMessage:) withObject:@"The message comes out once loading view gone." afterDelay:5];
}

-(IBAction)threeAlertView:(id)sender
{
    // let's create 3 alert view ready to display
    XYAlertView *alertView1 = [XYAlertView alertViewWithTitle:@"Hello!"
                                                     message:@"AlertView1 AlertView1 AlertView1"
                                                     buttons:[NSArray arrayWithObjects:@"Ok", @"Cancel", nil]
                                                afterDismiss:^(int buttonIndex) {
                                                    NSLog(@"button index: %d pressed!", buttonIndex);
                                                }];
    XYAlertView *alertView2 = [XYAlertView alertViewWithTitle:@"Hello!"
                                                     message:@"AlertView2 AlertView2 AlertView2"
                                                     buttons:[NSArray arrayWithObjects:@"Ok", @"Cancel", nil]
                                                afterDismiss:^(int buttonIndex) {
                                                    NSLog(@"button index: %d pressed!", buttonIndex);
                                                }];
    XYAlertView *alertView3 = [XYAlertView alertViewWithTitle:@"Hello!"
                                                     message:@"AlertView3 AlertView3 AlertView3"
                                                     buttons:[NSArray arrayWithObjects:@"Ok", @"Cancel", nil]
                                                afterDismiss:^(int buttonIndex) {
                                                    NSLog(@"button index: %d pressed!", buttonIndex);
                                                }];
    
    // launch them one by one, then you will see the last one on screen
    [alertView1 show];
    [alertView2 show];
    [alertView3 show];
}

-(IBAction)mixedAlertView:(id)sender
{
    // an alert view first
    XYAlertView *alertView1 = [XYAlertView alertViewWithTitle:@"Hello!"
                                                      message:@"AlertView1 AlertView1 AlertView1"
                                                      buttons:[NSArray arrayWithObjects:@"Ok", @"Cancel", nil]
                                                 afterDismiss:^(int buttonIndex) {
                                                     NSLog(@"button index: %d pressed!", buttonIndex);
                                                 }];
    [alertView1 show];

    // loading view second
    XYLoadingView *loadingView = [XYLoadingView loadingViewWithMessage:@"Loading will be there forever!"];
    [loadingView show];
    
    // alert view last, when you tap the first button to dismiss the loading view in background
    XYAlertView *alertView2 = [XYAlertView alertViewWithTitle:@"Hello!"
                                                      message:@"AlertView2 tap close button for closing the loading view"
                                                      buttons:[NSArray arrayWithObjects:@"Close", @"Ok", @"Cancel", nil]
                                                 afterDismiss:^(int buttonIndex) {
                                                     if(buttonIndex == 0)
                                                         [loadingView dismiss];
                                                     NSLog(@"button index: %d pressed!", buttonIndex);
                                                 }];
    [alertView2 show];
}

@end
