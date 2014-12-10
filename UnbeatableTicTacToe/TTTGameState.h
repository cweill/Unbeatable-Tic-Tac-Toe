//
//  TTTGameState.h
//  UnbeatableTicTacToe
//
//  Created by Charlie Weill on 12/8/14.
//  Copyright (c) 2014 Charlie Weill. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTTPlayer.h"

@interface TTTGameState : NSObject

enum TTTGameStateStatus : NSUInteger {
  TTTGameStatusInPlay = 1,
  TTTGameStatusPlayerXWon = 2,
  TTTGameStatusPlayerOWon = 3,
  TTTGameStatusDraw = 4
};

@property (strong, nonatomic, readonly) TTTPlayer *playerX;
@property (strong, nonatomic, readonly) TTTPlayer *playerO;
@property (copy, nonatomic, readonly) NSArray *state; // The board represented as an array of size 9
@property (strong, nonatomic, readonly) TTTPlayer *currentPlayer;
@property (nonatomic, readonly) enum TTTGameStateStatus status;

- (instancetype)initWithPlayerX:(TTTPlayer *)playerX playerO:(TTTPlayer *)playerO;

- (TTTGameState *)makeMove:(NSUInteger)move;

- (TTTGameState *)bestMove;

// Valid moves. The keys are the indeces of the tiles and the values are the next state
- (NSDictionary *)moves;

@end
