//
//  AccessibilitySudokuCell.m
//  Sudoku
//
//  Created by Wayne Cochran on 4/24/14.
//  Copyright (c) 2014 WSUV. All rights reserved.
//

#import "AccessibilitySudokuCell.h"
#import "SudokuBoard.h"
#import "SudokuView.h"

@implementation AccessibilitySudokuCell

-(id)initWithRow:(NSInteger)row Column:(NSInteger)col {
    self = [super init];
    if (self) {
        _row = row;
        _column = col;
    }
    return self;
}

-(BOOL)accessibilityIsIgnored {
    return NO;
}

-(NSArray*)accessibilityAttributeNames {
    static NSMutableArray *attributes = nil;
    if (attributes == nil) {
        attributes = [[super accessibilityAttributeNames] mutableCopy];
        NSArray *appendedAttributes =
        @[
          NSAccessibilityChildrenAttribute,
          NSAccessibilityColumnIndexRangeAttribute,
          NSAccessibilityEnabledAttribute,
          NSAccessibilityFocusedAttribute,
          NSAccessibilityParentAttribute,
          NSAccessibilityPositionAttribute,
          NSAccessibilityRoleAttribute,
          NSAccessibilityRoleDescriptionAttribute,
          NSAccessibilityRowIndexRangeAttribute,
          NSAccessibilitySelectedAttribute,
          NSAccessibilitySizeAttribute,
          NSAccessibilityTopLevelUIElementAttribute,
          NSAccessibilityWindowAttribute,
          NSAccessibilityHelpAttribute
          ];
        for (NSString *attribute in appendedAttributes) {
            if (![appendedAttributes containsObject:attribute]) {
                [attributes addObject:attribute];
            }
        }
    }
    return attributes;
 
}

-(id)accessibilityAttributeValue:(NSString *)attribute {
    id value = nil;

    // XXXX
    
    return value;
}

- (BOOL)accessibilityIsAttributeSettable:(NSString *)attribute {
    return NO; // XXX
}


- (void)accessibilitySetValue:(id)value
                 forAttribute:(NSString *)attribute {
    
}

-(id)accessibilityHitTest:(NSPoint)point {
    return NSAccessibilityUnignoredAncestor(self);
}

- (id)accessibilityFocusedUIElement {
    return NSAccessibilityUnignoredAncestor(self);
}


@end
