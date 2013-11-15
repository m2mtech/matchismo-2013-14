//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by Martin Mandl on 09.11.13.
//  Copyright (c) 2013 m2m server software gmbh. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"

@interface PlayingCardGameViewController ()

@end

@implementation PlayingCardGameViewController

- (Deck *)createDeck
{
    self.gameType = @"Playing Cards";
    return [[PlayingCardDeck alloc] init];
}

@end
