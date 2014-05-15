//
//  CLStartupViewController.m
//  smvc
//
//  Created by Elad Ben-Israel on 2/20/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import "CLStartupViewController.h"
#import "CLLoginSignupViewController.h"

@implementation CLStartupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self hopTo:@"splash" then:^{
        [self hopTo:@"onboarding" then:^{
            [self hopTo:@"signup_login" transition:^(UIViewController *fromViewController, UIViewController *toViewController, void (^completion)(BOOL finished)) {
                toViewController.view.center = CGPointMake(self.containerViewForChildViewController.bounds.size.width, self.containerViewForChildViewController.bounds.size.height);
                toViewController.view.transform = CGAffineTransformMakeScale(0.0, 0.0);
                [UIView animateWithDuration:0.25f animations:^{
                    fromViewController.view.center = CGPointMake(0, 0);
                    fromViewController.view.transform = CGAffineTransformMakeScale(0.0, 0.0);
                    toViewController.view.center = self.containerViewForChildViewController.center;
                    toViewController.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
                } completion:completion];
            } then:^{
                [self hopTo:@"main" then:nil];
            }];
        }];
    }];
}

@end