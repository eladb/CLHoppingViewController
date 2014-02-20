//
//  CLStartupViewController.m
//  smvc
//
//  Created by Elad Ben-Israel on 2/20/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import "CLStartupViewController.h"

@implementation CLStartupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self hopTo:@"splash" then:^{
        [self hopTo:@"onboarding" then:^{
            [self hopTo:@"signup_login" then:^{
                [self hopTo:@"main" then:nil];
            }];
        }];
    }];
}

@end