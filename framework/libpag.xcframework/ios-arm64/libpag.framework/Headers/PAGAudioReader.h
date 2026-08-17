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
#import "PAGAudioSample.h"
#import "PAGComposition.h"

/**
 * An audio reader used to obtain the audio frames of a PAGComposition.
 */
PAG_API @interface PAGAudioReader : NSObject

/**
 * Creates a PAGAudioReader to read audio frame
 * @param sampleRate the sample rate of output audio frame
 * @param sampleCount the sample count of output audio frame
 * @param channels the channel count of output audio frame
 * @param volume the volume of output audio frame which is usually in the range [0 - 1.0].
 */
+ (instancetype)MakeWithSampleRate:(NSInteger)sampleRate sampleCount:(NSInteger)sampleCount channels:(NSInteger)channels volume:(CGFloat)volume;

/**
 * Sets a new PAGComposition for PAGAudioReader to play as content.
 * Note: If the composition is already added to another PAGAudioReader, it will be removed from
 * the previous PAGAudioReader.
 */
- (void)setComposition:(PAGComposition*)newComposition;

/**
 * Seeks to the specified target time.
 */
- (void)seek:(NSInteger)time;

/**
 * Read the next audio frame.
 * output format: PCM Signed 16
 * if channels == 1, channel layout is MONO
 * if channels == 2, channel layout is STEREO
 */
- (PAGAudioSample*)readNextSample;

/**
 * Returns false if current composition has audio output, e.g. The PAG File has audio bytes or
 * An movie have replaced the contents of PAGImageLayers in a PAGFile
 */
- (BOOL)isEmpty;

@end

