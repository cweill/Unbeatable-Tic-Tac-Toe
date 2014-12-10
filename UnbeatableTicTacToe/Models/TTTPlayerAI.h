//
//  TTTPlayerAI.h
//  UnbeatableTicTacToe
//
//  Created by Charlie Weill on 12/9/14.
//  Copyright (c) 2014 Charlie Weill. All rights reserved.
//

#import "TTTPlayer.h"

@class TTTGameState;

@interface TTTPlayerAI : TTTPlayer

- (TTTGameState *)bestMoveForGameState:(TTTGameState *)state;

@end
