//
//  JSMenuViewDemoViewController.m
//  JSSideSlipMenuDemo
//
//  Created by drision on 2017/1/17.
//  Copyright © 2017年 drision. All rights reserved.
//

#import "JSMenuViewDemoViewController.h"

@interface JSMenuViewDemoViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, copy) NSArray *titleArray;

@end

@implementation JSMenuViewDemoViewController

- (void)viewDidLoad {
    
    self.leftWidth = self.tableView.bounds.size.width;
    self.titleArray = @[@"第一页", @"第二页", @"第三页"];
    [self addChildViewControllers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private
- (UIViewController *)viewControllerFromStoryBoardWithIDF:(NSString *)idf {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:idf];
}

- (void)addChildViewControllers {
    NSMutableArray *array = [NSMutableArray array];
    UIViewController *firstVC  = [self viewControllerFromStoryBoardWithIDF:@"firstViewController"];
    [array addObject:firstVC];
    UIViewController *secondVC  = [self viewControllerFromStoryBoardWithIDF:@"secondViewController"];
    [array addObject:secondVC];
    UIViewController *thirdVC  = [self viewControllerFromStoryBoardWithIDF:@"thirdViewController"];
    [array addObject:thirdVC];
    self.viewControllers = array;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = self.titleArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self changeVCWithIndex:indexPath.row];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
