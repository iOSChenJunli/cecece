//
//  SQLManager.m
//  SQLITE
//
//  Created by YideNet on 16/6/13.
//  Copyright © 2016年 CJL. All rights reserved.
//

#import "SQLManager.h"

@implementation SQLManager
#define kNameFile (@"Student.sqlite")
static SQLManager *manager = nil;
+ (SQLManager *)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc]init];
        [manager createDataBaseTableIfNeeded];
    });
    return manager;
}
-(NSString *)applicationDocumentDirectory{
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:kNameFile];
    
    return filePath;
    
}
- (void)createDataBaseTableIfNeeded {
    NSString *writetablePath = [self applicationDocumentDirectory];
    NSLog(@"数据库的地址 : %@", writetablePath);
    //数据库文件所在的完整路径
    //第二个参数是数据库DataBase对象
    if ( sqlite3_open([writetablePath UTF8String], &db) != SQLITE_OK) {
       //失败
        sqlite3_close(db);
        NSAssert(NO, @"数据库打开失败！");
    }else{
        char *err;
        NSString *createSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS StudentName (idNum TEXT PRIMARY KEY, name TEXT);"];
        /**
         第一个参数 db 对象
         第二个参数 语句
         回调函数 回调函数传递的参数 错误信息
         */
        if (sqlite3_exec(db,[createSQL UTF8String],NULL, NULL, &err) != SQLITE_OK) {
            //失败
            sqlite3_close(db);
            NSAssert(NO, @"建表失败！ %s", err);
        }
        
        sqlite3_close(db);
    }
}
- (NSMutableArray *)searchDb{
    NSMutableArray *studentArray = [[NSMutableArray alloc]init];
    NSString *path = [self applicationDocumentDirectory];
    if (sqlite3_open([path UTF8String],&db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"数据库打开失败！");
    }else{
        NSString *sql = @"SELECT * FROM StudentName ORDER BY idNum";
        sqlite3_stmt *statement;
        if (sqlite3_prepare(db, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
//           if(sqlite3_step(statement) == SQLITE_ROW){
//           }
            while (sqlite3_step(statement) == SQLITE_ROW) {
                char *idNum = (char *)sqlite3_column_text(statement, 0);
                //数据转换
                NSString *idNumStr = [[NSString alloc]initWithUTF8String:idNum];
                
                char *name = (char *)sqlite3_column_text(statement, 1);
                NSString *nameStr = [[NSString alloc]initWithUTF8String:name];
                
                StudentModel *model = [[StudentModel alloc]init];
                model.idNum = idNumStr;
                model.name = nameStr;
                [studentArray addObject:model];
                
            }
            sqlite3_finalize(statement);
            sqlite3_close(db);
        }
    }
    
    return studentArray;
}

//查询
- (NSMutableArray *)searchWithStudent: (StudentModel *)model{
    NSMutableArray *studentArray = [[NSMutableArray alloc]init];
    NSString *path = [self applicationDocumentDirectory];
    if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"打开数据库失败");
    }else{
        NSString *qsql = @"SELECT idNum, name FROM StudentName WHERE idNum = ? OR name = ?";
        sqlite3_stmt *statement;//语句对象
        //第三个参数 执行语句的长度 -1 全部长度
        if(sqlite3_prepare(db, [qsql UTF8String], -1, &statement, NULL) == SQLITE_OK){
         // 按主建查询数据库
            NSString *idNum = model.idNum;
            NSString *name = model.name;
            //参数1.语句对象
            //2.参数开始执行的语句
            //3.我们要绑定的值
            //4.绑定字符串的长度
            //5.指针 NULL
            sqlite3_bind_text(statement, 1, [idNum UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 2, [name UTF8String], -1, NULL);
            //有一个返回值 SQLITE_ROW常量代表查出来了
            while (sqlite3_step(statement) == SQLITE_ROW){
                //提取数据
                //参数1. 语句对象
                //参数2. 字段索引
                char *idNum = (char *)sqlite3_column_text(statement, 0);
                //数据转换
                NSString *idNumStr = [[NSString alloc]initWithUTF8String:idNum];
                
                char *name = (char *)sqlite3_column_text(statement, 1);
                NSString *nameStr = [[NSString alloc]initWithUTF8String:name];
                
                StudentModel *model = [[StudentModel alloc]init];
                model.idNum = idNumStr;
                model.name = nameStr;
                [studentArray addObject:model];
 
            }
            sqlite3_finalize(statement);
            sqlite3_close(db);
            
            return studentArray;
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    return studentArray;
    
}

//插入数据
- (int)insert:( StudentModel *)model{
    NSString * path = [self applicationDocumentDirectory];
    if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"数据库打开失败");
    }else{
        NSString *sql = @"INSERT OR REPLACE INTO StudentName (idNum, name) VALUES (?, ?)";
        sqlite3_stmt *statement;
        if (sqlite3_prepare(db, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_bind_text(statement, 1, [model.idNum UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 2, [model.name UTF8String], -1, NULL);
            if(sqlite3_step(statement) != SQLITE_DONE){
                NSAssert(NO, @"插入数据失败");
            }
            sqlite3_finalize(statement);
            sqlite3_close(db);
            
        }
    }
    return 0;
}

//移除数据
- (int)remove:( StudentModel *)model{
    
    NSString *path = [self applicationDocumentDirectory];
    if (sqlite3_open([path UTF8String], &db) != SQLITE_OK ) {
        sqlite3_close(db);
        NSAssert(NO, @"数据库打开失败");
    }else{
        NSString *sql = @"DELETE FROM StudentName WHERE idNum = ? OR name = ?";
        sqlite3_stmt *statement;
        if (sqlite3_prepare(db, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_bind_text(statement, 1, [model.idNum UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 2, [model.name UTF8String], -1, NULL);
            if (sqlite3_step(statement) != SQLITE_DONE) {
                NSAssert(NO, @"删除数据失败");
            }
            sqlite3_finalize(statement);
            sqlite3_close(db);
            return 1;
        }
        
    }
    
    return 0;
}

//修改数据
- (int)reviseModel: (StudentModel *)model{
    NSString *path = [self applicationDocumentDirectory];
    if (sqlite3_open([path UTF8String] , &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"数据库打开失败");
    }else{
        NSString *sql =@"UPDATE StudentName SET name = ? WHERE idNum = ? ";
        sqlite3_stmt *statement;
        if (sqlite3_prepare(db, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_bind_text(statement, 1, [model.name UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 2, [model.idNum UTF8String], -1, NULL);
            if (sqlite3_step(statement) != SQLITE_DONE) {
                NSAssert(NO, @"修改数据失败");
            }
            sqlite3_finalize(statement);
            sqlite3_close(db);
            return 1;
        }
        
    }
    return 0;
}
@end
