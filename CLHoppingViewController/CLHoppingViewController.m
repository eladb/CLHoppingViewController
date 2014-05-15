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
    NSAssert(self.storyboard, @"Storyboard is required. Use `hopToViewController:then:` instead");
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:storyboardIdentifier];
    [self hopToViewController:vc then:block];
}

- (void)hopTo:(NSString *)storyboardIdentifier thenTo:(NSString *)nextStoryboardIdentifier
{
    [self hopTo:storyboardIdentifier then:^{
        [self hopTo:nextStoryboardIdentifier then:nil];
    }];
}

- (void)hopToViewController:(UIViewController *)newViewController then:(void(^)(void))block
{
    self.nextBlock = block;

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
        }];
    }
    else {
        newViewController.view.alpha = 1.0f;
        [self.view addSubview:newViewController.view];
        [newViewController didMoveToParentViewController:self];
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
#pragma mark - Propogate status bar events to topmost child view controller

- (UIViewController *)childViewControllerForStatusBarStyle
{
    if (self.childViewControllers.count == 0) {
        return [super childViewControllerForStatusBarStyle];
    }
    
    return self.childViewControllers[self.childViewControllers.count - 1];
}

- (UIViewController *)childViewControllerForStatusBarHidden
{
    if (self.childViewControllers.count == 0) {
        return [super childViewControllerForStatusBarStyle];
    }
    
    return self.childViewControllers[self.childViewControllers.count - 1];
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