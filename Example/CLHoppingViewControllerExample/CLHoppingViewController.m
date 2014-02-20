//
//  CLHoppingViewController.m
//
//  Created by Elad Ben-Israel on 2/20/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import "CLHoppingViewController.h"

@interface CLHoppingViewController ()

@property (copy) void(^nextBlock)(void);

@end

@implementation CLHoppingViewController

- (void)hopTo:(NSString *)storyboardIdentifier then:(void(^)(void))block
{
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:storyboardIdentifier];
    [self hopToViewController:vc then:block];
}

- (void)hopToViewController:(UIViewController *)newViewController then:(void(^)(void))block
{
    UIViewController *oldViewController = [self currentChild];
    
    [oldViewController willMoveToParentViewController:nil];
    [self addChildViewController:newViewController];
    newViewController.view.frame = self.view.bounds;
    newViewController.view.alpha = 0.0f;
    
    // if we have an old view controller, transition to new vc with animation
    if (oldViewController) {
        [self transitionFromViewController:oldViewController toViewController:newViewController duration:0.5f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            oldViewController.view.alpha = 0.0f;
            newViewController.view.alpha = 1.0f;
        } completion:^(BOOL finished) {
            [oldViewController removeFromParentViewController];
            [newViewController didMoveToParentViewController:self];
            self.nextBlock = block;
        }];
    }
    else {
        newViewController.view.alpha = 1.0f;
        [self.view addSubview:newViewController.view];
        [newViewController didMoveToParentViewController:self];
        self.nextBlock = block;
    }
}

- (void)unhop
{
    NSAssert(self.nextBlock, @"cannot unhop if there's no next block");
    self.nextBlock();
}

- (UIViewController *)currentChild
{
    if (self.childViewControllers.count == 0) {
        return nil;
    }
    
    UIViewController *child = self.childViewControllers[self.childViewControllers.count - 1];
    return child;
}

@end

@implementation UIViewController (Hopping)

- (CLHoppingViewController *)hoppingViewController
{
    if ([self isKindOfClass:[CLHoppingViewController class]]) {
        return (CLHoppingViewController *)self;
    }
    
    // recursively look for the startup view controller in the view controller hierarchy
    // nil will terminate the recursion as well.
    return self.parentViewController.hoppingViewController;
}

@end