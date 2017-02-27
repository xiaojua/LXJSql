//
//  Person+CoreDataProperties.h
//  LXJSql
//
//  Created by xiaojuan on 17/2/27.
//  Copyright © 2017年 xiaojuan. All rights reserved.
//

#import "Person+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Person (CoreDataProperties)

+ (NSFetchRequest<Person *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *age;
@property (nullable, nonatomic, copy) NSString *height;

@end

NS_ASSUME_NONNULL_END
