//
//  xGhostPreventer.h
//  xGhostPreventer
//
//  Created by Guilherme Rambo on 16/01/17.
//  Copyright © 2017 Guilherme Rambo. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface xGhostPreventer : NSObject

+ (instancetype)sharedPlugin;

@property (nonatomic, strong, readonly) NSBundle* bundle;
@end