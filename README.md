# CLHoppingViewController

[![Version](http://cocoapod-badges.herokuapp.com/v/CLHoppingViewController/badge.png)](http://cocoadocs.org/docsets/CLHoppingViewController)
[![Platform](http://cocoapod-badges.herokuapp.com/p/CLHoppingViewController/badge.png)](http://cocoadocs.org/docsets/CLHoppingViewController)

A block-based [custom container view controller](https://developer.apple.com/library/ios/featuredarticles/ViewControllerPGforiPhoneOS/CreatingCustomContainerViewControllers/CreatingCustomContainerViewControllers.html) designed for app startup, login and onboarding scenarios.

## Motivation

A common problem we keep running into is how to handle an app's start up flow. The standard container view controllers (such as `UINavigationController` and `UITabBarController`) do not provide a good solution for handling the conditional flows related to app start up.

Here's a typical flow for an app start up sequence:

 1. Show some beautiful splash screen while reloading cached state (or maybe refreshing from network).
 2. If this is the user's first time, show the onboarding UX.
 3. If there's no stored user session, show the sign-up/login UX.
 4. Go to the main app flow (usually some `UINavigationController` within a storyboard).

A common solution to this is to embed some conditional/one-off logic inside the various UIViewControllers involved in the flow and use a `UINavigationController` to push/pop the desired UX elements based on these conditionals. Another way to approach this is to use modal controllers, or even replace the `rootViewController` of the key window. All of these approaches result is a spaghetti solution with the actual logic of the startup sequence distributed across multiple source files, hard-to-control transitions and annoying bugs.

### Enters CLHoppingViewController ###

The idea behind this [custom container]([custom container view controller](https://developer.apple.com/library/ios/featuredarticles/ViewControllerPGforiPhoneOS/CreatingCustomContainerViewControllers/CreatingCustomContainerViewControllers.html)) is that each UX element of the flow is self-contained and decoupled from the other parts of the flow. It only reports when it had finished using the `unhop` method and yields the flow control back to the parent view controller.

So, for example. We can create a subclass `CLHoppingViewController` that "hops" to the splash screen. Then, when the splash screen calls `unhop`, it hops to the onboarding UX (if this is the first use) or to the log-in/sign-up UX if there's no saved session, etc, etc.

## Installation

CLHoppingViewController is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod "CLHoppingViewController"

## API

### Hop to Another View Controller

```objc
- (void)hopToViewController:(UIViewController *)newViewController then:(void(^)(void))block;
```

Immediately transitions to the specified view controller (cross-fade). When `unhop` will be called `block` will be invoked. If `block` is `nil`, nothing will happen.

### Unhop Back to the `then` Block

```objc
- (void)unhop;
```

Causes the `then` block defined in the last `hopToViewController:then:` to be invoked.

Usually, this is called from a child view controller by accessing the parent hopping view controller like this:

```objc
#import <CLHoppingViewController.h>

- (void)readyToHopBack
{
  [self.hoppingViewController unhop];
}
```

### Custom Transitions

CLHoppingViewController supports custom transition via a block that may be passed to the various hopping functions.

```objc
- (void)hopToViewController:(UIViewController *)newViewController
                 transition:(CLHoppingViewControllerTransitionBlock)transition
                       then:(void(^)(void))block;
```

This will invoke the `transition` block during the hop. The transition block has the following signature:

```objc
typedef void(^CLHoppingViewControllerTransitionBlock)(UIViewController *fromViewController, UIViewController *toViewController, void(^completion)(BOOL finished));
```

 - __fromViewController__: The source UIViewController
 - __toViewController__: The destination UIViewController
 - __completion__: A block that __must__ be called when the transition is finished

NOTE: `toViewController.view` will be inserted to the view hierarchy of the container (`containerViewForChildViewController`) before the transition is started, so no need to add it manually.

### Custom Container View

By default, `CLHoppingViewController` will add the destination view controller's view as a child of `[self view]`. If you wish to change this, override `[CLHoppingViewController containerViewForChildViewController]` and return any view you wish to use a container for the child view controllers.

## Author

Elad Ben-Israel, elad.benisrael@gmail.com

## License

CLHoppingViewController is available under the MIT license. See the LICENSE file for more info.
