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
#import "PAG.h"

/**
 * PAGAudioSample describes a memory buffer that holds raw PCM bytes.
 */
PAG_API @interface PAGAudioSample : NSObject

@property(nonatomic, assign) NSInteger pts;

@property(nonatomic, assign) NSInteger duration;

@property(nonatomic, strong) NSData* data;

@end
