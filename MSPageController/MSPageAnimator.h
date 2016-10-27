//
//  MSPageAnimator.h
//  pager
//
//  Created by Nick Savula on 10/3/16.
//  Copyright © 2016 Nick Savula. All rights reserved.
//

@import Foundation;
@import UIKit;

@interface MSPageAnimator : NSObject

- (void)transitFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController precentage:(CGFloat)percent forward:(BOOL)forward;

@end
