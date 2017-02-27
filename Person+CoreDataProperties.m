//
//  Person+CoreDataProperties.m
//  LXJSql
//
//  Created by xiaojuan on 17/2/27.
//  Copyright © 2017年 xiaojuan. All rights reserved.
//

#import "Person+CoreDataProperties.h"

@implementation Person (CoreDataProperties)

+ (NSFetchRequest<Person *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Person"];
}

@dynamic name;
@dynamic age;
@dynamic height;

@end
