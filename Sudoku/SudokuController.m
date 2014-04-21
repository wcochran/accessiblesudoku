//
//  SudokuController.m
//  Sudoku
//
//  Created by Wayne O. Cochran on 4/18/14.
//  Copyright (c) 2014 WSUV. All rights reserved.
//

#import "SudokuController.h"
#import "SudokuBoard.h"

@implementation SudokuController

-(void)awakeFromNib {
    self.sudokuBoard = [[SudokuBoard alloc] init];
}

#define DELETE_TAG 10   // tag's defined in IB
#define PENCIL_TAG 11
#define MENU_TAG 12

- (IBAction)buttonMatrixClicked:(NSMatrix *)sender {
    NSButtonCell *bcell = [sender selectedCell];
    NSLog(@"%d", (int) bcell.tag);
    
    
    if (bcell.tag == MENU_TAG) {
        [NSApp beginSheet:self.optionWindow modalForWindow:self.mainWindow modalDelegate:nil didEndSelector:NULL contextInfo:NULL];
    }
}

- (IBAction)cancelOptionWindow:(id)sender {
    [NSApp endSheet:self.optionWindow];
    [self.optionWindow orderOut:sender];
}

- (IBAction)newGame:(id)sender {
    NSLog(@"newGame: %d", (int)[sender tag]);
    
    //
    // Create and load new game (level based on tag = 1,2,3,4)
    //
    
    if ([self.optionWindow isVisible]) {
        [NSApp endSheet:self.optionWindow];
        [self.optionWindow orderOut:sender];
    }
}

@end
