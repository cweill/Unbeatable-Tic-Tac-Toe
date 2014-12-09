//
//  TTTGameState.h
//  UnbeatableTicTacToe
//
//  Created by Charlie Weill on 12/8/14.
//  Copyright (c) 2014 Charlie Weill. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTTGameState : NSObject

enum TTTGameStateStatus : NSUInteger {
  TTTGameStatusInPlay = 1,
  TTTGameStatusPlayerXWon = 2,
  TTTGameStatusPlayerOWon = 3,
  TTTGameStatusDraw = 4
};

@property (copy, nonatomic, readonly) NSArray *state;
@property (copy, nonatomic, readonly) NSString *currentPlayer;
@property (nonatomic, readonly) enum TTTGameStateStatus status;

- (TTTGameState *)makeMove:(NSUInteger)move;

@end
