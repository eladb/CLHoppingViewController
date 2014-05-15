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
    [self hopToViewController:newViewController transition:nil then:block];
}

- (void)hopTo:(NSString *)storyboardIdentifier
   transition:(void(^)(UIViewController *fromViewController, UIViewController *toViewController, void(^completion)(BOOL finished)))transition
         then:(void(^)(void))block
{
    [self hopToViewController:[self.storyboard instantiateViewControllerWithIdentifier:storyboardIdentifier] transition:transition then:block];
}

- (void)hopToViewController:(UIViewController *)newViewController transition:(CLHoppingViewControllerTransitionBlock)transition then:(void(^)(void))block;
{
    self.nextBlock = block;
    
    // use default transition if not specified
    if (!transition) {
        transition = ^(UIViewController *fromViewController, UIViewController *toViewController, void(^completion)(BOOL finished)) {
            [self animatedTransitionFromViewController:fromViewController toViewController:toViewController completion:completion];
        };
    }

    UIViewController *oldViewController = self.currentChildViewController;
    [oldViewController willMoveToParentViewController:nil];
    [self addChildViewController:newViewController];
    [[self containerViewForChildViewController] addSubview:newViewController.view]; // this replades the animated transition
    transition(oldViewController, newViewController, ^(BOOL finished) {
        [oldViewController removeFromParentViewController];
        [newViewController didMoveToParentViewController:self];
    });
}

- (void)unhop
{
    NSAssert(self.nextBlock, @"cannot unhop if there's no next block");
    self.nextBlock();
}

- (UIViewController *)currentChildViewController
{
    if (self.childViewControllers.count == 0) {
        return nil;
    }
    
    return self.childViewControllers[self.childViewControllers.count - 1];
}

#pragma mark - Container

- (UIView *)containerViewForChildViewController
{
    return self.view;
}

#pragma mark - Transitions

- (void)animatedTransitionFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController completion:(void(^)(BOOL finished))completion
{
    toViewController.view.frame = self.view.bounds;
    toViewController.view.alpha = 0.0f;
    
    if (fromViewController) {
        [UIView animateWithDuration:0.25f animations:^{
            fromViewController.view.alpha = 0.0f;
            toViewController.view.alpha = 1.0f;
        } completion:completion];
    }
    else {
        toViewController.view.alpha = 1.0f;
        completion(YES);
    }
}

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