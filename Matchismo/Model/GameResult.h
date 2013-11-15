//
//  GameResult.h
//  Matchismo
//
//  Created by Martin Mandl on 15.11.13.
//  Copyright (c) 2013 m2m server software gmbh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameResult : NSObject

+ (NSArray *)allGameResults; // of GameResults

@property (readonly, nonatomic) NSDate *start;
@property (readonly, nonatomic) NSDate *end;
@property (readonly, nonatomic) NSTimeInterval duration;
@property (nonatomic) int score;
@property (strong, nonatomic) NSString *gameType;

- (NSComparisonResult)compareScore:(GameResult *)result;
- (NSComparisonResult)compareDuration:(GameResult *)result;

@end
