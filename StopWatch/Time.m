//
//  Time.m
//  StopWatch
//
//  Created by Mac on 9/2/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import "Time.h"
@import Cocoa;

@implementation Time

- (Class)classForCoder
{
    return [self class]; // Instead of NSMutableDictionary
}

-(NSString*)string
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateFormat:@"EEEE, MMM dd"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    
    return [NSString stringWithFormat:@"%@, %@", [dateFormatter stringFromDate:self.date], [self timeFromInterval:self.time]];
}

-(NSString*)timeFromInterval:(NSTimeInterval)interval
{
    NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:(interval)];
    
    // Create a date formatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    
    // Format the elapsed time and set it to the label
    return [dateFormatter stringFromDate:timerDate];
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:_date forKey:@"_date"];
    [coder encodeObject:@(_time) forKey:@"_time"];
}

- (id)initWithCoder:(NSCoder *)coder
{    
    _date = [coder decodeObjectForKey:@"_date"];
    _time = [[coder decodeObjectForKey:@"_time"] doubleValue];
    
    return self;
}

@end
