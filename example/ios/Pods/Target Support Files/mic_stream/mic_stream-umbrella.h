#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "MicStreamPlugin.h"

FOUNDATION_EXPORT double mic_streamVersionNumber;
FOUNDATION_EXPORT const unsigned char mic_streamVersionString[];

