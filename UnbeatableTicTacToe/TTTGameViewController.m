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

@property (strong, nonatomic) TTTGameState *gameTree; // The game tree - each node is a game state
@property (strong, nonatomic) TTTGameState *currentState; // Current node in game state tree
@property (strong, nonatomic) TTTGameView *gameView;
@property (strong, nonatomic) UIButton *resetButton;
@property (strong, nonatomic) UILabel *gameStatusLabel;

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
  
  _gameStatusLabel = [UILabel new];
  _gameStatusLabel.textAlignment = NSTextAlignmentCenter;
  
  _resetButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [_resetButton setTitle:@"Reset" forState:UIControlStateNormal];
  [_resetButton addTarget:self
                   action:@selector(resetGame)
         forControlEvents:UIControlEventTouchUpInside];
  
  [self.view addSubview:_gameView];
  [self.view addSubview:_gameStatusLabel];
  [self.view addSubview:_resetButton];
  
  [self resetGame];
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
  
  CGFloat gameDimension = self.view.frame.size.width - 30;
  
  _gameView.frame = CGRectMake(15, 64, gameDimension, gameDimension);
  
  _gameStatusLabel.frame = CGRectMake(0,
                                      CGRectGetMaxY(_gameView.frame) + 15,
                                      self.view.frame.size.width,
                                      20);
  
  _resetButton.frame = CGRectMake(0,
                                  self.view.frame.size.height - 80,
                                  self.view.frame.size.width,
                                  80);
}

- (void)gameView:(TTTGameView *)gameView didTapTile:(NSUInteger)tile {
  TTTGameState *nextState = [_currentState makeMove:tile];
  [self displayNextState:nextState];
  [self playAI];
}

- (void)playAI {
  if (_currentState.status == TTTGameStatusInPlay) {
    [self displayNextState:[_currentState bestMove]];
  }
}

- (void)displayNextState:(TTTGameState *)nextState {
  if (nextState) {
    _currentState = nextState;
    [_gameView drawGameState:nextState];
    
    [self displayGameStatusText];
    if (nextState.status != TTTGameStatusInPlay) {
      _resetButton.hidden = NO;
    }
  }
}

- (void)displayGameStatusText {
  switch (_currentState.status) {
    case TTTGameStatusDraw:
      _gameStatusLabel.text = @"Draw!";
      break;
    case TTTGameStatusPlayerXWon:
      _gameStatusLabel.text = @"Player X Won!";
      break;
    case TTTGameStatusPlayerOWon:
      _gameStatusLabel.text = @"Player O Won!";
      break;
    default:
      _gameStatusLabel.text = [NSString stringWithFormat:@"Player %@'s Move", _currentState.currentPlayer];
      break;
  }
}

- (void)resetGame {
  [_gameView reset]; // Reset view
  _currentState = _gameTree; // Reset game state
  _resetButton.hidden = YES;
  [self displayGameStatusText];
}

@end
