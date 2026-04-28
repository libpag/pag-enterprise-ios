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

#import "PAGComposition.h"

typedef enum {
    PAGExportVideoProfileBaseline,
    PAGExportVideoProfileHigh
} PAGExportVideoProfile;

typedef enum {
    PAGExportStatusUnKnow,
    PAGExportStatusExporting,
    PAGExportStatusFailed,
    PAGExportStatusCanceled,
    PAGExportStatusComplete
} PAGExportStatus;

PAG_API @interface PAGExportConfig : NSObject

@property (nonatomic, copy) NSString *outputPath;

@property (nonatomic, assign) NSInteger sampleRate;

@property (nonatomic, assign) NSInteger channels;

@property (nonatomic, assign) NSInteger audioBitrate;

@property (nonatomic, assign) NSInteger videoBitrate;

@property (nonatomic, assign) NSInteger width;

@property (nonatomic, assign) NSInteger height;

@property (nonatomic, assign) NSInteger frameRate;

@property (nonatomic, assign) PAGExportVideoProfile profile;

@end

@protocol PAGExportCallback<NSObject>
@required
- (void)onProgress:(CGFloat)progress;

- (void)onStatusChange:(PAGExportStatus)status msgs:(NSArray<NSString *> *)msgs;

@end

/**
 * Export the composition to MP4 file.
 */
PAG_API @interface PAGMovieExporter : NSObject

/**
 * Create a movie Exporter with the specified composition and output movie config.
 */
+ (instancetype)Make:(PAGComposition *)composition config:(PAGExportConfig *)config callback:(id<PAGExportCallback>)callback;

/**
 * Start exporting movie asynchronously
 */
- (void)start;

/**
 * Cancel exporting movie
 */
- (void)cancel;

@end
