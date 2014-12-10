//
//  TTTPlayer.h
//  UnbeatableTicTacToe
//
//  Created by Charlie Weill on 12/9/14.
//  Copyright (c) 2014 Charlie Weill. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTTPlayer : NSObject

@property (copy, nonatomic) NSString *letter;

- (instancetype)initWithLetter:(NSString *)letter;

@end
