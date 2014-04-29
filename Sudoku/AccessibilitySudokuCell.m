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
    return @[
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
}

-(id)accessibilityAttributeValue:(NSString *)attribute {
    id value = nil;

    if ([attribute isEqualToString:NSAccessibilityChildrenAttribute]) {
        value = nil;
    } else if ([attribute isEqualToString:NSAccessibilityColumnIndexRangeAttribute]) {
        value = [NSValue valueWithRange:NSMakeRange(self.column, 1)];
    } else if ([attribute isEqualToString:NSAccessibilityEnabledAttribute]) {
        value = @YES;
    } else if ([attribute isEqualToString:NSAccessibilityFocusedAttribute]) {
        value = [NSNumber numberWithBool:self.focused];
    } else if ([attribute isEqualToString:NSAccessibilityParentAttribute]) {
        value = self.parent;
    } else if ([attribute isEqualToString:NSAccessibilityPositionAttribute]) {
        value = [NSValue valueWithPoint:[self.parent screenPositionOfCellAtRow:self.row AndColumn:self.column]];
    } else if ([attribute isEqualToString:NSAccessibilityRoleAttribute]) {
        value = NSAccessibilityCellRole;
    } else if ([attribute isEqualToString:NSAccessibilityRoleDescriptionAttribute]) {
        value = @"cell of 9x9 Sudoku puzzle";
    } else if ([attribute isEqualToString:NSAccessibilityRowIndexRangeAttribute]) {
        value = [NSValue valueWithRange:NSMakeRange(self.row, 1)];
    } else if ([attribute isEqualToString:NSAccessibilitySelectedAttribute]) {
        const BOOL selected = self.parent.selectedRow == self.row && self.parent.selectedColumn == self.column;
        value = [NSNumber numberWithBool:selected];
    } else if ([attribute isEqualToString:NSAccessibilitySizeAttribute]) {
        value = [NSValue valueWithSize:[self.parent screenSizeOfCell]];
    } else if ([attribute isEqualToString:NSAccessibilityTopLevelUIElementAttribute]) {
        value = self.parent.window;
    } else if ([attribute isEqualToString:NSAccessibilityWindowAttribute]) {
        value = self.parent.window;
    } else if ([attribute isEqualToString:NSAccessibilityHelpAttribute]) {
        value = @"ell of 9x9 Sudoku puzzle";
    }
    
    return value;
}

- (BOOL)accessibilityIsAttributeSettable:(NSString *)attribute {
    if ([attribute isEqualToString:NSAccessibilityFocusedAttribute] ||
        [attribute isEqualToString:NSAccessibilitySelectedAttribute]) {
        return YES;
    }
    return NO;
}


- (void)accessibilitySetValue:(id)value
                 forAttribute:(NSString *)attribute {
    if ([attribute isEqualToString:NSAccessibilityFocusedAttribute]) {
        self.focused = [value boolValue];
        // XXX
    } else if ([attribute isEqualToString:NSAccessibilitySelectedAttribute]) {
        const BOOL selected = [value boolValue];
        if (selected) {
            self.parent.selectedRow = self.row;
            self.parent.selectedColumn = self.column;
        }
    }
    
}

-(id)accessibilityHitTest:(NSPoint)point {
    //return NSAccessibilityUnignoredAncestor(self);
    return self;
}

- (id)accessibilityFocusedUIElement {
    //return NSAccessibilityUnignoredAncestor(self);
    return self;
}

-(NSArray*)accessibilityActionNames {
    return @[NSAccessibilityDeleteAction, NSAccessibilityPressAction];
}

- (NSString *)accessibilityActionDescription:(NSString *)action {
    return @"not done yet"; // XXXX
}

- (void)accessibilityPerformAction:(NSString *)action {
    // XXX
}

@end
