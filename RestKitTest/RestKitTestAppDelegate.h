//
//  RestKitTestAppDelegate.h
//  RestKitTest
//
//  Created by vb on 10/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RestKitTestViewController;

@interface RestKitTestAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet RestKitTestViewController *viewController;

@end
