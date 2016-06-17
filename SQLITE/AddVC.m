//
//  AddVC.m
//  SQLITE
//
//  Created by YideNet on 16/6/13.
//  Copyright © 2016年 CJL. All rights reserved.
//

#import "AddVC.h"
#import "SQLManager.h"
#import "StudentModel.h"
@interface AddVC ()
@property (weak, nonatomic) IBOutlet UITextField *idNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@end

@implementation AddVC

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (IBAction)completeBtnClick:(id)sender {
    if ([self.idNumTextField.text isEqualToString:@""]&&[self.nameTextField.text isEqualToString:@""]) {
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
    //写入数据库
    StudentModel *model =  [[StudentModel alloc]init];
    model.idNum = self.idNumTextField.text;
    model.name = self.nameTextField.text;
    
    
    switch (((UIButton *)sender).tag) {
        case 100:
            //添加
            [[SQLManager shareManager] insert:model];
            break;
        case 101:
           //删除
            [[SQLManager shareManager] remove:model];
            break;
        case 102:
           //查询
            _reverseValue([[SQLManager shareManager] searchWithStudent:model]);
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"IsSearchOperation"];
            break;
        default:
           //修改
            [[SQLManager shareManager]reviseModel:model];
            break;
    }
    
}


@end
