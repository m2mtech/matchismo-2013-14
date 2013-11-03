//
//  Deck.h
//  Matchismo
//
//  Created by Martin Mandl on 03.11.13.
//  Copyright (c) 2013 m2m server software gmbh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

- (void)addCard:(Card *)card atTop:(BOOL)atTop;
- (void)addCard:(Card *)card;

- (Card *)drawRandomCard;

@end


