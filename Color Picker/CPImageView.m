//
//  CPImageView.m
//  Color Picker
//
//  Created by Qian Wang on 4/21/13.
//  Copyright (c) 2013 Pony Studio. All rights reserved.
//

#import "CPImageView.h"

@implementation CPImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    NSLog(@"x %f, y %f,", point.x, point.y);
    
    if (CGRectContainsPoint(self.bounds, point)) {
        self.location = point;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"color" object:self];

    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

@end
