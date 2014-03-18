//
//  MovieDetailViewController.h
//  TopMovies
//
//  Created by Nhan Nguyen on 3/17/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

@interface MovieDetailViewController : UIViewController
- (instancetype) initWithMovie:(Movie *)movie;
@end
