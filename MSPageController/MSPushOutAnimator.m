//
//  MSPushOutAnimator.m
//  pager
//
//  Created by Nick Savula on 10/27/16.
//  Copyright © 2016 Nick Savula. All rights reserved.
//

#import "MSPushOutAnimator.h"

@implementation MSPushOutAnimator

- (void)transitFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController precentage:(CGFloat)percent forward:(BOOL)forward {
    if (fromViewController == toViewController || toViewController == nil) {
        return;
    }
    
    if (percent > 1.f || percent < 0.f) {
        return;
    }
    
    // defaults
    CGFloat width = fromViewController.view.bounds.size.width;
    CATransform3D transform = CATransform3DIdentity;
    CGFloat multiplier = 1 - fabs(0.5 - percent) * 2;
    multiplier = sin(M_PI_2 * multiplier);
    
    // rotate from 0 to 90
    transform = CATransform3DIdentity;
    transform.m34 = 1 / - 500.f;
    transform = CATransform3DTranslate(transform, (forward ? -width : width) * (forward ? (1 - percent) : percent), 0, -width / 2.f - 80 * multiplier);
    transform = CATransform3DRotate(transform, (forward ? M_PI_2 : -M_PI_2) * (forward ? (1 - percent) : percent), 0, 1, 0);
    transform = CATransform3DTranslate(transform, 0, 0, width / 2.f);
    fromViewController.view.layer.transform = transform;
    
    // to layer
    // push
    transform = CATransform3DIdentity;
    transform = CATransform3DTranslate(transform, (forward ? -width : width) * (forward ? (1 - percent) : percent) + (forward ? width : -width), 0, 0);
    toViewController.view.layer.transform = transform;
}

@end
