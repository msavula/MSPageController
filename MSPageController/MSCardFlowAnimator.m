//
//  MSCardFlowAnimator.m
//  pager
//
//  Created by Nick Savula on 10/24/16.
//  Copyright © 2016 Nick Savula. All rights reserved.
//

#import "MSCardFlowAnimator.h"

@implementation MSCardFlowAnimator

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
    
    // from layer
    transform = CATransform3DIdentity;
    transform = CATransform3DTranslate(transform, (forward ? -width : width) * (forward ? (1 - percent) : percent), 0, 0);
    fromViewController.view.layer.transform = transform;
    
    // to layer
    // scale from 0.9 to 1
    toViewController.view.layer.transform = CATransform3DMakeScale(0.9 + 0.1 * (forward ? (1 - percent) : percent), 0.9 + 0.1 * (forward ? (1 - percent) : percent), 1);
}

@end
