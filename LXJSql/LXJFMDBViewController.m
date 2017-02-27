//
//  LXJFMDBViewController.m
//  LXJSql
//
//  Created by xiaojuan on 17/2/24.
//  Copyright © 2017年 xiaojuan. All rights reserved.
//

#import "LXJFMDBViewController.h"
#import "FMDB.h"

@interface LXJFMDBViewController ()

@end

@implementation LXJFMDBViewController

static FMDatabase *fmdb = nil;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"%@", NSHomeDirectory());
    
    [self createTable];
    
}
/* 创建并打开数据库 */
- (FMDatabase *)createDBAndOpenDB{
    if (fmdb != nil) {
        return fmdb;
    }
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *fmdbFilePath = [documentPath stringByAppendingPathComponent:@"fmdb.db"];
    fmdb = [FMDatabase databaseWithPath:fmdbFilePath];
    BOOL isResutl =  [fmdb open];
    if (isResutl) {
        NSLog(@"创建并打开数据库成功");
    }else{
        NSLog(@"创建并打开数据库失败%@",fmdb.lastError);
    }
    
    return fmdb;
}
/* 关闭数据库 */
- (void)closeDB{
    BOOL isCloseDB = [fmdb close];
    if (isCloseDB) {
        //数据库关闭成功后，要把fmdb置空
        fmdb = nil;
        NSLog(@"关闭数据库成功");
    }else{
        NSLog(@"关闭数据库失败%@",fmdb.lastError);
    }
}
/* 创建表 */
- (void)createTable{
    fmdb = [self createDBAndOpenDB];
    BOOL isSucess = [fmdb executeUpdate:@"create table if not exists Person (id integer primary key, name text, age integer, height real)"];
    if (isSucess) {
        NSLog(@"创建表成功");
    }else{
        NSLog(@"创建表失败%@",fmdb.lastError);
    }
    [self closeDB];
}

- (IBAction)add:(id)sender {
    fmdb = [self createDBAndOpenDB];
    BOOL isSucess = [fmdb executeUpdate:@"insert into Person (name, age, height) values ('Lee', 13, 1.5)"];
    if (isSucess) {
        NSLog(@"插入数据成功");
    }else{
        NSLog(@"插入数据失败%@",fmdb.lastError);
    }
    [self closeDB];
}
- (IBAction)delete:(id)sender {
    fmdb = [self createDBAndOpenDB];
    BOOL isSucess = [fmdb executeUpdate:@"delete from Person where id = 1"];
    if (isSucess) {
        NSLog(@"删除数据成功");
    }else{
        NSLog(@"删除数据失败:%@",fmdb.lastError);
    }
    
    [self closeDB];
}
- (IBAction)update:(id)sender {
    fmdb = [self createDBAndOpenDB];
    BOOL isSucess = [fmdb executeUpdate:@"update Person set name = 'Json' where id = 2"];
    if (isSucess) {
        NSLog(@"更新数据成功");
    }else{
        NSLog(@"更新数据失败：%@", fmdb.lastError);
    }
    
    [self closeDB];
}
- (IBAction)check:(id)sender {
    fmdb = [self createDBAndOpenDB];
    FMResultSet *set = [fmdb executeQuery:@"select * from Person"];
    while ([set next]) {
        NSString *name = [set stringForColumn:@"name"];
        int age = [set intForColumn:@"age"];
        double height = [set doubleForColumn:@"height"];
        NSLog(@"name:%@,age:%d,height:%f", name, age, height);
    }
    
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
