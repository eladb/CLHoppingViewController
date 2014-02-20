//
//  CLSplashViewController.m
//  smvc
//
//  Created by Elad Ben-Israel on 2/20/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import "CLSplashViewController.h"
#import <CLHoppingViewController.h>

@interface CLSplashViewController ()

@property (weak) IBOutlet UIProgressView *progressView;

@property NSInteger currentItem;
@property NSInteger totalItems;
@property (strong) NSTimer *progressTimer;

@end

@implementation CLSplashViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.totalItems = 10;
    self.currentItem = 0;
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(tick:) userInfo:nil repeats:YES];
}

- (void)tick:(id)sender
{
    if (self.currentItem > self.totalItems) {
        [self.progressTimer invalidate];
        [self.hoppingViewController unhop];
    }

    self.progressView.progress = ((CGFloat)self.currentItem / self.totalItems);
    self.currentItem++;
}

@end
