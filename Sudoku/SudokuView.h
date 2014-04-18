//
//  SudokuView.h
//  Sudoku
//
//  Created by Wayne O. Cochran on 4/16/14.
//  Copyright (c) 2014 WSUV. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SudokuView : NSView

@property (readonly, nonatomic) NSInteger selectedRow;
@property (readonly, nonatomic) NSInteger selectedColumn;

@end
