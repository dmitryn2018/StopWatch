//
//  StopWatchExtraView.m
//  StopWatch
//
//  Created by Mac on 9/2/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import "StopWatchExtraView.h"
#import "NSMenuExtra.h"
#import "NSMenuExtraView.h"
#import "StopWatchExtra.h"

@interface StopWatchExtraView ()

@property (nonatomic) BOOL clicked;

@end

@implementation StopWatchExtraView

- (void)setHighlightState:(BOOL)state{
    if(self.clicked != state){
        self.clicked = state;
        [self setNeedsDisplay:YES];
    }
}

- (void)drawRect:(NSRect)rect {
//    if (!self.color) [[NSColor blueColor] set];
//    else [self.color set];
//    NSRect smallerRect = NSInsetRect( rect, 4.0, 4.0 );
//    [[NSBezierPath bezierPathWithOvalInRect: smallerRect] fill];
    if (((StopWatchExtra*)_menuExtra).isRunning)
    {
        [[[NSColor greenColor] colorWithAlphaComponent:0.4] setFill];
        NSRectFillUsingOperation(rect, NSCompositeSourceOver);
    } else
    {
        [[NSColor clearColor]setFill];
        NSRectFillUsingOperation(rect, NSCompositeSourceOver);
    }
    
    
    if (!self.text  || !self.text.length) self.text = @"Stopwatch";
    NSColor *textColor;
    if([_menuExtra isMenuDown]) {
        textColor = [NSColor selectedMenuItemTextColor];
        [_menuExtra drawMenuBackground:YES];
    } else {
        //[NSColor blackColor];
        textColor = [NSColor colorWithCalibratedWhite:0.2 alpha:1.0];
    }
    NSFont* font = [NSFont systemFontOfSize:14.0];
    NSDictionary* stringAttrs = @{ NSFontAttributeName : font, NSForegroundColorAttributeName : textColor };
    NSSize stringSize = [self.text sizeWithAttributes:stringAttrs];
    [self setFrameSize:NSMakeSize(stringSize.width + 16, [self frame].size.height)];
    [_menuExtra setLength:(double) stringSize.width + 16];

    NSAttributedString* attrStr = [[NSAttributedString alloc] initWithString:self.text attributes:stringAttrs];
    
    NSPoint centerPoint;
    centerPoint.x = 8;
    centerPoint.y = 3;
    
    [attrStr drawAtPoint:centerPoint];

}

- (void)mouseDown:(NSEvent *)theEvent{
    [super mouseDown:theEvent];
    [self setHighlightState:!self.clicked];
    if ([theEvent modifierFlags] & NSControlKeyMask){
        [_menuExtra performSelectorOnMainThread:@selector(rightClick) withObject:nil waitUntilDone:NO];
    }
    else{
        [_menuExtra performSelectorOnMainThread:@selector(click) withObject:nil waitUntilDone:NO];
    }
}

//- (void)rightMouseDown:(NSEvent *)theEvent{
//    [super rightMouseDown:theEvent];
//    [self setHighlightState:!self.clicked];
//    [_menuExtra performSelectorOnMainThread:@selector(rightClick) withObject:nil waitUntilDone:NO];
//}
//
//- (NSMenu *)menuForEvent:(NSEvent *)event
//{
//    return ((StopWatchExtra*)_menuExtra).rightMenu;
//}

@end
