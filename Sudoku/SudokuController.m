//
//  SudokuController.m
//  Sudoku
//
//  Created by Wayne O. Cochran on 4/18/14.
//  Copyright (c) 2014 WSUV. All rights reserved.
//

#import "SudokuController.h"

@implementation SudokuController

- (IBAction)buttonMatrixClicked:(NSMatrix *)sender {
    NSButtonCell *bcell = [sender selectedCell];
    NSLog(@"%d", (int) bcell.tag);
}

@end
