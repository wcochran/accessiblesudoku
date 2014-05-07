//
//  SudokuView.m
//  Sudoku
//
//  Created by Wayne O. Cochran on 4/16/14.
//  Copyright (c) 2014 WSUV. All rights reserved.
//

#import "SudokuView.h"
#import "SudokuBoard.h"
#import "AccessibilitySudokuCell.h"
#import "SudokuController.h"

@implementation SudokuView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        _selectedColumn = _selectedRow = -1;
    }
    return self;
}

-(void)awakeFromNib {
    _selectedColumn = _selectedRow = -1;
}

-(void)setSelectedRow:(NSInteger)selectedRow {
    if (_selectedRow != selectedRow) {
        _selectedRow = selectedRow;
        [self setNeedsDisplay:YES];
    }
}

-(void)setSelectedColumn:(NSInteger)selectedColumn {
    if (_selectedColumn != selectedColumn) {
        _selectedColumn = selectedColumn;
        [self setNeedsDisplay:YES];
    }
}

-(BOOL)acceptsFirstResponder {
    return YES;
}

-(BOOL)resignFirstResponder {
    return YES;
}

-(BOOL)becomeFirstResponder {
    return YES;
}

-(void)moveFocusedCellByDeltaX:(int)dx DeltaY:(int)dy {
    AccessibilitySudokuCell *cell = self.focusedCell;
    NSInteger row = cell.row + dy;
    NSInteger col = cell.column + dx;
    if (0 <= row && row <= 9 && 0 <= col && col <= 9) {
        self.focusedCell = self.accessibilityCells[row*9 + col];
        NSAccessibilityPostNotification(self, NSAccessibilityFocusedUIElementChangedNotification);
        [self setNeedsDisplay:YES];
    }
}

enum {
    KEY_DELETE_CODE = 0x33,
    KEY_LEFTARROW_CODE = 0x7B,
    KEY_RIGHTARROW_CODE = 0x7C,
    KEY_DOWNARROW_CODE = 0x7D,
    KEY_UPARROW_CODE = 0x7E,
};

-(void)keyDown:(NSEvent *)theEvent {
    unsigned short code = [theEvent keyCode];
    BOOL eventHandled = NO;
    AccessibilitySudokuCell *cell;
    switch (code) {
        case KEY_DELETE_CODE:
            cell = self.focusedCell;
            if ([self selectUnlessFixedCellAtRow:(int)cell.row Column:(int)cell.column]) {
                [self.sudokuController deleteNumberAtRow:(int)self.selectedRow AndColumn:(int)self.selectedColumn];
                eventHandled = YES;
                NSDictionary *announcementInfo = @{NSAccessibilityAnnouncementKey : @"Deleted",
                                                   NSAccessibilityPriorityKey : @(NSAccessibilityPriorityHigh)};
                NSAccessibilityPostNotificationWithUserInfo(NSApp, NSAccessibilityAnnouncementRequestedNotification, announcementInfo);
            } else {
                NSDictionary *announcementInfo = @{NSAccessibilityAnnouncementKey : @"Can not delete",
                                                   NSAccessibilityPriorityKey : @(NSAccessibilityPriorityHigh)};
                NSAccessibilityPostNotificationWithUserInfo(NSApp, NSAccessibilityAnnouncementRequestedNotification, announcementInfo);
            }
            break;
        case KEY_LEFTARROW_CODE:
            [self moveFocusedCellByDeltaX:-1 DeltaY:0];
            eventHandled = YES;
            break;
        case KEY_RIGHTARROW_CODE:
            [self moveFocusedCellByDeltaX:+1 DeltaY:0];
            eventHandled = YES;
            break;
        case KEY_DOWNARROW_CODE:
            [self moveFocusedCellByDeltaX:0 DeltaY:-1];
            eventHandled = YES;
            break;
        case KEY_UPARROW_CODE:
            [self moveFocusedCellByDeltaX:0 DeltaY:+1];
            eventHandled = YES;
            break;
        default:
            break;
    }
    if (!eventHandled) {
        NSString *charString = [theEvent characters];
        unichar c = [charString characterAtIndex:0];
        if ('0' <= c && c <= '9') {
            cell = self.focusedCell;
            if ([self selectUnlessFixedCellAtRow:(int)cell.row Column:(int)cell.column]) {
                const int n = [self.sudokuBoard numberAtRow:(int)cell.row Column:(int)cell.column];
                if (n == 0) {
                    [self.sudokuController setNumber:c - '0' ForRow:(int)self.selectedRow AndColumn:(int)self.selectedColumn];
                    NSDictionary *announcementInfo = @{NSAccessibilityAnnouncementKey : @"Number entered",
                                                       NSAccessibilityPriorityKey : @(NSAccessibilityPriorityHigh)};
                    NSAccessibilityPostNotificationWithUserInfo(NSApp, NSAccessibilityAnnouncementRequestedNotification, announcementInfo);
                } else {
                    NSDictionary *announcementInfo = @{NSAccessibilityAnnouncementKey : @"Can not overwrite previous value",
                                                       NSAccessibilityPriorityKey : @(NSAccessibilityPriorityHigh)};
                    NSAccessibilityPostNotificationWithUserInfo(NSApp, NSAccessibilityAnnouncementRequestedNotification, announcementInfo);
                }
            } else {
                NSDictionary *announcementInfo = @{NSAccessibilityAnnouncementKey : @"Can not overwrite fixed cell",
                                                   NSAccessibilityPriorityKey : @(NSAccessibilityPriorityHigh)};
                NSAccessibilityPostNotificationWithUserInfo(NSApp, NSAccessibilityAnnouncementRequestedNotification, announcementInfo);
            }
        }
        
    }
}

