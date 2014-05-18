//
//  CLOnboardingViewController.m
//  smvc
//
//  Created by Elad Ben-Israel on 2/20/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import "CLOnboardingViewController.h"
#import <CLHoppingViewController.h>

@implementation CLOnboardingViewController

- (IBAction)next:(id)sender
{
    @try {
        [self performSegueWithIdentifier:@"next" sender:nil];
    }
    @catch (NSException *exception) {
        [self.hoppingViewController unhop];
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
