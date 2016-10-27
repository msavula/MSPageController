//
//  ViewController.m
//  pager
//
//  Created by Nick Savula on 10/3/16.
//  Copyright © 2016 Nick Savula. All rights reserved.
//

#import "ViewController.h"
#import "MSPageController.h"

#import "MSCubePageAnimator.h"
#import "MSCardFlowAnimator.h"
#import "MSPushOutAnimator.h"

#import "MSPrefilledTableController.h"
#import "MSLabelController.h"

@interface ViewController () <MSPageControllerDataSource, MSPageControllerDelegate>

@property (nonatomic, weak) IBOutlet UISegmentedControl *animationSegment;

- (IBAction)animationSelected:(id)sender;


@property (nonatomic, strong) MSPageController *pageController;
@property (nonatomic, strong) NSArray <UIViewController *> *viewControllers;
@property (nonatomic, assign) NSInteger selectedSegmentIndex;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // build view controllers array
    MSLabelController *firstController = [self.storyboard instantiateViewControllerWithIdentifier:@"MSLabelController"];
    firstController.view.backgroundColor = [UIColor lightGrayColor];
    firstController.titleText = @"First Controller";
    MSLabelController *secondController = [self.storyboard instantiateViewControllerWithIdentifier:@"MSLabelController"];
    secondController.titleText = @"Second Controller";
    secondController.view.backgroundColor = [UIColor darkGrayColor];
    MSPrefilledTableController *thirdController = [self.storyboard instantiateViewControllerWithIdentifier:@"MSPrefilledTableController"];
    MSLabelController *fourthController = [self.storyboard instantiateViewControllerWithIdentifier:@"MSLabelController"];
    fourthController.titleText = @"Fourth Controller";
    fourthController.view.backgroundColor = [UIColor darkGrayColor];
    MSLabelController *fifthController = [self.storyboard instantiateViewControllerWithIdentifier:@"MSLabelController"];
    fifthController.titleText = @"Fifth Controller";
    fifthController.view.backgroundColor = [UIColor lightGrayColor];
    
    self.viewControllers = @[firstController, secondController, thirdController, fourthController, fifthController];
    
    [self.pageController displayViewController:self.viewControllers[0]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"MSPageControllerEmbedSegue"]) {
        self.pageController = (MSPageController*)segue.destinationViewController;
        self.pageController.delegate = self;
        self.pageController.dataSource = self;
        self.pageController.pageAnimator = [[MSCardFlowAnimator alloc] init];
    }
}

#pragma mark - UI Actions

- (IBAction)animationSelected:(id)sender {
    if (self.animationSegment.selectedSegmentIndex == self.selectedSegmentIndex) {
        return;
    }
    
    switch (self.animationSegment.selectedSegmentIndex) {
        case 0:
        {
            self.pageController.pageAnimator = [[MSCardFlowAnimator alloc] init];
            break;
        }
        case 1:
        {
            self.pageController.pageAnimator = [[MSCubePageAnimator alloc] init];
            break;
        }
        case 2:
        default:
        {
            self.pageController.pageAnimator = [[MSPushOutAnimator alloc] init];
            break;
        }
    }
    
    self.selectedSegmentIndex = self.animationSegment.selectedSegmentIndex;
}

#pragma mark - Page Controller Data Source

- (__kindof UIViewController *)pageController:(MSPageController *)pageController viewControllerBeforeViewController:(__kindof UIViewController *)viewController {
    NSInteger index = [self.viewControllers  indexOfObject:viewController];
    
    if (index == NSNotFound || index == 0) {
        return nil;
    }
    
    index--;
    
    return self.viewControllers[index];
}

- (__kindof UIViewController *)pageController:(MSPageController *)pageController viewControllerAfterViewController:(__kindof UIViewController *)viewController {
    NSInteger index = [self.viewControllers  indexOfObject:viewController];
    
    if (index == NSNotFound || index == self.viewControllers.count - 1) {
        return nil;
    }
    
    ++ index;
    
    return self.viewControllers[index];
}

#pragma mark - Page Controller Delegate

- (void)pageController:(MSPageController *)pageController didDisplayController:(__kindof UIViewController *)viewController {
    
}

@end
