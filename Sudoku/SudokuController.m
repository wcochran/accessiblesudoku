//
//  SudokuController.m
//  Sudoku
//
//  Created by Wayne O. Cochran on 4/18/14.
//  Copyright (c) 2014 WSUV. All rights reserved.
//

#import "SudokuController.h"
#import "SudokuBoard.h"
#import "SudokuView.h"

@implementation SudokuController

-(void)loadNewGame:(int)gameLevel {  //0 => easy, .. 3 => expert
    NSAssert(0 <= gameLevel && gameLevel < 4, @"invalid game level %d", gameLevel);
    static NSString *levelNames[] = {
        @"easy", @"simple", @"intermediate", @"expert"
    };
    NSString *fileName = [NSString stringWithFormat:@"sudoku-%@", levelNames[gameLevel]];
    NSString *pathName = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    NSArray *games = [NSArray arrayWithContentsOfFile:pathName];
    NSString *game = [games objectAtIndex:arc4random() % games.count];
    [self.sudokuBoard freshGame:game];
    [self.sudokuView setNeedsDisplay:YES];
}

-(void)awakeFromNib {
    self.sudokuBoard = [[SudokuBoard alloc] init];
    self.sudokuView.sudokuBoard = self.sudokuBoard;
    [self loadNewGame:0]; // start with new easy puzzle
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
    [self loadNewGame:(int)[sender tag] - 1];
    
    if ([self.optionWindow isVisible]) {
        [NSApp endSheet:self.optionWindow];
        [self.optionWindow orderOut:sender];
    }
}

@end
