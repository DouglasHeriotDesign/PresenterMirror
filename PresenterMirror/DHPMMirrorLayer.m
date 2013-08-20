//
//  DHPMMirrorLayer.m
//  PresenterMirror
//
//  Created by Douglas Heriot on 20/08/13.
//  Copyright (c) 2013 Douglas Heriot. All rights reserved.
//

#import "DHPMMirrorLayer.h"
#import <GLKit/GLKit.h>
#import <OpenGL/OpenGL.h>

@implementation DHPMMirrorLayer

- (void)drawInCGLContext:(CGLContextObj)ctx pixelFormat:(CGLPixelFormatObj)pf forLayerTime:(CFTimeInterval)t displayTime:(const CVTimeStamp *)ts
{
	glClearColor(0, 0, 0, 1);
	glClear(GL_COLOR_BUFFER_BIT);
}

- (BOOL)isAsynchronous
{
	return YES;
}

@end
