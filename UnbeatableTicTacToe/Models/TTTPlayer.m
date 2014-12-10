//
//  TTTPlayer.m
//  UnbeatableTicTacToe
//
//  Created by Charlie Weill on 12/9/14.
//  Copyright (c) 2014 Charlie Weill. All rights reserved.
//

#import "TTTPlayer.h"

@implementation TTTPlayer

- (instancetype)initWithLetter:(NSString *)letter {
  self = [self init];
  if (self) {
    _letter = letter;
  }
  return self;
}

@end
