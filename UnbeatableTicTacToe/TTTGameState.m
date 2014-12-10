//
//  TTTGameState.m
//  UnbeatableTicTacToe
//
//  Created by Charlie Weill on 12/8/14.
//  Copyright (c) 2014 Charlie Weill. All rights reserved.
//

#import "TTTGameState.h"

@interface TTTGameState ()

@property (copy, nonatomic) NSArray *state;
@property (copy, nonatomic) NSString *currentPlayer;
@property (nonatomic) enum TTTGameStateStatus status;

@end

@implementation TTTGameState

- (instancetype)init {
  self = [super init];
  if (self) {
    _state = @[@"", @"", @"", @"", @"", @"", @"", @"", @""];
    _currentPlayer = @"X";
    _status = TTTGameStatusInPlay;
  }
  
  return self;
}

- (instancetype)initWithState:(NSArray *)state player:(NSString *)player {
  self = [super init];
  if (self) {
    _state = state;
    _currentPlayer = player;
  }
  _status = [self determineStatus];
  
  return self;
}

- (enum TTTGameStateStatus)determineStatus {
  if ([self didPlayerWin:@"X"]) {
    return TTTGameStatusPlayerXWon;
  } else if ([self didPlayerWin:@"O"]) {
    return TTTGameStatusPlayerOWon;
  } else if ([self canStillMove]) {
    return TTTGameStatusInPlay;
  } else {
    return TTTGameStatusDraw;
  }
}

- (BOOL)didPlayerWin:(NSString *)player {
  // Horizontal
  for (int i = 0; i < 3; i++) {
    if ([_state[i * 3] isEqualToString:player] &&
        [_state[1 + i * 3] isEqualToString:player] &&
        [_state[2 + i * 3] isEqualToString:player]) {
      return true;
    }
  }
  
  // Vertical
  for (int i = 0; i < 3; i++) {
    if ([_state[i] isEqualToString:player] &&
        [_state[i + 3] isEqualToString:player] &&
        [_state[i + 6] isEqualToString:player]) {
      return true;
    }
  }
  
  // Diagonal
  if ([_state[0] isEqualToString:player] &&
      [_state[4] isEqualToString:player] &&
      [_state[8] isEqualToString:player]) {
    return true;
  } else if ([_state[2] isEqualToString:player] &&
      [_state[4] isEqualToString:player] &&
      [_state[6] isEqualToString:player]) {
    return true;
  }
  return false;
}

- (BOOL)canStillMove {
  for (NSString *move in _state) {
    if ([move isEqualToString:@""]) {
      return true;
    }
  }
  return false;
}

// Valid moves. The keys are the indeces of the tiles and the values are the next state
- (NSDictionary *)moves {
  NSMutableDictionary *temp = [NSMutableDictionary new];
  if (_status == TTTGameStatusInPlay) {
    for (int i = 0; i< _state.count; i++) {
      if ([@"" isEqualToString:_state[i]]) {
        NSString *nextPlayer = [_currentPlayer isEqualToString:@"X"] ? @"O" : @"X";
        NSMutableArray *nextState = [_state mutableCopy];
        nextState[i] = _currentPlayer;
        TTTGameState *newState = [[TTTGameState alloc] initWithState:nextState player:nextPlayer];
        temp[@(i)] = newState;
      }
    }
  }
  return temp;
}

- (TTTGameState *)makeMove:(NSUInteger)move {
  return [self moves][@(move)];
}

- (TTTGameState *)bestMove {
  // Min max algorithm to determine the best next move for the given player
  TTTGameState *bestMove;
  int bestRank = -99;
  for (TTTGameState *move in [self moves].allValues) {
    int rank = [move minMaxForPlayer:_currentPlayer depth:0];
    if (rank > bestRank) {
      bestMove = move;
      bestRank = rank;
    }
  }
  return bestMove;
}

- (int)minMaxForPlayer:(NSString *)player depth:(int)depth {
  if (_status != TTTGameStatusInPlay) {
    return [self rankForPlayer:player depth:depth];
  }
  
  NSMutableArray *ranks = [NSMutableArray new];
  for (TTTGameState *move in [self moves].allValues) {
    int rank = [move minMaxForPlayer:player depth:depth + 1];
    [ranks addObject:[NSNumber numberWithInt:rank]];
  }
  
  int bestRank = [ranks.firstObject intValue];
  for (NSNumber *rank in ranks) {
    int currentRank = [rank intValue];
    if ([player isEqualToString:_currentPlayer]) {
      if (currentRank > bestRank) {
        bestRank = currentRank;
      }
    } else {
      if (currentRank < bestRank) {
        bestRank = currentRank;
      }
    }
  }
  return bestRank;
}

- (int)rankForPlayer:(NSString *)player depth:(int)depth {
  switch (_status) {
    case TTTGameStatusDraw:
      return 0;
    case TTTGameStatusPlayerXWon:
      return [player isEqualToString:@"X"] ? 10 - depth : depth - 10;
    case TTTGameStatusPlayerOWon:
      return [player isEqualToString:@"O"] ? 10 - depth : depth - 10;
    default:
      return 0;
  }
}

@end
