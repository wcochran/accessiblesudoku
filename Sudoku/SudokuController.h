//
//  SudokuController.h
//  Sudoku
//
//  Created by Wayne O. Cochran on 4/18/14.
//  Copyright (c) 2014 WSUV. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SudokuView;
@class SudokuBoard;

@interface SudokuController : NSObject

@property (strong, nonatomic) SudokuBoard *sudokuBoard;

@property (weak) IBOutlet SudokuView *sudokuView;
@property (weak) IBOutlet NSMatrix *buttonMatrix;
- (IBAction)buttonMatrixClicked:(NSMatrix *)sender;
@property (unsafe_unretained) IBOutlet NSWindow *optionWindow;
@property (unsafe_unretained) IBOutlet NSWindow *mainWindow;

- (IBAction)cancelOptionWindow:(id)sender;
- (IBAction)newGame:(id)sender;

-(void)setNumber:(int)num ForRow:(int)row AndColumn:(int)col;
-(void)deleteNumberAtRow:(int)row AndColumn:(int)col;

@end
