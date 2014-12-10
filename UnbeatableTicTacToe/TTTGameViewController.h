//
//  TTTGameViewController.h
//  UnbeatableTicTacToe
//
//  Created by Charlie Weill on 12/8/14.
//  Copyright (c) 2014 Charlie Weill. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TTTGameState;

@interface TTTGameViewController : UIViewController

- (instancetype)initWithGameState:(TTTGameState *)state;

@end
