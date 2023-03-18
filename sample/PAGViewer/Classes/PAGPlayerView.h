//
// Created by dom on 07/01/2018.
// Copyright (c) 2018 libpag.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <libpag/PAGComposition.h>

@interface PAGPlayerView : UIView

- (void)loadPAGAndPlay: (NSString*)pagPath;

- (void)stop;

- (NSInteger)numImages;

- (void)replaceMovie:(NSArray<NSString*>*)moviePaths;

- (PAGComposition*)getCurrentComposition;

@end
