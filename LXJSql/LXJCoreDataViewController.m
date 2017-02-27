//
//  LXJCoreDataViewController.m
//  LXJSql
//
//  Created by xiaojuan on 17/2/24.
//  Copyright © 2017年 xiaojuan. All rights reserved.
//

#import "LXJCoreDataViewController.h"
#import <CoreData/CoreData.h>
#import "Person+CoreDataClass.h"

@interface LXJCoreDataViewController ()
{
    NSManagedObjectContext *context;//coreData上下文
}

@end

@implementation LXJCoreDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"%@", NSHomeDirectory());
    
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:model];
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *dbFilePath = [documentPath stringByAppendingPathComponent:@"Sqlite.sqlite"];
    NSURL *url = [NSURL fileURLWithPath:dbFilePath];
    NSError *error = nil;
    NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error];
    if (store == nil) {
        [NSException raise:@"添加数据库错误" format:@"%@",[error localizedDescription]];
    }
    //初始化上线
    context = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    context.persistentStoreCoordinator = psc;
    
}
- (IBAction)add:(id)sender {
    NSManagedObject *obj = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:context];
    [obj setValue:@"Lee" forKey:@"name"];
    [obj setValue:@"18" forKey:@"age"];
    [obj setValue:@"1.7" forKey:@"height"];
    
    NSError *error = nil;
    //改变实体后保存上下文
    BOOL isSucess = [context save:&error];
    if (!isSucess) {
        [NSException raise:@"添加数据失败" format:@"%@",[error localizedDescription]];
    }else{
        NSLog(@"添加数据成功");
    }
}
- (IBAction)delete:(id)sender {
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    request.entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"age=%@", @"18"];
    request.predicate = predicate;
    NSError *error = nil;
    NSArray *resultArr = [context executeFetchRequest:request error:&error];
    if (error) {
        [NSException raise:@"查询数据失败" format:@"%@",[error localizedDescription]];
    }
    for (NSManagedObject *obj in resultArr) {
        [context deleteObject:obj];
    }
    BOOL isSucess = [context save:&error];
    if (!isSucess) {
        [NSException raise:@"删除数据失败" format:@"%@",[error localizedDescription]];
    }else{
        NSLog(@"删除数据失败");
    }
    
}
- (IBAction)update:(id)sender {
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    request.entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name like %@", @"*Lee*"];
    request.predicate = predicate;
    NSError *error = nil;
    NSArray *resultArr = [context executeFetchRequest:request error:&error];
    if (error) {
        [NSException raise:@"查询数据失败" format:@"%@", [error localizedDescription]];
    }
    for (NSManagedObject *obj in resultArr ) {
        [obj setValue:@"Json" forKey:@"name"];
    }
    BOOL isSucess = [context save:&error];
    if (!isSucess) {
        [NSException raise:@"更新数据失败" format:@"%@", [error localizedDescription]];
    }else{
        NSLog(@"更新数据成功");
    }
    
}
- (IBAction)check:(id)sender {
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    request.entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name like %@", @"*Json*"];
    request.predicate = predicate;
    NSError *error = nil;
    NSArray *resultArr = [context executeFetchRequest:request error:&error];
    if (error) {
        [NSException raise:@"查询数据失败" format:@"%@", [error localizedDescription]];
    }else{
        for (NSManagedObject *obj in resultArr) {
            NSLog(@"name:%@,age:%@,height:%@", [obj valueForKey:@"name"], [obj valueForKey:@"age"], [obj valueForKey:@"height"]);
        }
        NSLog(@"查询数据成功");
    }
    
    
    
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
