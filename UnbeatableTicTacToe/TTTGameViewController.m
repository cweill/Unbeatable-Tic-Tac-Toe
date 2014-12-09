//
//  TTTGameViewController.m
//  UnbeatableTicTacToe
//
//  Created by Charlie Weill on 12/8/14.
//  Copyright (c) 2014 Charlie Weill. All rights reserved.
//

#import "TTTGameViewController.h"
#import "TTTGameView.h"
#import "TTTGameState.h"

@interface TTTGameViewController () <TTTGameViewDelegate>

@property (strong, nonatomic) TTTGameState *gameTree;
@property (strong, nonatomic) TTTGameState *currentState;
@property (strong, nonatomic) TTTGameView *gameView;
@property (strong, nonatomic) UIButton *resetButton;

@end

@implementation TTTGameViewController

- (instancetype)init {
  self = [super init];
  if (self) {
    _gameTree = [TTTGameState new];
    _currentState = _gameTree;
  }
  return self;
}

- (void)loadView{
  self.view = [UIView new];
  _gameView = [TTTGameView new];
  _gameView.delegate = self;
  
  _resetButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [_resetButton setTitle:@"Reset" forState:UIControlStateNormal];
  [_resetButton addTarget:self
                   action:@selector(resetGame)
         forControlEvents:UIControlEventTouchUpInside];
  
  [self.view addSubview:_gameView];
  [self.view addSubview:_resetButton];
  
  [self resetGame];
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
  
  CGFloat gameDimension = self.view.frame.size.width - 30;
  
  _gameView.frame = CGRectMake(15, 64, gameDimension, gameDimension);
  
  _resetButton.frame = CGRectMake(0,
                                  self.view.frame.size.height - 80,
                                  self.view.frame.size.width,
                                  80);
}

- (void)gameView:(TTTGameView *)gameView didTapTile:(NSUInteger)tile {
  TTTGameState *nextState = [_currentState makeMove:tile];
  if (nextState) {
    _currentState = nextState;
    [gameView drawGameState:nextState];
    
    if (nextState.status != TTTGameStatusInPlay) {
      _resetButton.hidden = NO;
    }
  }
}

- (void)resetGame {
  [_gameView reset]; // Reset view
  _currentState = _gameTree; // Reset game state
  _resetButton.hidden = YES;
}

@end