-(void)selectNonFixedCell {
    for (int row = 8; row >= 0; row--) {
        for (int col = 0; col < 9; col++) {
            if (![self.sudokuBoard numberIsFixedAtRow:row Column:col]) {
                _selectedColumn = col;
                _selectedRow = row;
                return;
            }
        }
    }
    
}

#define MARGIN 3

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    const CGFloat gridWidth = self.bounds.size.width - 2*MARGIN;
    const CGFloat gridHeight = self.bounds.size.height - 2*MARGIN;
    
    if ((self.sudokuBoard != nil) && (_selectedRow < 0 || _selectedColumn < 0)) {
        [self selectNonFixedCell];
    }
    
    if (_selectedRow >= 0 || _selectedColumn >= 0) {
        [[NSColor lightGrayColor] setFill];
        const CGSize cellSize = NSMakeSize(gridWidth/9, gridHeight/9);
        [NSBezierPath fillRect:NSMakeRect(MARGIN + _selectedColumn*cellSize.width,
                                          MARGIN + _selectedRow*cellSize.height,
                                          cellSize.width, cellSize.height)];
    }

    //
    // Stroke outer square.
    //
    [[NSColor blackColor] setStroke];
    [NSBezierPath setDefaultLineWidth:2*MARGIN];
    [NSBezierPath strokeRect:CGRectMake(MARGIN, MARGIN,
                                        gridWidth, gridHeight)];
    
    //
    // Stroke internal boundary lines between 3x3 blocks.
    //
    [NSBezierPath strokeLineFromPoint:NSMakePoint(MARGIN + gridWidth/3, MARGIN)
                              toPoint:NSMakePoint(MARGIN + gridWidth/3, MARGIN + gridHeight)];
    [NSBezierPath strokeLineFromPoint:NSMakePoint(MARGIN + 2*gridWidth/3, MARGIN)
                              toPoint:NSMakePoint(MARGIN + 2*gridWidth/3, MARGIN + gridHeight)];
    [NSBezierPath strokeLineFromPoint:NSMakePoint(MARGIN, MARGIN + gridHeight/3)
                              toPoint:NSMakePoint(MARGIN + gridWidth, MARGIN + gridHeight/3)];
    [NSBezierPath strokeLineFromPoint:NSMakePoint(MARGIN, MARGIN + 2*gridHeight/3)
                              toPoint:NSMakePoint(MARGIN + gridWidth, MARGIN + 2*gridHeight/3)];
    
    [NSBezierPath setDefaultLineWidth:2];
    const CGFloat cellWidth = gridWidth/9;
    const CGFloat cellHeight = gridHeight/9;
    CGFloat x = MARGIN;
    CGFloat y = MARGIN;
    for (int c = 0; c < 9; c++) {
        if (c % 3 != 0) {
            [NSBezierPath strokeLineFromPoint:NSMakePoint(x, MARGIN)
                                      toPoint:NSMakePoint(x, MARGIN + gridHeight)];
            [NSBezierPath strokeLineFromPoint:NSMakePoint(MARGIN, y)
                                      toPoint:NSMakePoint(MARGIN + gridWidth, y)];
        }
        x += cellWidth;
        y += cellHeight;
    }
    
    //
    // Draw focused cell
    //
    AccessibilitySudokuCell *cell = self.focusedCell;
    [NSBezierPath setDefaultLineWidth:2.0];
    [[NSColor yellowColor] setStroke];
    [NSBezierPath strokeRect:CGRectMake(MARGIN + cell.column*cellWidth,
                                        MARGIN + cell.row*cellHeight,
                                        cellWidth, cellHeight)];
    
    //
    // Fill in numbers of board (if the model has been created).
    //
    if (self.sudokuBoard != nil) {
        NSDictionary *textAttributes = @{NSFontAttributeName: [NSFont systemFontOfSize:30.0],
                                         NSForegroundColorAttributeName : [NSColor blueColor]};
        NSDictionary *conflictingTextAttributes = @{NSFontAttributeName: [NSFont systemFontOfSize:30.0],
                                                    NSForegroundColorAttributeName : [NSColor redColor]};
        NSDictionary *fixedTextAttributes = @{NSFontAttributeName: [NSFont boldSystemFontOfSize:30.0],
                                              NSForegroundColorAttributeName : [NSColor blackColor]};
        
        for (int row = 0; row < 9; row++) {
            for (int col = 0; col < 9; col++) {
                const int num = [self.sudokuBoard numberAtRow:row Column:col];
                if (num > 0) {
                    const CGRect cellRect = CGRectMake(MARGIN + col*cellWidth, MARGIN + row*cellHeight,
                                                       cellWidth, cellHeight);
                    NSString *text = [NSString stringWithFormat:@"%d", num];
                    NSDictionary *attr;
                    if ([self.sudokuBoard numberIsFixedAtRow:row Column:col]) {
                        attr = fixedTextAttributes;
                    } else if ([self.sudokuBoard isConflictingEntryAtRow:row Column:col]) {
                        attr = conflictingTextAttributes;
                    } else {
                        attr = textAttributes;
                    }
                    const NSSize textSize = [text sizeWithAttributes:attr];
                    const NSRect textRect = NSMakeRect(cellRect.origin.x + (cellRect.size.width - textSize.width)/2,
                                                       cellRect.origin.y + (cellRect.size.height - textSize.height)/2,
                                                       textSize.width, textSize.height);
                    [text drawInRect:textRect withAttributes:attr];
                } // ignoring pencils (for now)
            }
        }
    }
}

