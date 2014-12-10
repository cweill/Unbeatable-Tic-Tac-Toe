//
//  TTTPlayerAI.m
//  UnbeatableTicTacToe
//
//  Created by Charlie Weill on 12/9/14.
//  Copyright (c) 2014 Charlie Weill. All rights reserved.
//

#import "TTTPlayerAI.h"
#import "TTTGameState.h"

@implementation TTTPlayerAI

- (TTTGameState *)bestMoveForGameState:(TTTGameState *)state {
  // If first player to go, play anything to speed up game
  if ([state isNewGame]) {
    return [state makeMove:arc4random_uniform(9)];
  }
  
  // Min max algorithm to determine the best next move for the given player
  TTTGameState *bestMove;
  int bestRank = -99;
  for (TTTGameState *move in [state moves].allValues) {
    int rank = [self minMaxForForGameState:move];
    if (rank > bestRank) {
      bestMove = move;
      bestRank = rank;
    }
  }
  return bestMove;
}

- (int)minMaxForForGameState:(TTTGameState *)state{
  if (state.status != TTTGameStatusInPlay) {
    return [self rankForGameState:state];
  }
  
  NSMutableArray *ranks = [NSMutableArray new];
  for (TTTGameState *move in [state moves].allValues) {
    int rank = [self minMaxForForGameState:move];
    [ranks addObject:[NSNumber numberWithInt:rank]];
  }
  
  int bestRank = [ranks.firstObject intValue];
  for (NSNumber *rank in ranks) {
    int currentRank = [rank intValue];
    if (self == state.currentPlayer) { // MAX
      if (currentRank > bestRank) {
        bestRank = currentRank;
      }
    } else { // MIN
      if (currentRank < bestRank) {
        bestRank = currentRank;
      }
    }
  }
  return bestRank;
}

- (int)rankForGameState:(TTTGameState *)state{
  switch (state.status) {
    case TTTGameStatusDraw:
      return 0;
    case TTTGameStatusPlayerXWon:
      return self == state.playerX ? 10 : - 10;
    case TTTGameStatusPlayerOWon:
      return self == state.playerO ? 10 : - 10;
    default:
      return 0;
  }
}

@end
