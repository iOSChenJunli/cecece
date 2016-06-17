//
//  HomeTableVC.m
//  SQLITE
//
//  Created by YideNet on 16/6/13.
//  Copyright © 2016年 CJL. All rights reserved.
//

#import "HomeTableVC.h"
#import "SQLManager.h"
#import "AddVC.h"
@interface HomeTableVC ()
@property (nonatomic, strong) NSMutableArray *studentArray;//数据源 - 模型

@end

@implementation HomeTableVC
#define HomeCellIdentifier (@"StudentCell")
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
//    StudentModel *model = [[StudentModel alloc] init];
//    model.idNum = @"100";
//    StudentModel *result = [[SQLManager shareManager]searchWithIdNum:model];
//    if (result) {
//        [_studentArray addObject:result];
//        [self.tableView reloadData];
//    }
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"IsSearchOperation"]) {
       [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"IsSearchOperation"];
    }else{
       _studentArray = [[SQLManager shareManager]searchDb];
    }
    [self.tableView reloadData];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
     _studentArray = [[NSMutableArray alloc]init];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"IsSearchOperation"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _studentArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HomeCellIdentifier forIndexPath:indexPath];
    if (self.studentArray.count>0) {
        StudentModel * model = _studentArray[indexPath.row];
        cell.textLabel.text = model.idNum;
        cell.detailTextLabel.text = model.name;
    }
    return cell;
}
- (IBAction)editBtnClick:(id)sender {
    AddVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddVC"];
    [vc setReverseValue:^(NSMutableArray *arr) {
        _studentArray = arr;
    }];
    [self.navigationController pushViewController:vc animated:YES];
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
