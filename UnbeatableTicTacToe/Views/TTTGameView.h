//
//  TTTGameView.h
//  UnbeatableTicTacToe
//
//  Created by Charlie Weill on 12/8/14.
//  Copyright (c) 2014 Charlie Weill. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TTTGameState;
@class TTTGameView;

@protocol TTTGameViewDelegate <NSObject>

- (void)gameView:(TTTGameView *)gameView didTapTile:(NSUInteger)tile;

@end

@interface TTTGameView : UIView

@property (weak, nonatomic) id <TTTGameViewDelegate> delegate;

- (void)drawGameState:(TTTGameState *)state;

- (void)reset;

@end
