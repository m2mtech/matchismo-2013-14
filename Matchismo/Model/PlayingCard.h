//
//  PlayingCard.h
//  Matchismo
//
//  Created by Martin Mandl on 03.11.13.
//  Copyright (c) 2013 m2m server software gmbh. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

+ (NSArray *)validSuits;
+ (NSArray *)rankStrings;
+ (NSUInteger)maxRank;

@end
