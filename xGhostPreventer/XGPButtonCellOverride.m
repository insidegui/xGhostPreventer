//
//  XGPButtonCellOverride.m
//  xGhostPreventer
//
//  Created by Guilherme Rambo on 16/01/17.
//  Copyright © 2017 Guilherme Rambo. All rights reserved.
//

#import "XGPButtonCellOverride.h"

#import <objc/runtime.h>

@implementation XGPButtonCellOverride

+ (void)apply
{
    Class originalClass = NSClassFromString(@"IDEProductsButtonCell");
    if (!originalClass) return;
    
    Method m1 = class_getInstanceMethod(originalClass, @selector(drawBezelWithFrame:inView:));
    Method m2 = class_getInstanceMethod([self class], @selector(drawBezelWithFrame:inView:));
    method_exchangeImplementations(m1, m2);
}

- (void)drawBezelWithFrame:(NSRect)frame inView:(NSView *)controlView
{
    NSString *sufix = @"";
    
    if (self.isEnabled) {
        if (self.isHighlighted) {
            sufix = @"_pressed";
        }
    } else {
        sufix = @"_disabled";
    }
    
    NSBundle *bundle = [NSBundle bundleForClass:[XGPButtonCellOverride class]];
    
    NSImage *left = [bundle imageForResource:[NSString stringWithFormat:@"IDEProductsButton_left%@", sufix]];
    NSImage *center = [bundle imageForResource:[NSString stringWithFormat:@"IDEProductsButton_center%@", sufix]];
    NSImage *right = [bundle imageForResource:[NSString stringWithFormat:@"IDEProductsButton_right%@", sufix]];
    
    NSDrawThreePartImage(frame, left, center, right, NO, NSCompositingOperationSourceOver, 1.0, YES);
}

@end
