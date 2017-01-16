//
// Created by Guilherme Rambo on 16/01/17.
// Copyright (c) 2017 Guilherme Rambo. All rights reserved.
//

#import "XGPMessage.h"

@interface NSMutableArray (Shuffling)
- (void)shuffle;
@end

@implementation NSMutableArray (Shuffling)

- (void)shuffle
{
    NSUInteger count = [self count];
    if (count < 1) return;
    for (NSUInteger i = 0; i < count - 1; ++i) {
        NSInteger remainingCount = count - i;
        NSInteger exchangeIndex = i + arc4random_uniform((u_int32_t )remainingCount);
        [self exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
    }
}

@end

@implementation XGPMessage

+ (NSString *)firstAlertTitle
{
    static int current = 0;
    static NSMutableArray *messages;
    if (!messages) {
        messages = [@[@"Whoa! Wait!",
                @"Hold your horses!",
                @"Abort! Abort! Abort",
                @"Warning!!!",
                @"Danger, Danger!",
                @"Watch Out!",
                @"Are you crazy?",
                @"Вас взломали"] mutableCopy];
        [messages shuffle];
    }

    current++;
    if (current >= messages.count) current = 0;

    return messages[current];
}

+ (NSString *)firstAlertBody
{
    static int current = 0;
    static NSMutableArray *messages;
    if (!messages) {
        messages = [@[@"You are using an unsafe version of Xcode, it is EXTREMELY recommended that you don't use this to distribute your apps.\n\nAre you sure you want to continue?",
                @"This version of Xcode is not properly signed by Apple. Distributing apps from this version is very unsafe.\n\nDo you want to put your users in risk?",
                @"The original Xcode is signed by Apple for a very good reason: to prevent malicious code injection in distributed apps. It is extremely recomended that you don't use this unsigned version to distribute apps.\n\nDo you want to take this huge risk?",
                @"In September 2015, a modified version of Xcode got distributed and caused numerous apps on the App Store to be distributed with malware. This version of Xcode could be suffering from the same issue.\n\nDo you want to run the risk of distributing malware to your users?"] mutableCopy];
        [messages shuffle];
    }

    current++;
    if (current >= messages.count) current = 0;

    return messages[current];
}

@end