-(BOOL)selectUnlessFixedCellAtRow:(int)row Column:(int)col {
    if (![self.sudokuBoard numberIsFixedAtRow:row Column:col] &&
        0 <= row && row < 9 && 0 <= col && col < 9) {
        NSLog(@"selected cell at row=%d, col=%d", row, col);
        if (row != _selectedRow || col != _selectedColumn) {
            _selectedColumn = col;
            _selectedRow = row;
            NSAccessibilityPostNotification(self,NSAccessibilitySelectedCellsChangedNotification);
            [self setNeedsDisplay:YES];
        }
        return YES;
    }
    return NO;
}

-(void)mouseDown:(NSEvent *)theEvent {
    const CGPoint point = [theEvent locationInWindow];
    const CGPoint viewPoint = [self convertPoint:point fromView:nil];
    
    const CGFloat gridWidth = self.bounds.size.width - 2*MARGIN;
    const CGFloat gridHeight = self.bounds.size.height - 2*MARGIN;
    
    const CGPoint gridPoint = CGPointMake((viewPoint.x - MARGIN)*9/gridWidth,
                                          (viewPoint.y - MARGIN)*9/gridHeight);
    const int col = (int) floorf(gridPoint.x);
    const int row = (int) floorf(gridPoint.y);
    [self selectUnlessFixedCellAtRow:row Column:col];
}

#pragma mark - accessibility

-(BOOL)accessibilityIsIgnored {
    return NO;
}

//
// Roles for grid
// http://goo.gl/j71yTa
//

