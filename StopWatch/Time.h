//
//  Time.h
//  StopWatch
//
//  Created by Mac on 9/2/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Time : NSObject <NSCoding>

@property (nonatomic) NSDate *date;
@property (nonatomic) NSTimeInterval time;

@property (nonatomic, readonly) NSString *string;

@end
