//
//  TTTGameView.m
//  UnbeatableTicTacToe
//
//  Created by Charlie Weill on 12/8/14.
//  Copyright (c) 2014 Charlie Weill. All rights reserved.
//

#import "TTTGameView.h"
#import "TTTGameState.h"

@interface TTTGameView ()

@property (copy,nonatomic) NSArray *tiles;
@property (strong, nonatomic) UIView *horizontalBar1;
@property (strong, nonatomic) UIView *horizontalBar2;
@property (strong, nonatomic) UIView *verticalBar1;
@property (strong, nonatomic) UIView *verticalBar2;


@end

@implementation TTTGameView

- (instancetype)init {
  self = [super init];
  if (self) {
    NSMutableArray *temp = [NSMutableArray new];
    for (int i = 0; i < 9; i++) {
      UIButton *tile = [UIButton buttonWithType:UIButtonTypeCustom];
      [tile addTarget:self action:@selector(tileTapped:) forControlEvents:UIControlEventTouchUpInside];
      [tile setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
      [temp addObject:tile];
      [self addSubview:tile];
    }
    _tiles = temp;
    
    _horizontalBar1 = [UIView new];
    _horizontalBar1.backgroundColor = [UIColor blackColor];
    
    _horizontalBar2 = [UIView new];
    _horizontalBar2.backgroundColor = [UIColor blackColor];
    
    _verticalBar1 = [UIView new];
    _verticalBar1.backgroundColor = [UIColor blackColor];
    
    _verticalBar2 = [UIView new];
    _verticalBar2.backgroundColor = [UIColor blackColor];
    
    [self addSubview:_horizontalBar1];
    [self addSubview:_horizontalBar2];
    [self addSubview:_verticalBar1];
    [self addSubview:_verticalBar2];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  CGFloat tileWidth = self.bounds.size.width / 3;
  
  for (int i = 0; i< _tiles.count; i++) {
    UIButton *tile = _tiles[i];
    tile.frame = CGRectMake(tileWidth * (i % 3), tileWidth * (i / 3), tileWidth, tileWidth);
  }
  
  _horizontalBar1.frame = CGRectMake(0, tileWidth, self.bounds.size.width, 3);
  _horizontalBar2.frame = CGRectMake(0, tileWidth * 2, self.bounds.size.width, 3);
  _verticalBar1.frame = CGRectMake(tileWidth, 0, 3, self.bounds.size.width);
  _verticalBar2.frame = CGRectMake(tileWidth * 2, 0, 3, self.bounds.size.width);
}

- (void)drawGameState:(TTTGameState *)gameState {
  for (int i=0; i<gameState.state.count; i++) {
    [_tiles[i] setTitle:gameState.state[i] forState:UIControlStateNormal];
  }
}

- (void)tileTapped:(UIButton *)sender {
  NSUInteger tileID = [_tiles indexOfObject:sender];
  [self.delegate gameView:self didTapTile:tileID];
}

@end