-(NSArray*)accessibilityAttributeNames {
    static NSMutableArray *attributes = nil;
    if (attributes == nil) {
        attributes = [[super accessibilityAttributeNames] mutableCopy];
        NSArray *appendedAttributes =
        @[
          NSAccessibilityChildrenAttribute,
          NSAccessibilityColumnCountAttribute,
          NSAccessibilityEnabledAttribute,
          NSAccessibilityFocusedAttribute,
          NSAccessibilityOrderedByRowAttribute,
          // NSView : NSAccessibilityParentAttribute,
          // NSView : NSAccessibilityPositionAttribute,
          NSAccessibilityRoleAttribute,
          NSAccessibilityRoleDescriptionAttribute,
          NSAccessibilityRowCountAttribute,
          NSAccessibilitySelectedChildrenAttribute,
          // NSView : NSAccessibilitySizeAttribute,
          // NSView : NSAccessibilityTopLevelUIElementAttribute,
          NSAccessibilityVisibleChildrenAttribute,
          // NSview  : NSAccessibilityWindowAttribute,
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

-(NSArray*) accessibilityCells {
    if (_accessibilityCells == nil) {
        NSMutableArray *cells = [[NSMutableArray alloc] initWithCapacity:81];
        for (int r = 0; r < 9; r++) {
            for (int c = 0; c < 9; c++) {
                AccessibilitySudokuCell *cell = [[AccessibilitySudokuCell alloc] initWithRow:r Column:c];
                cell.sudokuBoard = self.sudokuBoard;
                cell.parent = self;
                [cells addObject:cell];
            }
        }
        _accessibilityCells = [NSArray arrayWithArray:cells];
    }
    return _accessibilityCells;
}

-(AccessibilitySudokuCell*)focusedCell {
    if (_focusedCell == nil) {
        _focusedCell = self.accessibilityCells[0];
    }
    return _focusedCell;
}

-(id)accessibilityAttributeValue:(NSString *)attribute {
    id value = nil;
    if ([attribute isEqualToString:NSAccessibilityChildrenAttribute]) {
        value = self.accessibilityCells;
    } else if ([attribute isEqualToString:NSAccessibilityColumnCountAttribute]) {
        value = @(9);
    } else if ([attribute isEqualToString:NSAccessibilityFocusedAttribute]) {
        // XXXX
    } else if ([attribute isEqualToString:NSAccessibilityOrderedByRowAttribute]) {
        value = @(YES);
    // XXX } else if ([attribute isEqualToString:NSAccessibilityParentAttribute]) {
        // XXXX
    // XXX } else if ([attribute isEqualToString:NSAccessibilityPositionAttribute]) {
        // XXX
    } else if ([attribute isEqualToString:NSAccessibilityRoleAttribute]) {
        value = NSAccessibilityGridRole;
    } else if ([attribute isEqualToString:NSAccessibilityRowCountAttribute]) {
        value = @(9);
    } else if ([attribute isEqualToString:NSAccessibilitySelectedChildrenAttribute]) {
        // XXX
    // XXX } else if ([attribute isEqualToString:NSAccessibilitySizeAttribute]) {
        // XXX value = [NSValue valueWithSize:self.bounds.size];
    // XXX } else if ([attribute isEqualToString:NSAccessibilityTopLevelUIElementAttribute]) {
        // XXX
    } else if ([attribute isEqualToString:NSAccessibilityVisibleChildrenAttribute]) {
        value = self.accessibilityCells;
    // XXX } else if ([attribute isEqualToString:NSAccessibilityWindowAttribute]) {
        // XXX return self.window;
    } else if ([attribute isEqualToString:NSAccessibilityHelpAttribute]) {
        return @"Sudoku 9x9 grid";
    }
    if (value == nil) {
        return [super accessibilityAttributeValue:attribute];
    }
    return value;
}

- (BOOL)accessibilityIsAttributeSettable:(NSString *)attribute {
    return NO; // XXX
}


- (void)accessibilitySetValue:(id)value
                 forAttribute:(NSString *)attribute {
    // XXX
}

-(id)accessibilityHitTest:(NSPoint)point {
    const NSPoint windowPoint = [self.window convertScreenToBase:point];
    const NSPoint viewPoint = [self convertPoint:windowPoint fromView:nil];
    const CGFloat gridWidth = self.bounds.size.width - 2*MARGIN;
    const CGFloat gridHeight = self.bounds.size.height - 2*MARGIN;
    const CGPoint gridPoint = CGPointMake((viewPoint.x - MARGIN)*9/gridWidth,
                                          (viewPoint.y - MARGIN)*9/gridHeight);
    const int col = (int) floorf(gridPoint.x);
    const int row = (int) floorf(gridPoint.y);
    if (0 <= row && row < 9 && 0 <= col && col < 9) {
        return self.accessibilityCells[row*9 + col];
    }
    return self;
}

- (id)accessibilityFocusedUIElement {
    return self.focusedCell;
}

-(CGPoint)screenPositionOfCellAtRow:(NSInteger)row  AndColumn:(NSInteger)col {
    const CGFloat gridWidth = self.bounds.size.width - 2*MARGIN;
    const CGFloat gridHeight = self.bounds.size.height - 2*MARGIN;
    const CGSize cellSize = CGSizeMake(gridWidth/9, gridHeight/9);
    const CGPoint viewPoint = CGPointMake(MARGIN + col*cellSize.width, MARGIN + row*cellSize.height);
    const CGPoint windowPoint = [self convertPoint:viewPoint toView:nil];
    const CGRect windowRect = CGRectMake(windowPoint.x, windowPoint.y, cellSize.width, cellSize.height);
    const CGRect screenRect = [self.window convertRectToScreen:windowRect];
    return screenRect.origin;
}

-(CGSize)screenSizeOfCell {
    const CGFloat gridWidth = self.bounds.size.width - 2*MARGIN;
    const CGFloat gridHeight = self.bounds.size.height - 2*MARGIN;
    return CGSizeMake(gridWidth/9, gridHeight/9);
}


@end
