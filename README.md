XYAlertView
===========

Customized alertView / loadingView for replacing UIAlertView. Support display queue, you will never miss any alert/loading view.
This component is part of the most popular social network in China, DouDouYou兜兜友 (http://ddy.me), which is available download at http://itunes.apple.com/us/app/dou-dou-you/id379405145?mt=8.

## How to use

1. import XYAlertViewHeader.h in your prefix file.
2. invoke XYShowAlert(@"Hello!") anywhere in your code to popup the alert view.

## Cases
- completely way to create a customized alert view with block.

<img src="http://media3.doudouy.com/users/251/userPhoto/origin/1343356324907.jpg"/>

```ObjectiveC
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
```

- show a loading view and dismiss after 5 seconds

<img src="http://media3.doudouy.com/users/251/userPhoto/origin/1343356312864.jpg"/>

```ObjectiveC
// create a loading view and show up
XYLoadingView *loadingView = [XYLoadingView loadingViewWithMessage:@"Loading will complete in 5 seconds..."];
[loadingView show];

// different way to show a loading view
// XYLoadingView *loadingView = XYShowLoading(@"Loading will complete in 5 seconds...");

// dismiss loading view with popup message after 5 seconds
[loadingView performSelector:@selector(dismissWithMessage:) withObject:@"The message comes out once loading view gone." afterDelay:5];
```

- also you can popup more than one alert view in single call, them will come out one by one without any missing

<img src="http://media3.doudouy.com/users/251/userPhoto/origin/1343356280549.jpg"/>

```ObjectiveC
XYShowAlert(@"Hello! This is the first alertView");
XYShowAlert(@"I'm second one.");
XYShowAlert(@"This's the simply way to show an alert!");
```
## Other open source
iOS emoji keyboard view <a href="https://github.com/fly2wind/TSEmojiView">TSEmojiView</a>.

## Contact me

- email: fansyfs@gmail.com
- msn: fansy_fs@hotmail.com