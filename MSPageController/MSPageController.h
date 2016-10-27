//
//  MSPageController.h
//
//  Created by Nick Savula on 10/3/16.
//  Copyright © 2016 Nick Savula. All rights reserved.
//

@import UIKit;

#import "MSPageAnimator.h"

@class MSPageController;

typedef NS_ENUM(NSUInteger, MSPageControllerTransition) {
    MSPageControllerTransitionCube
};

@protocol MSPageControllerDataSource <NSObject>

@required
- (__kindof UIViewController *)pageController:(MSPageController *)pageController viewControllerBeforeViewController:(__kindof UIViewController *)viewController;
- (__kindof UIViewController *)pageController:(MSPageController *)pageController viewControllerAfterViewController:(__kindof UIViewController *)viewController;

@end

@protocol MSPageControllerDelegate <NSObject>

@optional
- (void)pageController:(MSPageController *)pageController didDisplayController:(__kindof UIViewController *)viewController;

@end

@interface MSPageController : UIViewController

@property (nonatomic, strong) __kindof MSPageAnimator *pageAnimator;
@property (nonatomic, assign) CGFloat animationDuration;
@property (nonatomic, readonly) __kindof UIViewController *displayedController;

@property (nonatomic, weak) id<MSPageControllerDataSource> dataSource;
@property (nonatomic, weak) id<MSPageControllerDelegate> delegate;


- (void)displayViewController:(__kindof UIViewController *)viewController;

@end
