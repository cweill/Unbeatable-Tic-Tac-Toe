//
//  TTTGameState.m
//  UnbeatableTicTacToe
//
//  Created by Charlie Weill on 12/8/14.
//  Copyright (c) 2014 Charlie Weill. All rights reserved.
//

#import "TTTGameState.h"

@interface TTTGameState ()

@end

@implementation TTTGameState

- (instancetype)init {
  self = [super init];
  if (self) {
    _state = @[@"", @"", @"", @"", @"", @"", @"", @"", @""];
    _currentPlayer = @"X";
  }
  [self determineMoves];
  
  return self;
}

- (instancetype)initWithState:(NSArray *)state player:(NSString *)player {
  self = [super init];
  if (self) {
    _state = state;
    _currentPlayer = player;
  }
  [self determineMoves];
  
  return self;
}

- (void)determineMoves {
  NSMutableDictionary *temp = [NSMutableDictionary new];
  for (int i = 0; i< _state.count; i++) {
    if ([@"" isEqualToString:_state[i]]) {
      NSString *nextPlayer = [_currentPlayer isEqualToString:@"X"] ? @"O" : @"X";
      NSMutableArray *nextState = [_state mutableCopy];
      nextState[i] = _currentPlayer;
      TTTGameState *newState = [[TTTGameState alloc] initWithState:nextState player:nextPlayer];
      temp[@(i)] = newState;
    }
  }
  _moves = temp;
}

@end
