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
#import "PAG.h"

#import "PAGView.h"

PAG_API @interface PAGView (Audio)
/**
 * Return the value of audioEnable property.
 */
- (BOOL)audioEnable;

/**
 * If set false, will not play audio.
 */
- (void)setAudioEnable:(BOOL)enable;
@end
