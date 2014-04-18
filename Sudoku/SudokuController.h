//
//  SudokuController.h
//  Sudoku
//
//  Created by Wayne O. Cochran on 4/18/14.
//  Copyright (c) 2014 WSUV. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SudokuView;

@interface SudokuController : NSObject
@property (weak) IBOutlet SudokuView *sudokuView;
@property (weak) IBOutlet NSMatrix *buttonMatrix;
- (IBAction)buttonMatrixClicked:(NSMatrix *)sender;

@end
