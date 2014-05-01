//
//  SudokuView.h
//  Sudoku
//
//  Created by Wayne O. Cochran on 4/16/14.
//  Copyright (c) 2014 WSUV. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SudokuBoard;
@class SudokuController;

@interface SudokuView : NSView

@property (assign, nonatomic) NSInteger selectedRow;
@property (assign, nonatomic) NSInteger selectedColumn;

@property (weak, nonatomic) SudokuBoard *sudokuBoard;  // model (created in controller)
@property (weak, nonatomic) SudokuController *sudokuController; // set by controller

@property (strong, nonatomic) NSArray *accessibilityCells;

//
// Methods needed by AccessibilitySudokuCell
//
-(CGPoint)screenPositionOfCellAtRow:(NSInteger)row  AndColumn:(NSInteger)col;
-(CGSize)screenSizeOfCell;

@end
