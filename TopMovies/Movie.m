//
//  Movie.m
//  TopMovies
//
//  Created by Nhan Nguyen on 3/18/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "Movie.h"

@implementation Movie

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.title = dictionary[@"title"];
        self.synopsis = dictionary[@"synopsis"];
        
        NSMutableArray *cast = [[NSMutableArray alloc] init];
        for (NSDictionary* member in dictionary[@"abridged_cast"]) {
            [cast addObject:member[@"name"]];
        }
        self.cast = cast;
        
        self.bigPosterURL = [NSURL URLWithString:dictionary[@"posters"][@"original"]];
        self.smallPosterURL = [NSURL URLWithString:dictionary[@"posters"][@"profile"]];
    }
    
    return self;
}
@end
