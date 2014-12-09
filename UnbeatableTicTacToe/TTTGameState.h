//
//  TTTGameState.h
//  UnbeatableTicTacToe
//
//  Created by Charlie Weill on 12/8/14.
//  Copyright (c) 2014 Charlie Weill. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTTGameState : NSObject

@property (copy, nonatomic) NSArray *state;
@property (copy, nonatomic) NSString *currentPlayer;
@property (copy, nonatomic) NSDictionary *moves;

@end
