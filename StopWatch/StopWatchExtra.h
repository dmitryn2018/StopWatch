//
//  StopWatchExtra.h
//  StopWatch
//
//  Created by Mac on 9/2/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSMenuExtra.h"

@class StopWatchExtraView;

@interface StopWatchExtra : NSMenuExtra
{
    NSMenu *theMenu;
    StopWatchExtraView *theView;
    NSMutableArray* intervals;
}


@property (nonatomic) BOOL isRunning;
@property (nonatomic) NSMenu *rightMenu;

@end
