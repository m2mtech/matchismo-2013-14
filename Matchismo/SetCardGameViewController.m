//
//  SetCardGameViewController.m
//  Matchismo
//
//  Created by Martin Mandl on 13.11.13.
//  Copyright (c) 2013 m2m server software gmbh. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetCardDeck.h"
#import "CardMatchingGame.h"

@interface SetCardGameViewController ()

@end

@implementation SetCardGameViewController

- (Deck *)createDeck
{
    return [[SetCardDeck alloc] init];
}

@end
