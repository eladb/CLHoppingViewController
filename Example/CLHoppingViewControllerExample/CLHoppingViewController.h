//
//  CLHoppingViewController.h
//
//  Created by Elad Ben-Israel on 2/20/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLHoppingViewController : UIViewController

- (void)hopTo:(NSString *)storyboardIdentifier then:(void(^)(void))block;
- (void)hopToViewController:(UIViewController *)newViewController then:(void(^)(void))block;
- (void)unhop;

@end

@interface UIViewController (Hopping)

- (CLHoppingViewController *)hoppingViewController;

@end