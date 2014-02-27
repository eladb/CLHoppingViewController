//
//  CLHoppingViewController.h
//
//  Created by Elad Ben-Israel on 2/20/14.
//  Copyright (c) 2014 Citylifeapps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLHoppingViewController : UIViewController

/**
 * Immediately transitions to the specified view controller (cross-fade). When `unhop` will be called `block` will be invoked. If `block` is `nil`, nothing will happen.
 **/
- (void)hopTo:(NSString *)storyboardIdentifier then:(void(^)(void))block;

/**
 * Causes the `then` block defined in the last `hopToViewController:then:` to be invoked.
 * Usually, this is called from a child view controller by accessing the parent hopping view controller like this:
 * 
 *   [self.hoppingViewController unhop];
 *
 */
- (void)unhop;

/**
 * Same as `hopToViewController:then:` but uses a storyboard identifier to instanciate the child view controller.
 */
- (void)hopTo:(NSString *)storyboardIdentifier thenTo:(NSString *)nextStoryboardIdentifier;

/**
 * Same as `hopTo:then:` but uses a storyboard identifier to specify the next view controller as well.
 */
- (void)hopToViewController:(UIViewController *)newViewController then:(void(^)(void))block;

@end

@interface UIViewController (Hopping)

/**
 * Returns the parent CLHoppingViewController, if any. Otherwise, returns `nil`.
 */
- (CLHoppingViewController *)hoppingViewController;

@end