//
//  MSPrefilledTableController.m
//  pager
//
//  Created by Nick Savula on 10/3/16.
//  Copyright © 2016 Nick Savula. All rights reserved.
//

#import "MSPrefilledTableController.h"

@interface MSPrefilledTableController ()

@end

@implementation MSPrefilledTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arc4random_uniform(20);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextCellIdentifier"];
    cell.textLabel.text = [NSString stringWithFormat:@"Row: %ld", (long)indexPath.row];
    return cell;
}

@end
