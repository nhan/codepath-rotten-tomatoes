//
//  Movie.h
//  TopMovies
//
//  Created by Nhan Nguyen on 3/18/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Movie : NSObject
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* synopsis;
@property (nonatomic, strong) NSArray* cast;
@property (nonatomic, strong) NSURL* smallPosterURL;
@property (nonatomic, strong) NSURL* bigPosterURL;
- (instancetype)initWithDictionary:(NSDictionary*)dictionary;
@end
