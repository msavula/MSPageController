//
//  MSPageController.m
//
//  Created by Nick Savula on 10/3/16.
//  Copyright © 2016 Nick Savula. All rights reserved.
//

#import "MSPageController.h"

typedef NS_ENUM(NSUInteger, MSPageSwitchDirection) {
    MSPageSwitchDirectionForward,
    MSPageSwitchDirectionBackward
};

@interface MSPageController ()

@property (nonatomic, strong) __kindof UIViewController *currentController;
@property (nonatomic, assign) MSPageSwitchDirection direction;


@property (nonatomic, strong) __kindof UIViewController *toViewController;
@property (nonatomic, strong) CATransformLayer *transformLayer;

// remember where we started to pan
@property (nonatomic, assign) CGPoint panStartLocation;

// basic CADisplayLink properties
@property (nonatomic, assign) CGFloat startLocationX;
@property (nonatomic, strong) CADisplayLink  *displayLink;
@property (nonatomic, assign) CFTimeInterval  startTime;
@property (nonatomic, assign) BOOL fallingBack;

// display link state properties
@property (nonatomic, assign) CFTimeInterval  remainingAnimationDuration;

@end

@implementation MSPageController

#pragma mark - initializers

- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self != nil) {
        [self setupDefaults];
    }
    
    return self;
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self != nil) {
        [self setupDefaults];
    }
    
    return self;
}

- (void)setupDefaults {
    self.animationDuration = 0.5;
    
    self.pageAnimator = [[MSPageAnimator alloc] init];
}

#pragma mark - controller lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.view addGestureRecognizer:pan];
    
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - public

- (__kindof UIViewController *)displayedController {
    return self.currentController;
}

- (void)displayViewController:(UIViewController *)viewController {
    for (UIViewController *controller in self.childViewControllers) {
        [controller.view removeFromSuperview];
        [controller removeFromParentViewController];
    }
    
    [viewController willMoveToParentViewController:self];
    [self addChildViewController:viewController];
    
    viewController.view.frame = self.view.bounds;
    viewController.view.autoresizingMask = self.view.autoresizingMask;
    [self.view addSubview: viewController.view];
    
    self.currentController = viewController;
}

#pragma mark - Action Handlers

- (void)handlePan:(UIPanGestureRecognizer*)gesture
{
    CGPoint translation = [gesture translationInView:gesture.view];
    CGPoint location = [gesture locationInView:gesture.view];
    double percentageOfWidth;
    
    if (gesture.state == UIGestureRecognizerStateBegan || gesture.state == UIGestureRecognizerStateChanged) {
        if (self.toViewController == nil) {
            // if moved left
            if (translation.x < 0) {
                self.toViewController = [self.dataSource pageController:self viewControllerAfterViewController:self.currentController];
                self.direction = MSPageSwitchDirectionForward;
            } else {
                self.toViewController = [self.dataSource pageController:self viewControllerBeforeViewController:self.currentController];
                self.direction = MSPageSwitchDirectionBackward;
            }
            
            if (self.toViewController == nil) {
                return;
            }
            
            self.transformLayer = [[CATransformLayer alloc] init];
            self.transformLayer.frame = self.view.layer.bounds;
            
            self.toViewController.view.frame = self.view.bounds;
            
            [self.currentController willMoveToParentViewController:nil];
            [self.currentController.view removeFromSuperview];
            [self.currentController removeFromParentViewController];
            
            [self.transformLayer addSublayer:self.toViewController.view.layer];
            [self.transformLayer addSublayer:self.currentController.view.layer];
            [self.view.layer addSublayer:self.transformLayer];
            
            self.panStartLocation = location;
        }
        
        if (self.direction == MSPageSwitchDirectionForward) {
            percentageOfWidth = (location.x + (self.view.bounds.size.width - self.panStartLocation.x)) / self.view.frame.size.width;
        } else {
            percentageOfWidth = (location.x - self.panStartLocation.x) / self.view.frame.size.width;
        }
        
        self.view.userInteractionEnabled = NO;
        [self.pageAnimator transitFromViewController:self.currentController toViewController:self.toViewController precentage:percentageOfWidth forward:self.direction == MSPageSwitchDirectionForward];
    }
    
    if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
        if (self.direction == MSPageSwitchDirectionForward) {
            self.startLocationX = location.x + (self.view.bounds.size.width - self.panStartLocation.x);
        } else {
            self.startLocationX = location.x - self.panStartLocation.x;
        }
        
        [self startDisplayLink];
    }
}

#pragma mark - CADisplayLink

- (void)startDisplayLink {
    if (self.toViewController == nil) {
        return;
    }
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleDisplayLink:)];
    self.startTime = CACurrentMediaTime();
    
    CGFloat percentageOfWidth;
    if (self.direction == MSPageSwitchDirectionForward) {
        percentageOfWidth = 1.f - (self.startLocationX / self.view.frame.size.width);
    } else {
        percentageOfWidth = self.startLocationX / self.view.frame.size.width;
    }
    
    // TODO: take velocity into consideration, fall back when velocity cancels out current possition
    if (percentageOfWidth <= 0.15f) {
        // fall back
        UIViewController *viewController = self.currentController;
        self.currentController = self.toViewController;
        self.toViewController = viewController;
        
        if (self.direction == MSPageSwitchDirectionForward) {
            self.direction = MSPageSwitchDirectionBackward;
        } else {
            self.direction = MSPageSwitchDirectionForward;
        }
        
        percentageOfWidth = 1 - percentageOfWidth;
        self.fallingBack = YES;
    }
    
    self.remainingAnimationDuration = (1 - percentageOfWidth) * self.animationDuration;
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)stopDisplayLink {
    [self.displayLink invalidate];
    self.displayLink = nil;
}

- (void)handleDisplayLink:(CADisplayLink *)displayLink {
    CFTimeInterval elapsed = CACurrentMediaTime() - self.startTime;
    CGFloat percentComplete = (elapsed / self.remainingAnimationDuration);
    
    if (percentComplete >= 0.0 && percentComplete < 1.0) {
        CGFloat destinationX;
        CGFloat percentageOfWidth;
        if (self.direction == MSPageSwitchDirectionForward) {
            destinationX = self.startLocationX - (self.startLocationX * percentComplete);
            percentageOfWidth = destinationX / self.view.frame.size.width;
        } else {
            destinationX = self.startLocationX + ((self.view.bounds.size.width - self.startLocationX) * percentComplete);
            percentageOfWidth = destinationX / self.view.frame.size.width;
        }
        
        [self.pageAnimator transitFromViewController:self.currentController toViewController:self.toViewController precentage:percentageOfWidth forward:self.direction == MSPageSwitchDirectionForward];
    } else {
        // we are done
        [self stopDisplayLink];
        
        [self.toViewController.view.layer removeFromSuperlayer];
        self.toViewController.view.layer.transform = CATransform3DIdentity;
        [self.currentController.view.layer removeFromSuperlayer];
        self.currentController.view.layer.transform = CATransform3DIdentity;
        
        // adding new page
        [self addChildViewController:self.toViewController];
        [self.view addSubview:self.toViewController.view];
        
        [self.transformLayer removeFromSuperlayer];
        
        self.currentController = self.toViewController;
        
        if (!self.fallingBack) {
            if ([self.delegate respondsToSelector:@selector(pageController:didDisplayController:)]) {
                [self.delegate pageController:self didDisplayController:self.toViewController];
            }
        }
        
        self.fallingBack = NO;
        
        self.toViewController = nil;
        self.view.userInteractionEnabled = YES;
    }
}

@end
