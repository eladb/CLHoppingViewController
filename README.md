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

A common solution to this is to embed some conditional/one-off logic inside the various UIViewControllers involved in the flow and use a `UINavigationController` to push/pop the desired UX elements based on these conditionals. Another way to appraoch this is to use modal controllers, or even replace the `rootViewController` of the key window. All of these approaches result is a spaghetti solution with the actual logic of the startup sequence distributed across multiple source files, hard-to-control transitions and annoying bugs.

Enters `CLHoppingViewController`.

The idea behind this [custom container]([custom container view controller](https://developer.apple.com/library/ios/featuredarticles/ViewControllerPGforiPhoneOS/CreatingCustomContainerViewControllers/CreatingCustomContainerViewControllers.html)) is that each UX element of the flow is self-contained and decoupled from the other parts of the flow. It only reports when it had finished using the `unhop` method and yields the flow control back to the parent view controller.

So, for example. We can create a `CLHoppingViewController` that "hops" to the splash screen. Then, when the splash screen calls `unhop`, it hops to the onboarding UX (if this is the first use) or to the log-in/sign-up UX if there's no saved session, etc, etc.

## Installation

CLHoppingViewController is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod "CLHoppingViewController"

## API

### Hop

```objective-c
- (void)hopToViewController:(UIViewController *)newViewController then:(void(^)(void))block;
```

Immediately transitions to the specified view controller (cross-fade). When `unhop` will be called `block` will be invoked. If `block` is `nil`, nothing will happen.

### Unhop

```objective-c
- (void)unhop;
```

Causes the `then` block defined in the last `hopToViewController:then:` to be invoked. 

Usually, this is called from a child view controller by accessing the parent hopping view controller like this:

```
[self.hoppingViewController unhop];
```

### Hop using Storyboard

```objective-c
- (void)hopTo:(NSString *)storyboardIdentifier then:(void(^)(void))block;
```

Same as `hopToViewController:then:` but uses a storyboard identifier to instanciate the child view controller.

```objective-c
- (void)hopTo:(NSString *)storyboardIdentifier thenTo:(NSString *)nextStoryboardIdentifier;
```

Same as `hopTo:then:` but uses a storyboard identifier to specify the next view controller as well.

### Access parent hopping view controller

When including `CLHoppingViewController.h`, you also include a `UIViewController` category that facilitates
access to the parent hopping view controller (if any).

```objective-c
@interface UIViewController (HoppingViewController)

- (CLHoppingViewController *)hoppingViewController;

@end
```

## Tutorial

This section describes the recommended usage "receipe" for `CLHoppingViewController` by example. We will create a simple start up flow that consists of a splash UX and a one-off onboarding UX.

#### Create the app and install CLHoppingViewController

 1. Create a single view app in Xcode.
 1. Install `CLHoppingViewController` as described above.

#### Create the various startup view controllers

 1. Create a new subclass of `CLHoppingViewController` named `MyStartupViewController`.
 1. Create a new subclass of `UIViewController` named `MySplashViewController`.
 1. Create a new subclass of `UIViewController` named `MyOnboardingViewController`.

#### Lay out the storyboard

In the main storyboard:

  1. Add a `UIViewController` with custom class `MyStartupViewController`. Make it the initial view controller of the app.
  1. Add a `UIViewcontroller` with custom class `MySplashViewController`. Set it's storyboard identifier to `splash`.
  1. Add a `UIViewController` with custom class `MyOnboardingViewController`. Set it's storyboard identifier to `onboarding`.
  1. Add a `UINavigationController` with a storyboard identifier of `main`.

Note that there are not segues connecting the various view controllers. Each element of the start-up flow is
self-contained and decoupled from other elements by design.

#### Implement MySplashViewController and MyOnboardingViewController and finish with `unhop`

These are the decoupled UX elements of the start-up flow. Each of them is self-contained and doesn't
know about the others. It has some function and signals that it finished by invoking the `unhop` method
on the parent hopping view controller.

```objective-c

// include a `UIViewController` category to easily access the parent hopping view controller
// from any view controller using `self.hoppingViewController` (similarily to `navigationController` method).
// If there's no hopping view controller parent, it no-ops.
#include <CLHoppingViewController.h>

@implementation MySplashViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self startActivityIndicator];
  [self loadStuffWithCompletion:^{
    // now that we are done, we want to signal the hopping view controller
    [self.hoppingViewController unhop];
  }];
}

@end

@implementation MyOnboardingViewController

// called when user hits the 'i am done with onboarding' button
- (IBAction)onboardingFinished:(id)sender
{
  [self.hoppingViewController unhop];
}

@end
```

#### Implement the start up sequence in `MyStartupViewController`

The start up sequence is essentially self-contained within the `viewDidLoad` method of the start-up view controller. The flow describes which view controllers to hop to (by means of storyboard identifiers) and then describes where to go when this hop is finished.

```objective-c

@implementation MyStartupViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

  [self hopTo:@"splash" then:^{
    [self conditionalHopToOnboarding:^{
      [self hopTo:@"main" then:nil];
    }];
  }];
}

- (void)conditionalHopToOnboarding:(void(^)(void))next
{
  if (/* first_use? */) {
    [self hopTo:@"onboarding" then:next];
  }
  else {
    next();
  }
}

@end
```

This is it. When the app will start, `MyStartupViewController` will be loaded and will initially
hop to the splash view controller. When the splash finishes, it calls `unhop` and the hopping view controller
calls the `next` block which transitions (cross-fade) to the onboarding view controller (conditionally). When this is done, the main app view controller is loaded.

## Author

Elad Ben-Israel, elad.benisrael@gmail.com

## License

CLBlockObservation is available under the MIT license. See the LICENSE file for more info.