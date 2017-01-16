//
//  IDEDistributionAssistantWindowController.h.h
//  xGhostPreventer
//
//  Created by Guilherme Rambo on 16/01/17.
//  Copyright (c) 2017 Guilherme Rambo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IDEArchive: NSObject
@end

@interface IDEDistributionContext: NSObject

- (instancetype)initWithParent:(id)parent;
- (void)setArchive:(IDEArchive *)archive;
- (void)setDistributionTask:(NSNumber *)task;

@end

@interface IDEDistributionAssistantWindowController: NSWindowController

+ (void)beginAssistantWithArchive:(IDEArchive *)archive task:(int)task window:(NSWindow *)windowForSheet;
- (instancetype)initWithArchive:(IDEArchive *)archive task:(int)task;
- (void)setContext:(IDEDistributionContext *)ctx;
- (void)beginSheetModalForWindow:(NSWindow *)window completionBlock:(void(^)())block;

- (void)primitiveInvalidate;

@end
