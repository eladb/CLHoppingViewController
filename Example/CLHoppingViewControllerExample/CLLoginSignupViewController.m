//
//  CLLoginSignupViewController.m
//  CLHoppingViewControllerExample
//
//  Created by Elad Ben-Israel on 2/20/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import "CLLoginSignupViewController.h"
#import <CLHoppingViewController.h>

@implementation CLLoginSignupViewController

- (IBAction)login:(id)sender
{
    [self.hoppingViewController unhop];
}

@end
