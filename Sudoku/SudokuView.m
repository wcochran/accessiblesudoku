//
//  SudokuView.m
//  Sudoku
//
//  Created by Wayne O. Cochran on 4/16/14.
//  Copyright (c) 2014 WSUV. All rights reserved.
//

#import "SudokuView.h"

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

#define MARGIN 3

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    const CGFloat gridWidth = self.bounds.size.width - 2*MARGIN;
    const CGFloat gridHeight = self.bounds.size.height - 2*MARGIN;
//    const CGPoint gridOrigin = NSMakePoint(MARGIN, MARGIN);
    
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
    if (0 <= row && row < 9 && 0 <= col && col < 9) {
        NSLog(@"row=%d, col=%d", row, col);
        if (row != _selectedRow || col != _selectedColumn) {
            _selectedColumn = col;
            _selectedRow = row;
            [self setNeedsDisplay:YES];
        }
    }
}

@end
