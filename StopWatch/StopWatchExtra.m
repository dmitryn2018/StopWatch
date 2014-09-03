//
//  StopWatchExtra.m
//  StopWatch
//
//  Created by Mac on 9/2/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import "StopWatchExtra.h"
#import "StopWatchExtraView.h"
#import "Time.h"

#define ARCHIVE_NAME @"Stopwatch.arch"

@interface StopWatchExtra ()

@property (strong, nonatomic) NSTimer *stopWatchTimer; // Store the timer that fires after a certain time
@property (strong, nonatomic) NSDate *startDate; // Stores the date of the click on the start button
@property (nonatomic) NSTimeInterval interval;

@end

@implementation StopWatchExtra

- (id)initWithBundle:(NSBundle *)bundle
{
    self = [super initWithBundle:bundle];
    if( self == nil )
        return nil;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *path = [documentsPath stringByAppendingPathComponent:ARCHIVE_NAME];
    
    intervals = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    if (!intervals) intervals = [[NSMutableArray alloc] init];
    
    // we will create and set the MenuExtraView
    theView = [[StopWatchExtraView alloc] initWithFrame:
               [[self view] frame] menuExtra:self];
    [self setView:theView];
    
    
    self.rightMenu = [[NSMenu alloc] initWithTitle: @""];
    [self.rightMenu setAutoenablesItems: NO];
    NSMenuItem *item = [self.rightMenu addItemWithTitle: @"History" action:@selector(unload1) keyEquivalent: @""];
    item.submenu = [[NSMenu alloc] initWithTitle: @"History"];
    [item setTarget:self];
    NSMenuItem *item1 = [item.submenu addItemWithTitle: @"Archive" action:@selector(archive) keyEquivalent: @"A"];
    [item1 setTarget:self];
    item1 = [item.submenu addItemWithTitle: @"Clear archive" action:@selector(clearArchive) keyEquivalent: @"C"];
    [item1 setTarget:self];
    item1 = [item.submenu addItemWithTitle: @"Write to file" action:@selector(dump) keyEquivalent: @"W"];
    [item1 setTarget:self];
    [item.submenu addItem:[NSMenuItem separatorItem]];
    [self.rightMenu addItem:[NSMenuItem separatorItem]];
    
    for (Time *time in intervals) {
        NSMenuItem * item1 = [item.submenu addItemWithTitle:time.string action:@selector(empty) keyEquivalent:@""];
        [item1 setTarget:self];
    }
    
    item = [self.rightMenu addItemWithTitle: @"Reset" action:@selector(reset) keyEquivalent: @"R"];
    [item setTarget:self];
    item = [self.rightMenu addItemWithTitle: @"Open file" action:@selector(open) keyEquivalent: @"O"];
    [item setTarget:self];
//    item = [self.rightMenu addItemWithTitle: @"Write to file" action:@selector(dump) keyEquivalent: @"W"];
//    [item setTarget:self];
//    item = [self.rightMenu addItemWithTitle: @"Archive" action:@selector(archive) keyEquivalent: @"A"];
//    [item setTarget:self];
//    item = [self.rightMenu addItemWithTitle: @"Clear archive" action:@selector(clearArchive) keyEquivalent: @"C"];
//    [item setTarget:self];
    item = [self.rightMenu addItemWithTitle: @"Quit" action: @selector(quit) keyEquivalent: @"Q"];
    [item setTarget:self];
    return self;
}

-(void)willUnload
{
    [self archive];
}

-(void)clearArchive
{
    intervals = [[NSMutableArray alloc] init];
    NSMenuItem * item = self.rightMenu.itemArray[0];
    [item.submenu removeAllItems];
    [self archive];
}

-(void)archive{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *path = [documentsPath stringByAppendingPathComponent:ARCHIVE_NAME];
    [NSKeyedArchiver archiveRootObject:intervals toFile:path];
}

-(void)open
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    
    [[NSWorkspace sharedWorkspace] openFile:[NSString stringWithFormat:@"%@/Stopwatch.txt", path]];
}

-(void)dump
{
    NSString *str = [[intervals valueForKey:@"string"] componentsJoinedByString:@"\n"];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    [str writeToFile:[NSString stringWithFormat:@"%@/Stopwatch.txt", path] atomically:YES encoding:NSUnicodeStringEncoding error:&error];
    
    if (error)
    {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert addButtonWithTitle: @"OK"];
        alert.messageText = error.description;
        [alert runModal];
    }
}

-(void)quit
{
    [self unload];
}

-(void)rightClick
{
   
    [self popUpStatusItemMenu:self.rightMenu];
}

-(void)unload1
{
    theView.text = @"Oh goosh!!";
    [theView setNeedsDisplay:YES];
    

    //[self unload];
}

-(void)reset
{

    [self save];
    self.startDate = [NSDate date];
    self.interval = 0;
    [self dump];
}

-(void)save
{
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:self.startDate];
    
    Time *time = [[Time alloc] init];
    time.date = currentDate;
    time.time = self.interval + timeInterval;
    
    [intervals addObject:time];
    
    NSMenuItem * item = self.rightMenu.itemArray[0];

    NSMenuItem * item1 = [item.submenu addItemWithTitle:time.string action:@selector(empty) keyEquivalent:@""];
    [item1 setTarget:self];
}

- (void)click
{
    if (self.isRunning)
    {
        self.isRunning = NO;
        NSDate *currentDate = [NSDate date];
        NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:self.startDate];
        self.interval += timeInterval;
        [self.stopWatchTimer invalidate];
        self.stopWatchTimer = nil;
        [theView setNeedsDisplay:YES];
    }
    else
    {
        self.isRunning = YES;
        self.startDate = [NSDate date];
        
        self.stopWatchTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/10.0
                                                               target:self
                                                             selector:@selector(updateTimer)
                                                             userInfo:nil
                                                              repeats:YES];
        [theView setNeedsDisplay:YES];
    }
}

- (void)updateTimer
{
    // Create date from the elapsed time
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:self.startDate];
    
    
    theView.text = [self timeFromInterval:self.interval + timeInterval];
    [theView setNeedsDisplay:YES];
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

- (NSMenu *)menu
{
    return theMenu;
}

-(void)empty
{
    
}

@end
