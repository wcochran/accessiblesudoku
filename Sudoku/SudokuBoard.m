//
//  SudokuBoard.m
//  MySudoku
//
//  Created by Wayne Cochran on 1/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SudokuBoard.h"

typedef struct {
    char number;
    BOOL isFixed;
    short pencilMask;
} Cell;

@interface SudokuBoard () {
@private
    Cell cells[9][9];
}

-(void)clear;
@end

@implementation SudokuBoard

-(id)init {
    if (self = [super init]) {
        [self clear];
    }
    return self;
}

-(void)clear {
    for (int row = 0; row < 9; row++) {
        for (int col = 0; col < 9; col++) {
            Cell *cell = &cells[row][col];
            cell->number = 0;
            cell->isFixed = NO;
            cell->pencilMask = 0;
        }
    }   
}

-(void)freshGame:(NSString*)boardString {
    int n = 0;
    for (int row = 0; row < 9; row++) {
        for (int col = 0; col < 9; col++) {
            Cell *cell = &cells[row][col];
            const unichar c = [boardString characterAtIndex:n++];
            if ('1' <= c && c <= '9') {
                const int num = c - '0';
                cell->number = num;
                cell->isFixed = YES;
            } else {
                cell->number = 0;
                cell->isFixed = NO;
            }
            cell->pencilMask = 0;
        }
    }
}

-(int)numberAtRow:(int)r Column:(int)c {
    return cells[r][c].number;
}

-(BOOL)numberIsFixedAtRow:(int)r Column:(int)c {
    return cells[r][c].isFixed;
}

-(void)setNumber:(int)n AtRow:(int)r Column:(int)c {
    cells[r][c].number = n;
}

-(BOOL)anyPencilsSetAtRow:(int)r Column:(int)c {
    return cells[r][c].pencilMask != 0;
}

-(int)numberOfPencilsSetAtRow:(int)r Column:(int)c {
    const int mask = cells[r][c].pencilMask;
    int count = 0;
    for (int bit = 0; bit < 9; bit++)
        if ((1 << bit) & mask)
            count++;
    return count;
}

-(BOOL)isSetPencil:(int)n AtRow:(int)r Column:(int)c {
    return (cells[r][c].pencilMask & (1 << (n-1))) != 0;
}

-(void)setPencil:(int)n AtRow:(int)r Column:(int)c {
    cells[r][c].pencilMask |= 1 << (n-1);
}

-(void)clearPencil:(int)n AtRow:(int)r Column:(int)c {
    cells[r][c].pencilMask &= ~(1 << (n-1));
}

-(void)clearAllPencilsAtRow:(int)r Column:(int)c {
    cells[r][c].pencilMask = 0;
}

-(BOOL)isConflictingEntryAtRow:(int)r Column:(int)c {
    if (cells[r][c].isFixed)
        return NO;
    
    const int number = cells[r][c].number;
    
    if (number == 0) 
        return NO;
    
    for (int col = 0; col < 9; col++) {  // scan row r
        if (col == c) continue;
        const int n = cells[r][col].number;
        if (n == number)
            return YES;
    }
    
    for (int row = 0; row < 9; row++) {  // scan col c
        if (row == r) continue;
        const int n = cells[row][c].number;
        if (n == number)
            return YES;
    }
    
    const int blockRow = (r/3)*3;  // scan 3x3 block
    const int blockCol = (c/3)*3;
    for (int j = 0; j < 3; j++) {
        for (int i = 0; i < 3; i++) {
            const int row = blockRow + j;
            const int col = blockCol + i;
            if (row == r && col == c)
                continue;
            const int n = cells[row][col].number;
            if (n == number)
                return YES;
        }
    }
    
    return NO;
}

@end
