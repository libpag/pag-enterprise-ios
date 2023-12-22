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
 * The code is used to indicate whether a license is added successfully
 */
typedef enum {
    PAGLicenseResultSuccess,
    PAGLicenseResultInvalidParameter,
    PAGLicenseResultLicenseExpired,
} PAGLicenseResult;

/**
 * The manager is used to manage all licenses. You only need to add/load licenses to this manager.
 * When you load the encrypted PAG file, you can automatically decrypt the PAG file
 */
PAG_API @interface PAGLicenseManager : NSObject

/**
 * Load PAG Enterprise SDK license from the specified path.
 * Return InvalidParameter if the file doesn't exist or the data aren't a valid license file or the
 * license is not used for the current application, Return LicenseExpired if the license has expired.
 * Note: If load failure, the watermark will always be displayed. If load success,
 * the watermark can be removed.
 * Suggestion: If your application uses online license, at the beginning of your app startup,
 * first download the license file asynchronously, manage the license file yourself, and then
 * call LoadSDKLicense to load the downloaded license
 *
 * @param licensePath the local path of authentication file
 * @param key         the authentication key
 * @param appId       The license can only be used for the appId application
 */
+ (PAGLicenseResult)LoadSDKLicense:(NSString *)path key:(NSString *)key appID:(NSString *)appID;

/**
 * Load PAG Enterprise SDK license from the specified license bytes.
 * Return InvalidParameter if the data aren't a valid license file or the license is not used for
 * the current application, Return LicenseExpired if the license has expired.
 * Note: If load failure, the watermark will always be displayed. If load success,
 * the watermark can be removed.
 *
 * @param bytes the data bytes of authentication file
 * @param size  the size of bytes
 * @param key   the authentication key
 * @param appId The authentication can only be used for the appId application
 */
+ (PAGLicenseResult)LoadSDKLicense:(void *)bytes size:(NSUInteger)size key:(NSString *)key appID:(NSString *)appID;


/**
 * Add a license to the manager from the specified license path to decrypt the encrypted PAG file.
 * Return InvalidParameter if the file doesn't exist or the data aren't a valid license file or the
 * license is not used for the current application. Return LicenseExpired if the license has expired
 */
+ (PAGLicenseResult)AddFileLicense:(NSString *)path;

/**
 * Add a license to the manager from the specified license data to decrypt the encrypted PAG file.
 * Return InvalidParameter if the data are not a valid license file or the license is not used for
 * the current application, Return LicenseExpired if the license has expired.
 */
+ (PAGLicenseResult)AddFileLicense:(const void*)bytes size:(size_t)length;


+ (NSString*)GetSDKExpiredDate;

@end
