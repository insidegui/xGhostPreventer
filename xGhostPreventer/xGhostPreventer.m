//
//  xGhostPreventer.m
//  xGhostPreventer
//
//  Created by Guilherme Rambo on 16/01/17.
//  Copyright © 2017 Guilherme Rambo. All rights reserved.
//

#import "xGhostPreventer.h"

#import <objc/runtime.h>

#import "IDEDistributionAssistantWindowController.h"

#import "XGPSadTim.h"
#import "XGPMessage.h"
#import "XGPButtonCellOverride.h"

static xGhostPreventer *sharedPlugin;

@interface xGhostPreventer ()

@end

@implementation xGhostPreventer

#pragma mark - Initialization

+ (void)pluginDidLoad:(NSBundle *)plugin
{
    sharedPlugin = [[self alloc] initWithBundle:plugin];
}

+ (instancetype)sharedPlugin
{
    return sharedPlugin;
}

- (id)initWithBundle:(NSBundle *)bundle
{
    if (self = [super init]) {
        // reference to plugin's bundle, for resource access
        _bundle = bundle;
        // NSApp may be nil if the plugin is loaded from the xcodebuild command line tool
        if (NSApp && !NSApp.mainMenu) {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(applicationDidFinishLaunching:)
                                                         name:NSApplicationDidFinishLaunchingNotification
                                                       object:nil];
        } else {
            [self initializeAndLog];
        }
    }
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSApplicationDidFinishLaunchingNotification object:nil];
    [self initializeAndLog];
}

- (void)initializeAndLog
{
    if ([self __isCodeSignatureValid]) {
        #ifdef DEBUG
        NSLog(@"[xGhostPreventer] Not preventing distribution because the app is correctly signed");
        #endif
        return;
    }
    
    [XGPButtonCellOverride apply];
    
    NSString *name = [self.bundle objectForInfoDictionaryKey:@"CFBundleName"];
    NSString *version = [self.bundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *status = [self initialize] ? @"loaded successfully" : @"failed to load";
    NSLog(@"🔌 Plugin %@ %@ %@", name, version, status);
}

#pragma mark - Implementation

- (BOOL)initialize
{
    Class controllerClass = NSClassFromString(@"IDEDistributionAssistantWindowController");
    if (!controllerClass) return NO;

    Method m1 = class_getClassMethod(controllerClass, @selector(beginAssistantWithArchive:task:window:));
    if (!m1) return NO;

    Method m2 = class_getClassMethod([self class], @selector(__override_beginAssistantWithArchive:task:window:));
    if (!m2) return NO;

    method_exchangeImplementations(m1, m2);

    return YES;
}

+ (void)__override_beginAssistantWithArchive:(IDEArchive *)archive task:(int)task window:(NSWindow *)windowForSheet
{
    Class controllerClass = NSClassFromString(@"IDEDistributionAssistantWindowController");
    Class contextClass = NSClassFromString(@"IDEDistributionContext");
    
    // setup distribution for later, if the user decides to go ahead
    id ctx = [(IDEDistributionContext *)[contextClass alloc] initWithParent:nil];
    [ctx setArchive:archive];
    [ctx setDistributionTask:@(task)];
    
    id controller = [(IDEDistributionAssistantWindowController *)[controllerClass alloc] initWithArchive:archive task:task];
    [controller setContext:ctx];
    
    if (task == 0) {
        // validate task doesn't have to be prevented
        [controller beginSheetModalForWindow:windowForSheet completionBlock:nil];
        return;
    }
    
    NSAlert *alert = [NSAlert new];

    alert.messageText = [XGPMessage firstAlertTitle];
    alert.informativeText = [XGPMessage firstAlertBody];

    [alert addButtonWithTitle:@"No, Let's Be Safe"];
    [alert addButtonWithTitle:@"Yes, I am Irresponsible"];

    [alert beginSheetModalForWindow:windowForSheet completionHandler:^(NSModalResponse returnCode) {
        if (returnCode == NSAlertFirstButtonReturn) {
            [controller invalidate];
            return;
        }

        NSAlert *alert2 = [NSAlert new];

        alert2.messageText = @"Sure?";
        alert2.informativeText = @"PEOPLE MAY DIE!!!!1";

        [alert2 addButtonWithTitle:@"Back to Safety"];
        [alert2 addButtonWithTitle:@"Let's Go!"];

        [alert2 setAccessoryView:[XGPSadTim sadTimView]];

        [alert2 beginSheetModalForWindow:windowForSheet completionHandler:^(NSModalResponse returnCode) {
            if (returnCode == NSAlertFirstButtonReturn) {
                [controller invalidate];
                return;
            }
            
            [controller beginSheetModalForWindow:windowForSheet completionBlock:nil];
        }];
    }];
}

- (BOOL)__isCodeSignatureValid
{
    CFErrorRef secError;
    
    SecCodeRef code;
    if (SecCodeCopySelf(kSecCSDefaultFlags, &code) != 0) return NO;
    
    SecStaticCodeRef staticCode;
    if (SecCodeCopyStaticCode(code, kSecCSDefaultFlags, &staticCode) != 0) return NO;
    
    return (SecCodeCheckValidityWithErrors(code, kSecCSDefaultFlags, NULL, &secError) == 0) && (SecStaticCodeCheckValidity(staticCode, kSecCSDefaultFlags, NULL) == 0);
}

@end
