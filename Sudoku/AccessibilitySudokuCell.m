//
//  AccessibilitySudokuCell.m
//  Sudoku
//
//  Created by Wayne Cochran on 4/24/14.
//  Copyright (c) 2014 WSUV. All rights reserved.
//

#import "AccessibilitySudokuCell.h"
#import "SudokuController.h"
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
             NSAccessibilityHelpAttribute,
             NSAccessibilityTitleAttribute
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
        const BOOL hasFocus = self.parent.focusedCell == self;
        value = @(hasFocus);
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
        value = @"cell of 9x9 Sudoku puzzle";
    } else if ([attribute isEqualToString:NSAccessibilityTitleAttribute]) {
        const int num = [self.sudokuBoard numberAtRow:(int)self.row Column:(int)self.column];
        if (num == 0) {
            value = @"empty cell";
        } else if ([self.sudokuBoard numberIsFixedAtRow:(int)self.row Column:(int)self.column]) {
            value = [NSString stringWithFormat:@"fixed cell with %d", num];
        } else {
            value = [NSString stringWithFormat:@"user cell with %d", num];
        }
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
        if (self.parent.focusedCell != self) {
            self.parent.focusedCell = self;
            [self.parent setNeedsDisplay:YES];
        }
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
    if ([action isEqualToString:NSAccessibilityPressAction]) {
        return @"press sudoku cell";
    } else if ([action isEqualToString:NSAccessibilityDeleteAction]) {
        return @"delete sudoku cell contents";
    }
    return @"Unsupported action";
}

- (void)accessibilityPerformAction:(NSString *)action {
    if ([action isEqualToString:NSAccessibilityPressAction]) {
        AccessibilitySudokuCell *cell = self.parent.focusedCell;
        [self.parent selectUnlessFixedCellAtRow:(int)cell.row Column:(int)cell.column];
    } else if ([action isEqualToString:NSAccessibilityDeleteAction]) {
        if ([self.parent selectUnlessFixedCellAtRow:(int)self.row Column:(int)self.column]) {
            [self.parent.sudokuController deleteNumberAtRow:(int)self.row AndColumn:(int)self.column];
            NSDictionary *announcementInfo = @{NSAccessibilityAnnouncementKey : @"Deleted",
                                               NSAccessibilityPriorityKey : @(NSAccessibilityPriorityHigh)};
            NSAccessibilityPostNotificationWithUserInfo(NSApp, NSAccessibilityAnnouncementRequestedNotification, announcementInfo);
        } else {
            NSDictionary *announcementInfo = @{NSAccessibilityAnnouncementKey : @"Can not delete",
                                               NSAccessibilityPriorityKey : @(NSAccessibilityPriorityHigh)};
            NSAccessibilityPostNotificationWithUserInfo(NSApp, NSAccessibilityAnnouncementRequestedNotification, announcementInfo);
        }

    }
}

@end
