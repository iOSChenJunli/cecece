//
//  SQLManager.h
//  SQLITE
//
//  Created by YideNet on 16/6/13.
//  Copyright © 2016年 CJL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "StudentModel.h"
@interface SQLManager : NSObject
{
    sqlite3 *db;
}
+ (SQLManager *)shareManager;
- (NSMutableArray *)searchWithStudent: (StudentModel *)model;

- (int)insert:( StudentModel *)model;

- (int)remove:( StudentModel *)model;
//查询表中所有内容
- (NSMutableArray *)searchDb;

//修改
- (int)reviseModel: (StudentModel *)model;
@end
