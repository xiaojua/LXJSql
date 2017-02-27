//
//  LXJSQLiteViewController.m
//  LXJSql
//
//  Created by xiaojuan on 17/2/24.
//  Copyright © 2017年 xiaojuan. All rights reserved.
//

#import "LXJSQLiteViewController.h"
#import <sqlite3.h>


@interface LXJSQLiteViewController ()

@end

@implementation LXJSQLiteViewController

static sqlite3 *db = nil;
static char *errmsg = nil;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@",NSHomeDirectory());
    
    [self openTable];
    
}
/* 打开数据库 */
- (sqlite3 *)openDB{
    if (db != nil) {
        return db;
    }
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *dbFilePath = [documentPath stringByAppendingPathComponent:@"Sqlite.db"];
    int result = sqlite3_open([dbFilePath cStringUsingEncoding:NSUTF8StringEncoding], &db);
    if (result == SQLITE_OK) {
        NSLog(@"创建并打开数据库成功");
    }else{
        NSLog(@"创建并打开数据库失败，%s", sqlite3_errmsg(db));
    }
    
    
    
    return db;
}

/* 关闭数据库 */
- (void)closeDB{
    int result = sqlite3_close(db);
    if (result == SQLITE_OK) {
        db = NULL;
        NSLog(@"关闭数据库成功");
    }else{
        NSLog(@"关闭数据库失败");
    }
}


/* 打开表 */
- (void)openTable{
    db = [self openDB];
    const char *createTable = "create table if not exists dog (id integer primary key, name text, age integer)";
    errmsg = NULL;
    int result = sqlite3_exec(db, createTable, NULL, NULL, &errmsg);
    if (result == SQLITE_OK) {
        NSLog(@"创建表成功");
    }else{
        NSLog(@"创建表失败：%s",errmsg);
    }
    
    [self closeDB];
}

- (IBAction)add:(id)sender {
    db = [self openDB];
    const char *insert = "insert into dog (name, age) values ('二哈', 3)";
    errmsg = NULL;
    int result = sqlite3_exec(db, insert, NULL, NULL, &errmsg);
    if (result == SQLITE_OK) {
        NSLog(@"插入数据成功");
    }else{
        NSLog(@"插入数据失败：%s", errmsg);
    }
    
    [self closeDB];
}
- (IBAction)delete:(id)sender {
    db = [self openDB];
    const char *delete = "delete from dog where age = 3";
    int result = sqlite3_exec(db, delete, NULL, NULL, &errmsg);
    if (result == SQLITE_OK) {
        NSLog(@"删除数据成功");
    }else{
        NSLog(@"删除数据失败：%s", errmsg);
    }
    
    [self closeDB];
}
- (IBAction)update:(id)sender {
    db = [self openDB];
    sqlite3_stmt *stmt;
    const char *update = "update dog set name = (?), age = (?) where id = 1";
    int ret = sqlite3_prepare_v2(db, update, -1, &stmt, nil);
    sqlite3_bind_text(stmt, 1, "小黑", -1, nil);
    sqlite3_bind_int(stmt, 2, 4);
    if (ret == SQLITE_OK) {
        if (SQLITE_DONE == sqlite3_step(stmt)) {
            NSLog(@"更新数据成功");
        }else{
            NSLog(@"更新数据失败");
        }
    }else{
        NSLog(@"更新数据失败");
    }
    
    
    sqlite3_finalize(stmt);
    [self closeDB];
}
- (IBAction)check:(id)sender {
    db = [self openDB];
    sqlite3_stmt *stmt;
    const char *check = "select * from dog";
    int ret = sqlite3_prepare_v2(db, check, -1, &stmt, NULL);
    if (ret == SQLITE_OK) {
        NSLog(@"查询成功");
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            const unsigned char *name = sqlite3_column_text(stmt, 1);
            int age = sqlite3_column_int(stmt, 2);
            NSLog(@"name=%s,age=%d", name, age);
        }
    }else{
        NSLog(@"查询失败");
    }
    sqlite3_finalize(stmt);
    [self closeDB];
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

@end
