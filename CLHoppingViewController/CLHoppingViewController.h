//
//  CLHoppingViewController.h
//
//  Created by Elad Ben-Israel on 2/20/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CLHoppingViewControllerTransitionBlock)(UIViewController *fromViewController, UIViewController *toViewController, void(^completion)(BOOL finished));

@interface CLHoppingViewController : UIViewController

@property (readonly, nonatomic) UIViewController *currentChildViewController;

// immediately transitions to the specified view controller (cross-fade). When `unhop` will be called `block` will be invoked. If `block` is `nil`, nothing will happen.
// the version that accepts a transition block can use it to customize any transitional behavior
- (void)hopToViewController:(UIViewController *)newViewController then:(void(^)(void))block;
- (void)hopToViewController:(UIViewController *)newViewController transition:(CLHoppingViewControllerTransitionBlock)transition then:(void(^)(void))block;

// hopping with storyboard identifiers instead of view controllers
- (void)hopTo:(NSString *)storyboardIdentifier then:(void(^)(void))block;
- (void)hopTo:(NSString *)storyboardIdentifier thenTo:(NSString *)nextStoryboardIdentifier;
- (void)hopTo:(NSString *)storyboardIdentifier transition:(CLHoppingViewControllerTransitionBlock)transition then:(void(^)(void))block;

// causes the `then` block defined in the last `hopToViewController:then:` to be invoked.
// usually, this is called from a child view controller by accessing the parent hopping view controller like this:
// [self.hoppingViewController unhop];
- (void)unhop;

// iverride to allow customizing the container. The container view is not inserted
// into the view hierarchy (it's the responsibility of the user).
- (UIView *)containerViewForChildViewController; // default is `[self view]`

// default custom transitions (override to replace all transitions)
- (void)animatedTransitionFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController completion:(void(^)(BOOL finished))completion;

@end

@interface UIViewController (Hopping)

/**
 * Returns the parent CLHoppingViewController, if any. Otherwise, returns `nil`.
 */
- (CLHoppingViewController *)hoppingViewController;

@end