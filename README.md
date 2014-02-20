# CLHoppingViewController

[![Version](http://cocoapod-badges.herokuapp.com/v/CLHoppingViewController/badge.png)](http://cocoadocs.org/docsets/CLHoppingViewController)
[![Platform](http://cocoapod-badges.herokuapp.com/p/CLHoppingViewController/badge.png)](http://cocoadocs.org/docsets/CLHoppingViewController)

A block-based navigational UIViewController designed for app startup, login and onboarding scenarios.

## Installation

CLHoppingViewController is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod "CLHoppingViewController"

## Usage

__CLHoppingViewController__ is a container UIViewController. It manages the lifetime
of child view controllers. The root __CLHoppingViewController__ uses the `hopToViewController:then:` method to hop to another view controller. When the child controller invokes the `[self.hoppingViewController unhop]` method, the `then` block is invoked.

## Example

The example app that shows the usage of `CLHoppingViewController` for a start-up scenario with a splash screen, onboarding scenario and a login.

```objective-c
[self hopTo:@"splash" then:^{
  [self hopTo:@"onboarding" then:^{
    [self hopTo:@"signup_login" then:^{
      [self hopTo:@"main" then:nil];
    }];
  }];
}];
```

## Author

Elad Ben-Israel, elad.benisrael@gmail.com

## License

CLBlockObservation is available under the MIT license. See the LICENSE file for more info.