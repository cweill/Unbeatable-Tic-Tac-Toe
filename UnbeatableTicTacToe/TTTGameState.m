//
//  TTTGameState.m
//  UnbeatableTicTacToe
//
//  Created by Charlie Weill on 12/8/14.
//  Copyright (c) 2014 Charlie Weill. All rights reserved.
//

#import "TTTGameState.h"

@interface TTTGameState ()

@property (strong, nonatomic) TTTPlayer *playerX;
@property (strong, nonatomic) TTTPlayer *playerO;
@property (copy, nonatomic) NSArray *state;
@property (strong, nonatomic) TTTPlayer *currentPlayer;
@property (nonatomic) enum TTTGameStateStatus status;

@end

@implementation TTTGameState

- (instancetype)init {
  self = [super init];
  if (self) {
    // The board
    _state = @[[NSNull null], [NSNull null], [NSNull null],
               [NSNull null], [NSNull null], [NSNull null],
               [NSNull null], [NSNull null], [NSNull null]];
    _status = TTTGameStatusInPlay;
  }
  
  return self;
}

- (instancetype)initWithPlayerX:(TTTPlayer *)playerX playerO:(TTTPlayer *)playerO {
  self = [self init];
  if (self) {
    _currentPlayer = playerX;
    _playerO = playerO;
    _playerX = playerX;
  }
  
  return self;
}

- (instancetype)initWithPlayerX:(TTTPlayer *)playerX
                        playerO:(TTTPlayer *)playerO
                          state:(NSArray *)state
                  currentPlayer:(TTTPlayer *)currentPlayer {
  self = [self initWithPlayerX:playerX playerO:playerO];
  if (self) {
    _state = state;
    _currentPlayer = currentPlayer;
  }
  _status = [self determineStatus];
  
  return self;
}

- (enum TTTGameStateStatus)determineStatus {
  if ([self didPlayerWin:_playerX]) {
    return TTTGameStatusPlayerXWon;
  } else if ([self didPlayerWin:_playerO]) {
    return TTTGameStatusPlayerOWon;
  } else if ([self canStillMove]) {
    return TTTGameStatusInPlay;
  } else {
    return TTTGameStatusDraw;
  }
}

- (BOOL)didPlayerWin:(TTTPlayer *)player {
  // Horizontal
  for (int i = 0; i < 3; i++) {
    if (_state[i * 3] == player &&
        _state[1 + i * 3] == player &&
        _state[2 + i * 3] == player) {
      return true;
    }
  }
  
  // Vertical
  for (int i = 0; i < 3; i++) {
    if (_state[i] == player &&
        _state[i + 3] == player &&
        _state[i + 6] == player) {
      return true;
    }
  }
  
  // Diagonal
  if (_state[0] == player &&
      _state[4] == player &&
      _state[8] == player) {
    return true;
  } else if (_state[2] == player &&
      _state[4] == player &&
      _state[6] == player) {
    return true;
  }
  return false;
}

- (BOOL)canStillMove {
  for (NSString *move in _state) {
    if ([[NSNull null] isEqual:move]) {
      return true;
    }
  }
  return false;
}

- (NSDictionary *)moves {
  NSMutableDictionary *temp = [NSMutableDictionary new];
  if (_status == TTTGameStatusInPlay) {
    for (int i = 0; i< _state.count; i++) {
      if ([[NSNull null] isEqual:_state[i]]) { // Valid move
        TTTPlayer *nextPlayer = _currentPlayer == _playerX ? _playerO : _playerX;
        NSMutableArray *nextState = [_state mutableCopy];
        nextState[i] = _currentPlayer;
        TTTGameState *newState = [[TTTGameState alloc] initWithPlayerX:_playerX
                                                               playerO:_playerO
                                                                 state:nextState
                                                         currentPlayer:nextPlayer];
        temp[@(i)] = newState;
      }
    }
  }
  return temp;
}

- (TTTGameState *)makeMove:(NSUInteger)move {
  return [self moves][@(move)];
}

- (BOOL)isNewGame {
  return [self moves].count == 9;
}

@end
