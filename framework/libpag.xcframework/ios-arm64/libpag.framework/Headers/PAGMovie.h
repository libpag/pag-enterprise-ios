///////////////////////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2023 The Tencent Company Ltd. All rights reserved.
//
//  This file is part of the Enterprise Edition of the PAG (Portable Animated Graphics) project.
//
//  You may not use this file except holding valid commercial PAG licenses and in accordance with
//  the commercial license agreement provided with the Software or, alternatively, in accordance
//  with the terms contained in a written agreement between you and The Tencent Company.
//
///////////////////////////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>
#import "PAGImage.h"

/**
 * A movie used to replace the contents of PAGImageLayers in a PAGFile.
 */
PAG_API @interface PAGMovie : PAGImage

/**
 * Creates a PAGMovie from the video path, Return null if the file doesn't exist, or it isn't a
 * valid video file.
 * PAGMovie supports the mov,mp4,m4a,3gp,3g2 and mj2 container formats, and it supports the H264 and H265 encoding formats.
 */
+ (PAGMovie*)MakeFromFile:(NSString*)path;

/**
 * Creates a PAGMovie from the video path, Return null if the file doesn't exist, or it isn't a
 * valid video file，or the start time is more than the origin duration of this movie.
 * PAGMovie supports the mov,mp4,m4a,3gp,3g2 and mj2 container formats, and it supports the H264 and H265 encoding formats.
 *
 * If the duration and startTime are set to -1, the video will use the full length.
 *
 * @param startTime the start time of the movie in microseconds.
 * @param duration the duration of the movie in microseconds.
 * @param speed the speed of the movie.
 * @param volume the volume of the movie, which is usually in the range [0.0 - 1.0].
 */
+ (PAGMovie*)MakeFromFile:(NSString*)path
                startTime:(NSInteger)startTime
                 duration:(NSInteger)duration
                    speed:(CGFloat)speed
                   volume:(CGFloat)volume;

/**
 * Returns the duration of this movie in microseconds, it applies the speed of PAGMovie.
 */
- (NSInteger)duration;

@end

