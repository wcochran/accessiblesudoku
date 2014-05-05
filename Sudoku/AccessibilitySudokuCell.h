//
//  AccessibilitySudokuCell.h
//  Sudoku
//
//  Created by Wayne Cochran on 4/24/14.
//  Copyright (c) 2014 WSUV. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SudokuBoard;
@class SudokuView;

@interface AccessibilitySudokuCell : NSObject

@property (weak, nonatomic) SudokuBoard *sudokuBoard;
@property (weak, nonatomic) SudokuView *parent; // parent accessibility element

@property (assign, readonly, nonatomic) NSInteger row;
@property (assign, readonly, nonatomic) NSInteger column;

-(id)initWithRow:(NSInteger)row Column:(NSInteger)col;

@end
