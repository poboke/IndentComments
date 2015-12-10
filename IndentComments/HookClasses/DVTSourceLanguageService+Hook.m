//
//  DVTSourceLanguageService+Hook.m
//  IndentComments
//
//  Created by Jobs on 15/12/8.
//  Copyright © 2015年 Jobs. All rights reserved.
//

#import "DVTSourceLanguageService+Hook.h"

@implementation DVTSourceLanguageService (Hook)

+ (void)hook
{
    [self jr_swizzleMethod:@selector(stringByCommentingString:)
                withMethod:@selector(hook_stringByCommentingString:)
                     error:nil];
}


- (NSString *)hook_stringByCommentingString:(NSString *)commentingString
{
    NSString *lineCommentPrefix = [self.lineCommentPrefixes firstObject];
    
    if (lineCommentPrefix.length == 0) {
        
        // Use `/* */` block comment circum
        NSArray *blockCommentCircumfix = [self.blockCommentCircumfixes firstObject];
        lineCommentPrefix = [blockCommentCircumfix firstObject];
        
        NSString *lineCommentSuffix = [blockCommentCircumfix lastObject];
        if (lineCommentSuffix) {
            commentingString = [commentingString stringByAppendingString:lineCommentSuffix];
        }
    }
    
    // Check if the string contains nonwhitespace character
    NSRange range = [commentingString rangeOfString:@"[^\\s]" options:NSRegularExpressionSearch];
    if (range.location == NSNotFound) {
        return commentingString;
    }
    
    NSMutableString *mutableString = [commentingString mutableCopy];
    [mutableString insertString:lineCommentPrefix atIndex:range.location];
    return [mutableString copy];
}

@end
