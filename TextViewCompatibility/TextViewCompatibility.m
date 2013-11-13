//
//  TextViewCompatibility.m
//  TextViewCompatibility
//
//  Created by kishikawa katsumi on 2013/11/13.
//  Copyright (c) 2013 kishikawa katsumi. All rights reserved.
//

#import "TextViewCompatibility.h"

@implementation TextViewCompatibility

// from https://gist.github.com/agiletortoise/a24ccbf2d33aafb2abc1
- (CGRect)firstRectForRange:(UITextRange *)range
{
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        CGRect r1= [self caretRectForPosition:[self positionWithinRange:range farthestInDirection:UITextLayoutDirectionRight]];
        CGRect r2= [self caretRectForPosition:[self positionWithinRange:range farthestInDirection:UITextLayoutDirectionLeft]];
        return CGRectUnion(r1,r2);
    }
    return [super firstRectForRange:range];
}

- (NSUInteger)characterIndexForPoint:(CGPoint)point
{
    if (self.text.length == 0) {
        return 0;
    }
    
    CGRect r1;
    if ([[self.text substringFromIndex:self.text.length - 1] isEqualToString:@"\n"]) {
        r1 = [super caretRectForPosition:[super positionFromPosition:self.endOfDocument offset:-1]];
        CGRect sr = [super caretRectForPosition:[super positionFromPosition:self.beginningOfDocument offset:0]];
        r1.origin.x = sr.origin.x;
        r1.origin.y += self.font.lineHeight;
    } else {
        r1 = [super caretRectForPosition:[super positionFromPosition:self.endOfDocument offset:0]];
    }
    
    if ((point.x > r1.origin.x && point.y >= r1.origin.y) || point.y >= r1.origin.y + r1.size.height) {
        return [super offsetFromPosition:self.beginningOfDocument toPosition:self.endOfDocument];
    }
    
    CGFloat fraction;
    NSUInteger index = [self.textStorage.layoutManagers[0] characterIndexForPoint:point inTextContainer:self.textContainer fractionOfDistanceBetweenInsertionPoints:&fraction];
    
    return index;
}

- (UITextPosition *)closestPositionToPoint:(CGPoint)point
{
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        point.y -= self.font.lineHeight / 2;
        NSUInteger index = [self characterIndexForPoint:point];
        UITextPosition *pos = [self positionFromPosition:self.beginningOfDocument offset:index];
        return pos;
    }
    
    return [super closestPositionToPoint:point];
}

- (void)scrollRangeToVisible:(NSRange)range
{
    [super scrollRangeToVisible:range];
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        if (self.layoutManager.extraLineFragmentTextContainer != nil && self.selectedRange.location == range.location) {
            CGRect caretRect = [self caretRectForPosition:self.selectedTextRange.end];
            [self scrollRectToVisible:caretRect animated:NO];
        }
    }
}

@end
