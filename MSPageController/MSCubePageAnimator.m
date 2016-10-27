//
//  MSCubePageAnimator.m
//  pager
//
//  Created by Nick Savula on 10/3/16.
//  Copyright © 2016 Nick Savula. All rights reserved.
//

#import "MSCubePageAnimator.h"

@implementation MSCubePageAnimator

- (void)transitFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController precentage:(CGFloat)percent forward:(BOOL)forward {
    if (fromViewController == toViewController || toViewController == nil) {
        return;
    }
    
    if (percent > 1.f || percent < 0.f) {
        return;
    }
    
    // defaults
    CGFloat halfWidth = fromViewController.view.bounds.size.width / 2.0 / 0.727;
    CGFloat perspective = -1.0/1000.0;
    CGFloat initialTransform;
    CGFloat finalTransform;
    CATransform3D transform = CATransform3DIdentity;
    
    CGFloat multiplier = 1 - fabs(0.5 - percent) * 2;
    multiplier = sin(M_PI_2 * multiplier);
    
    
    // from layer
    initialTransform = forward ? -M_PI_2 * 0.8 : M_PI_2 * 0.8;
    
    // adjust to direction
    if (forward) {
        finalTransform = initialTransform * (1 - percent);
    } else {
        finalTransform = initialTransform * percent;
    }
    
    // transformation
    transform = CATransform3DIdentity;
    transform.m34 = perspective;
    transform = CATransform3DTranslate(transform, 0, 0, -halfWidth - 70 * multiplier);
    transform = CATransform3DRotate(transform, finalTransform, 0, 1, 0);
    transform = CATransform3DTranslate(transform, 0, 0, halfWidth);
    
    fromViewController.view.layer.transform = transform;
    
    
    // to layer
    initialTransform = forward ? M_PI_2 * 0.8 : -M_PI_2 * 0.8;
    
    // adjust to direction
    if (forward) {
        finalTransform = initialTransform * percent;
    } else {
        finalTransform = initialTransform - (initialTransform * percent);
    }
    
    // transformation
    transform = CATransform3DIdentity;
    transform.m34 = perspective;
    transform = CATransform3DTranslate(transform, 0, 0, -halfWidth - 70 * multiplier);
    transform = CATransform3DRotate(transform, finalTransform, 0, 1, 0);
    transform = CATransform3DTranslate(transform, 0, 0, halfWidth);
    
    toViewController.view.layer.transform = transform;
}

@end
