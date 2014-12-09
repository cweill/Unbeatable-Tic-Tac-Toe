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
  [self.view addSubview:_gameView];
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
  
  _gameView.frame = self.view.frame;
}

- (void)gameView:(TTTGameView *)gameView didTapTile:(NSUInteger)tile {
  TTTGameState *nextState = _currentState.moves[@(tile)];
  if (nextState) {
    _currentState = nextState;
    [gameView drawGameState:nextState];
  }
}

@end
